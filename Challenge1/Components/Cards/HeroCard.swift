import SwiftUI

struct HeroCard: View {
    let title: String
    let subtitle: String
    let imageName: String

    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.title2.bold())
                    .foregroundStyle(Color.themePrimary)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(Color.themeSecondary)
            }

            Spacer()

            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 110, height: 110)
        }
        .padding(20)
        .practiceGlassCard(cornerRadius: 22)
    }
}
