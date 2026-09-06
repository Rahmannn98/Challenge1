import SwiftUI

extension Color {
    static let themePrimary = Color(red: 0.16, green: 0.32, blue: 0.30)
    static let themeSecondary = Color(red: 0.36, green: 0.58, blue: 0.52)
    static let themeTertiary = Color(red: 0.94, green: 0.97, blue: 0.93)
    static let themeQuaternary = Color(red: 0.82, green: 0.91, blue: 0.78)
}

extension Notification.Name {
    static let returnToHome = Notification.Name("returnToHome")
}

extension View {
    @ViewBuilder
    func practiceGlassCard(cornerRadius: CGFloat) -> some View {
        if #available(iOS 26.0, *) {
            self
                .glassEffect(.regular, in: .rect(cornerRadius: cornerRadius))
        } else {
            self
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(Color.white.opacity(0.78))
                        .shadow(color: Color.themeSecondary.opacity(0.14), radius: 18, y: 10)
                )
        }
    }

    @ViewBuilder
    func practiceInteractiveGlass(cornerRadius: CGFloat) -> some View {
        if #available(iOS 26.0, *) {
            self
                .glassEffect(.regular.interactive(), in: .rect(cornerRadius: cornerRadius))
        } else {
            self
                .background(Color.themeSecondary.opacity(0.14))
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        }
    }

    @ViewBuilder
    func practicePrimaryAction() -> some View {
        if #available(iOS 26.0, *) {
            self
                .buttonStyle(.glassProminent)
                .tint(.themePrimary)
        } else {
            self
                .background(Color.themePrimary)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
    }

    @ViewBuilder
    func practiceSecondaryAction() -> some View {
        if #available(iOS 26.0, *) {
            self
                .buttonStyle(.glass)
                .tint(.themePrimary)
        } else {
            self
                .background(Color.themeQuaternary)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
    }
}
