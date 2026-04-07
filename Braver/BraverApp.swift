import SwiftUI
import SwiftData
import UserNotifications
import FirebaseCore
import FirebaseAppCheck

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
    @State private var onboardingDone = UserDefaults.standard.bool(forKey: "braver_onboarding_completed")

    init() {
        AppCheck.setAppCheckProviderFactory(BraverAppCheckProviderFactory())
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                if onboardingDone {
                    ContentView()
                        .preferredColorScheme(.dark)
                        .onAppear {
                            UNUserNotificationCenter.current().getNotificationSettings { settings in
                                if settings.authorizationStatus == .authorized {
                                    DispatchQueue.main.async { NotificationService.scheduleAll() }
                                }
                            }
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
                        withAnimation(.easeInOut(duration: 0.5)) {
                            onboardingDone = true
                        }
                    }
                    .preferredColorScheme(.dark)
                }
            }
            .animation(.easeInOut(duration: 0.35), value: showSplash)
        }
        .modelContainer(for: [
            UserProfile.self,
            Reto.self,
            RetoVariant.self,
            ChallengeCompletion.self,
            MomentoSession.self
        ])
    }
}
