import SwiftUI
import SwiftData
import UserNotifications
import FirebaseCore
import FirebaseAppCheck
import FirebaseAuth
import GoogleSignIn
import SuperwallKit
import StoreKit

let sharedSuperwallDelegate = BraverSuperwallDelegate()

final class BraverSuperwallDelegate: SuperwallDelegate {
    var autoDismissTask: Task<Void, Never>?

    func handleCustomPaywallAction(withName name: String) {
        let lower = name.lowercased()
        guard lower.contains("redeem") || lower.contains("code") || lower.contains("offer") else { return }
        guard let scene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else { return }
        Task { @MainActor in
            try? await AppStore.presentOfferCodeRedeemSheet(in: scene)
        }
    }

    func subscriptionStatusDidChange(to newValue: SuperwallKit.SubscriptionStatus) {
        NotificationCenter.default.post(name: .braverSubscriptionChanged, object: nil)
    }

    func launchSpecialOffer() {
        let alreadyShown = UserDefaults.standard.bool(forKey: "braver_special_offer_shown")
        print("🟣 launchSpecialOffer called. alreadyShown:", alreadyShown)
        guard !alreadyShown else {
            print("🔴 special offer blocked — braver_special_offer_shown is true")
            return
        }
        let handler = PaywallPresentationHandler()
        handler.onPresent { [weak self] _ in
            print("🟢 offer_trigger presented")
            let iso = ISO8601DateFormatter().string(from: Date())
            Superwall.shared.setUserAttributes(["specialOfferShownAt": iso])
            UserDefaults.standard.set(true, forKey: "braver_special_offer_shown")
            self?.autoDismissTask?.cancel()
            self?.autoDismissTask = Task {
                do {
                    try await Task.sleep(for: .seconds(300))
                    guard !Task.isCancelled else { return }
                    await MainActor.run {
                        print("🟢 auto dismissing offer_trigger after 300s")
                        Superwall.shared.dismiss()
                    }
                } catch {
                    return
                }
            }
        }
        handler.onDismiss { [weak self] _, result in
            print("🟡 offer_trigger dismissed with result:", result)
            self?.autoDismissTask?.cancel()
            self?.autoDismissTask = nil
        }
        handler.onError { error in
            print("🔴 offer_trigger error:", error)
        }
        handler.onSkip { reason in
            print("🟠 offer_trigger skipped:", reason)
        }
        print("🟣 registering offer_trigger")
        Superwall.shared.register(placement: "offer_trigger", handler: handler)
    }
}

extension Notification.Name {
    static let braverSubscriptionChanged = Notification.Name("braverSubscriptionChanged")
}

final class BraverAppCheckProviderFactory: NSObject, AppCheckProviderFactory {
    func createProvider(with app: FirebaseApp) -> AppCheckProvider? {
        if #available(iOS 14.0, *) {
            return AppAttestProvider(app: app)
        } else {
            return DeviceCheckProvider(app: app)
        }
    }
}

@main
struct BraverApp: App {
    @State private var showSplash = true
    @State private var isSubscribed = true
    @AppStorage("braver_onboarding_completed") private var onboardingDone = false

    init() {
        AppCheck.setAppCheckProviderFactory(BraverAppCheckProviderFactory())
        FirebaseApp.configure()
        Superwall.configure(apiKey: "pk_TFOGLLVYZuTBq3LqMxbCD")
        Superwall.shared.delegate = sharedSuperwallDelegate
    }

    private func updateSubscriptionState() {
        if case .active = Superwall.shared.subscriptionStatus {
            isSubscribed = true
        } else {
            isSubscribed = false
        }
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                if onboardingDone {
                    if isSubscribed {
                        ContentView()
                            .preferredColorScheme(.dark)
                            .onAppear {
                                UNUserNotificationCenter.current().getNotificationSettings { settings in
                                    if settings.authorizationStatus == .authorized {
                                        DispatchQueue.main.async { NotificationService.scheduleAll() }
                                    }
                                }
                            }
                    } else {
                        ZStack {
                            Color.black.ignoresSafeArea()
                        }
                        .onAppear {
                            Superwall.shared.register(placement: "campaign_trigger")
                        }
                        .preferredColorScheme(.dark)
                    }

                    if showSplash {
                        SplashView {
                            showSplash = false
                        }
                        .preferredColorScheme(.dark)
                        .transition(.opacity)
                        .zIndex(1)
                    }
                } else {
                    OnboardingView {
                        updateSubscriptionState()
                        withAnimation(.easeInOut(duration: 0.5)) {
                            onboardingDone = true
                        }
                    }
                    .preferredColorScheme(.dark)
                }
            }
            .animation(.easeInOut(duration: 0.35), value: showSplash)
            .onOpenURL { url in
                GIDSignIn.sharedInstance.handle(url)
            }
            .onAppear {
                updateSubscriptionState()
                Task {
                    await AuthService.shared.signInAnonymouslyIfNeeded()
                    if let uid = AuthService.shared.userId {
                        Superwall.shared.setUserAttributes(["firebaseUid": uid])
                    }
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: .braverSubscriptionChanged)) { _ in
                updateSubscriptionState()
            }
        }
        .modelContainer(for: [
            UserProfile.self,
            Reto.self,
            RetoVariant.self,
            ChallengeCompletion.self,
            MomentoSession.self,
            PreparateSession.self
        ])
    }
}
