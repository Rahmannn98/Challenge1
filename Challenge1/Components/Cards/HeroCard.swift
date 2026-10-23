
import SwiftUI

struct HeroCard: View {
    let title: String
    let subtitle: String
    let imageName: String

    var body: some View {
        ZStack(alignment: .leading) {
            GeometryReader { geometry in
                Image(imageName.isEmpty ? "background1" : imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height
                    )
                    .clipped()
            }

            LinearGradient(
                colors: [
                    Color.black.opacity(0.48),
                    Color.black.opacity(0.18),
                    Color.clear
                ],
                startPoint: .leading,
                endPoint: .trailing
            )

            VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .font(.jakarta(26, relativeTo: .title2, weight: .bold))
                    .foregroundStyle(.white)
                    .fixedSize(horizontal: false, vertical: true)

                Text(subtitle)
                    .font(.jakarta(14, relativeTo: .subheadline, weight: .medium))
                    .foregroundStyle(.white.opacity(0.88))
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(24)
            .frame(maxWidth: 280, alignment: .leading)
        }
        .frame(height: 220)
        .clipShape(
            RoundedRectangle(
                cornerRadius: AppRadius.extraLarge,
                style: .continuous
            )
        )
        .overlay {
            RoundedRectangle(
                cornerRadius: AppRadius.extraLarge,
                style: .continuous
            )
            .strokeBorder(.white.opacity(0.16), lineWidth: 1)
        }
        .shadow(
            color: Color.brandPlum.opacity(0.12),
            radius: 14,
            y: 6
        )
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    HeroCard(
        title: "Speak Confidently",
        subtitle: "Practice real conversations with the PREP method.",
        imageName: "background1"
    )
    .padding()
    .appScreenBackground()
}
