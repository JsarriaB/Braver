import SwiftUI
import SwiftData

@main
struct BraverApp: App {
    @State private var showSplash = true
    @State private var onboardingDone = UserDefaults.standard.bool(forKey: "braver_onboarding_completed")

    var body: some Scene {
        WindowGroup {
            ZStack {
                if onboardingDone {
                    ContentView()
                        .preferredColorScheme(.dark)

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
