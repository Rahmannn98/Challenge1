import SwiftUI

struct OnboardingRootView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false

    var body: some View {
        if hasSeenOnboarding {
            ContentView()
        } else {
            OnboardingView {
                hasSeenOnboarding = true
            }
        }
    }
}
