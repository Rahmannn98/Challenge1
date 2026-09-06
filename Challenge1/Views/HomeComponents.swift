import SwiftUI

struct Header: View {
    let greetingText: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(greetingText)
                .font(.largeTitle.bold())
                .foregroundColor(.themePrimary)

            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.themeSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

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

struct OptionCard: View {
    let title: String
    let imageName: String

    var body: some View {
        HStack(spacing: 16) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 86, height: 86)
                .background(Color.white.opacity(0.34))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

            Text(title)
                .font(.title3.bold())
                .foregroundStyle(Color.themePrimary)
                .frame(maxWidth: .infinity, alignment: .leading)

            Image(systemName: "chevron.right")
                .font(.headline.weight(.bold))
                .foregroundStyle(Color.themeSecondary)
        }
        .padding(16)
        .practiceInteractiveGlass(cornerRadius: 18)
    }
}
