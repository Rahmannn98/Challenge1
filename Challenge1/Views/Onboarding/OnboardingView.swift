import SwiftUI

struct OnboardingView: View {
    let onStart: () -> Void

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Spacer()

                Button("Skip") {
                    onStart()
                }
                .font(.jakarta(13, weight: .bold))
                .foregroundStyle(Color.themePrimary)
            }
            .padding(.top, 18)

            Spacer(minLength: 0)

            ZStack(alignment: .topTrailing) {
                Image("Monyet4")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 190)

                Image(systemName: "sparkles")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(Color(red: 1.0, green: 0.72, blue: 0.22))
                    .offset(x: 28, y: 8)
            }

            VStack(spacing: 12) {
                Text("Speak Better\nwith PREP")
                    .font(.jakarta(32, weight: .bold))
                    .foregroundStyle(Color.themePrimary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(1)

                Text("A simple structure to organize\nyour thoughts and speak with confidence.")
                    .font(.jakarta(14, weight: .medium))
                    .foregroundStyle(Color.themeSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }

            LazyVGrid(columns: columns, spacing: 12) {
                stageCard(.point, subtitle: "State your main idea", color: .themeQuaternary)
                stageCard(.reason, subtitle: "Give your reason", color: .themeSky)
                stageCard(.example, subtitle: "Share a real example", color: .themeRose)
                stageCard(.closingPoint, subtitle: "Wrap it up", color: .themePeach)
            }

            HStack(spacing: 6) {
                Circle().fill(Color.themeMint).frame(width: 8, height: 8)
                Circle().fill(Color.themeSecondary.opacity(0.22)).frame(width: 6, height: 6)
                Circle().fill(Color.themeSecondary.opacity(0.22)).frame(width: 6, height: 6)
            }
            .padding(.top, 2)

            Button {
                onStart()
            } label: {
                Label("Let's Start", systemImage: "arrow.right")
                    .font(.jakarta(16, weight: .bold))
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 17)
            }
            .practicePrimaryAction()

            Spacer(minLength: 8)
        }
        .padding(.horizontal, AppSpacing.screen)
        .appScreenBackground()
        .font(.jakarta(15))
    }

    private func stageCard(_ stage: PREPStage, subtitle: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(stage.shortTitle)
                .font(.jakarta(18, weight: .bold))
                .foregroundStyle(Color.white)
                .frame(width: 42, height: 42)
                .background(stageTint(for: stage))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 5) {
                Text(stage.title)
                    .font(.jakarta(14, weight: .bold))
                    .foregroundStyle(Color.themePrimary)

                Text(subtitle)
                    .font(.jakarta(11, weight: .medium))
                    .foregroundStyle(Color.themeSecondary)
                    .lineLimit(2)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 104, alignment: .leading)
        .padding(14)
        .background(color.opacity(0.72))
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.large, style: .continuous))
    }

    private func stageTint(for stage: PREPStage) -> Color {
        switch stage {
        case .point:
            return .themeMint
        case .reason:
            return Color(red: 0.26, green: 0.57, blue: 0.94)
        case .example:
            return Color(red: 0.88, green: 0.24, blue: 0.43)
        case .closingPoint:
            return Color(red: 0.96, green: 0.36, blue: 0.28)
        }
    }
}

#Preview {
    OnboardingView(onStart: {})
}
