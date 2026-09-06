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
