import SwiftUI

struct PREPStageProgressView: View {
    let stages: [PREPStage]
    var activeStage: PREPStage = .point

    var body: some View {
        HStack(spacing: 10) {
            ForEach(stages) { stage in
                VStack(spacing: 6) {
                    Text(stage.shortTitle)
                        .font(.jakarta(17, weight: .bold))
                        .foregroundStyle(stage == activeStage ? Color.white : stageColor(for: stage))
                        .frame(width: 44, height: 44)
                        .background(stage == activeStage ? stageColor(for: stage) : stageColor(for: stage).opacity(0.14))
                        .clipShape(Circle())

                    Text(stage.title)
                        .font(.jakarta(11, weight: .bold))
                        .foregroundStyle(Color.themePrimary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(14)
        .background(Color.white.opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.large, style: .continuous))
        .shadow(color: Color.themePrimary.opacity(0.07), radius: 16, y: 8)
    }

    private func stageColor(for stage: PREPStage) -> Color {
        switch stage {
        case .point:
            return .themeMint
        case .reason:
            return Color(red: 0.43, green: 0.36, blue: 0.84)
        case .example:
            return Color(red: 0.88, green: 0.24, blue: 0.43)
        case .closingPoint:
            return Color(red: 0.96, green: 0.36, blue: 0.28)
        }
    }
}
