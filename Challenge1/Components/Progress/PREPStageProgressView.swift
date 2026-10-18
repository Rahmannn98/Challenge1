import SwiftUI

struct PREPStageProgressView: View {
    let stages: [PREPStage]
    var activeStage: PREPStage = .point

    var body: some View {
        HStack(spacing: 10) {
            ForEach(stages) { stage in
                let isActive = stage == activeStage
                VStack(spacing: 6) {
                    Text(stage.shortTitle)
                        .font(.jakarta(17, relativeTo: .subheadline, weight: .bold))
                        .foregroundStyle(isActive ? Color.white : stageColor(for: stage))
                        .frame(width: 44, height: 44)
                        .background(
                            isActive ? stageColor(for: stage) : stageColor(for: stage).opacity(0.14)
                        )
                        .clipShape(Circle())
                        .shadow(
                            color: isActive ? stageColor(for: stage).opacity(0.25) : Color.clear,
                            radius: 6,
                            y: 3
                        )

                    Text(stage.title)
                        .font(.jakarta(11, relativeTo: .caption2, weight: .bold))
                        .foregroundStyle(Color.appTextPrimary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(14)
        .background(Color.white.opacity(0.94))
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.large, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: AppRadius.large, style: .continuous)
                .strokeBorder(Color.brandLavender.opacity(0.25), lineWidth: 1)
        )
        .shadow(color: Color.brandPlum.opacity(0.06), radius: 14, y: 7)
    }

    private func stageColor(for stage: PREPStage) -> Color {
        switch stage {
        case .point:
            return Color.brandPlum
        case .reason:
            return Color.brandDeepLavender
        case .example:
            return Color.brandMutedPurple
        case .closingPoint:
            return Color(red: 0.65, green: 0.28, blue: 0.55)
        }
    }
}
