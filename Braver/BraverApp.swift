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

private struct SubscriptionLockedView: View {
    let onRestore: () -> Void
    let onStartOver: () -> Void

    @State private var isRestoring = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 20) {
                Spacer()

                Image(systemName: "lock.fill")
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundColor(.white.opacity(0.5))

                Text("Necesitas una suscripción activa para continuar")
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                Spacer()

                Button {
                    Superwall.shared.register(placement: "campaign_trigger")
                } label: {
                    Text("Ver planes")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(Color.white)
                        .cornerRadius(14)
                }

                Button {
                    guard !isRestoring else { return }
                    isRestoring = true
                    onRestore()
                    Task {
                        try? await Task.sleep(for: .seconds(1.5))
                        await MainActor.run { isRestoring = false }
                    }
                } label: {
                    Text(isRestoring ? "Restaurando…" : "Restaurar compra")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.top, 4)

                Button(action: onStartOver) {
                    Text("Empezar de nuevo")
                        .font(.system(size: 13, design: .rounded))
                        .foregroundColor(.white.opacity(0.35))
                }
                .padding(.top, 8)
                .padding(.bottom, 24)
            }
            .padding(.horizontal, 32)
        }
    }
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
    @State private var isSubscribed = false
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
                        SubscriptionLockedView(
                            onRestore: {
                                Task {
                                    let result = await Superwall.shared.restorePurchases()
                                    await MainActor.run {
                                        if case .restored = result {
                                            NotificationCenter.default.post(name: .braverSubscriptionChanged, object: nil)
                                        }
                                    }
                                }
                            },
                            onStartOver: {
                                UserDefaults.standard.removeObject(forKey: "braver_onboarding_step")
                                withAnimation(.easeInOut(duration: 0.35)) {
                                    onboardingDone = false
                                }
                            }
                        )
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
