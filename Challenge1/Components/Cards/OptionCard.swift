import SwiftUI

struct OptionCard: View {
    let topic: SpeakingTopic

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: AppRadius.medium, style: .continuous)
                    .fill(Color.white.opacity(0.42))

                Image(systemName: topic.symbolName)
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(topic.accentColor.foreground)
            }
            .frame(width: 56, height: 56)

            VStack(alignment: .leading, spacing: 5) {
                Text(topic.title)
                    .font(.jakarta(16, weight: .bold))
                    .foregroundStyle(Color.themePrimary)
                    .lineLimit(1)

                Text(topic.subtitle)
                    .font(.jakarta(11, weight: .medium))
                    .foregroundStyle(Color.themeInkMuted)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)

            Image(systemName: "chevron.right")
                .font(.jakarta(13, weight: .bold))
                .foregroundStyle(topic.accentColor.foreground)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: 154, alignment: .leading)
        .background(topic.accentColor.background)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.large, style: .continuous))
    }
}
