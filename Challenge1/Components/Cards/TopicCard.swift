import SwiftUI

struct TopicCard: View {
    let topic: SpeakingTopic

    var body: some View {
        let style = TopicCardStyle.style(for: topic)

        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                ZStack {
                    RoundedRectangle(cornerRadius: AppRadius.medium, style: .continuous)
                        .fill(style.iconBackground)

                    Image(systemName: topic.symbolName)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(style.iconForeground)
                }
                .frame(width: 48, height: 48)

                Spacer(minLength: 0)

                Image(systemName: "chevron.right")
                    .font(.jakarta(12, relativeTo: .caption, weight: .bold))
                    .foregroundStyle(style.iconForeground.opacity(0.8))
                    .padding(.top, 4)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(topic.title)
                    .font(.jakarta(17, relativeTo: .headline, weight: .bold))
                    .foregroundStyle(style.titleColor)
                    .lineLimit(1)

                Text(topic.subtitle)
                    .font(.jakarta(12, relativeTo: .caption, weight: .medium))
                    .foregroundStyle(style.subtitleColor)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: 156, alignment: .leading)
        .background(style.background)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.large, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: AppRadius.large, style: .continuous)
                .strokeBorder(Color.white.opacity(0.65), lineWidth: 1)
        )
        .shadow(color: Color.brandPlum.opacity(0.04), radius: 10, y: 5)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(topic.title), \(topic.subtitle)")
        .accessibilityHint("Opens practice setup for \(topic.title).")
    }
}

#Preview {
    HStack(spacing: 12) {
        TopicCard(topic: TopicPreset.education.topic)
        TopicCard(topic: TopicPreset.career.topic)
    }
    .padding()
    .background(Color.appBackground)
}
