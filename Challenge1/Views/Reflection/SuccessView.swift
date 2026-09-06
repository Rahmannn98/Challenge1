import SwiftUI

struct SuccessView: View {
    let onDone: () -> Void

    @State private var heroBounce = false

    var body: some View {
        VStack(spacing: 26) {
            Spacer(minLength: 20)

            ZStack {
                Circle()
                    .fill(Color.themeQuaternary.opacity(0.6))
                    .frame(width: 248, height: 248)
                    .scaleEffect(heroBounce ? 1.04 : 0.94)

                Image("Monyet4")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 230, height: 230)
                    .offset(y: heroBounce ? -8 : 8)
                    .shadow(color: Color.themeMint.opacity(0.24), radius: 24, y: 14)
            }
            .frame(height: 270)

            VStack(spacing: 12) {
                Text("Practice Complete")
                    .font(.jakarta(32, weight: .bold))
                    .foregroundStyle(Color.themePrimary)
                    .multilineTextAlignment(.center)

                Text("Your PREP speaking session is saved. Keep practicing to build clearer, more confident answers.")
                    .font(.jakarta(14, weight: .medium))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.themeSecondary)
                    .lineSpacing(4)
                    .padding(.horizontal, 8)
            }

            HStack(spacing: 12) {
                completionBadge("checkmark.seal.fill", "Completed")
                completionBadge("flame.fill", "Streak +1")
            }

            Button {
                handleDone()
            } label: {
                Label("Back Home", systemImage: "house.fill")
                    .font(.jakarta(16, weight: .bold))
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 17)
            }
            .practicePrimaryAction()

            Spacer(minLength: 20)
        }
        .frame(maxWidth: 720)
        .padding(.horizontal, AppSpacing.screen)
        .appScreenBackground()
        .font(.jakarta(15))
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.25).repeatForever(autoreverses: true)) {
                heroBounce = true
            }
        }
    }

    private func completionBadge(_ symbolName: String, _ title: String) -> some View {
        Label(title, systemImage: symbolName)
            .font(.jakarta(13, weight: .bold))
            .foregroundStyle(Color.themePrimary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.white.opacity(0.92))
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.large, style: .continuous))
            .shadow(color: Color.themePrimary.opacity(0.05), radius: 12, y: 6)
    }

    private func handleDone() {
        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(150))
            onDone()
        }
    }
}

#Preview {
    SuccessView(onDone: {})
}
