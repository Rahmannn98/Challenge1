import CoreText
import SwiftUI

enum AppFontRegistrar {
    static func registerFonts() {
        ["PlusJakartaSans-Regular"].forEach { fileName in
            let url = Bundle.main.url(forResource: fileName, withExtension: "ttf")
                ?? Bundle.main.url(forResource: fileName, withExtension: "ttf", subdirectory: "Fonts")
            guard let url else { return }
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
    }
}

enum AppSpacing {
    static let screen: CGFloat = 24
    static let card: CGFloat = 16
}

enum AppRadius {
    static let medium: CGFloat = 14
    static let large: CGFloat = 20
    static let extraLarge: CGFloat = 28
    static let pill: CGFloat = 999
}

extension Color {
    static let themePrimary = Color(red: 0.02, green: 0.16, blue: 0.19)
    static let themeSecondary = Color(red: 0.32, green: 0.55, blue: 0.57)
    static let themeTertiary = Color(red: 0.96, green: 0.98, blue: 0.97)
    static let themeQuaternary = Color(red: 0.77, green: 0.93, blue: 0.86)
    static let themeMint = Color(red: 0.20, green: 0.72, blue: 0.58)
    static let themeSky = Color(red: 0.78, green: 0.91, blue: 0.98)
    static let themeRose = Color(red: 0.98, green: 0.84, blue: 0.89)
    static let themePeach = Color(red: 1.00, green: 0.88, blue: 0.80)
    static let themeInkMuted = Color(red: 0.40, green: 0.51, blue: 0.54)
}

extension Notification.Name {
    static let returnToHome = Notification.Name("returnToHome")
}

extension Font {
    static func jakarta(_ size: CGFloat, weight: Weight = .regular) -> Font {
        .custom("PlusJakartaSans-Regular", size: size).weight(weight)
    }
}

extension TopicAccentColor {
    var background: Color {
        switch self {
        case .mint:
            return Color.themeQuaternary.opacity(0.6)
        case .peach:
            return Color.themePeach.opacity(0.62)
        case .rose:
            return Color.themeRose.opacity(0.62)
        case .sky:
            return Color.themeSky.opacity(0.72)
        case .lavender:
            return Color(red: 0.88, green: 0.86, blue: 1.0).opacity(0.72)
        }
    }

    var foreground: Color {
        switch self {
        case .mint:
            return Color.themeMint
        case .peach:
            return Color(red: 0.95, green: 0.38, blue: 0.26)
        case .rose:
            return Color(red: 0.91, green: 0.31, blue: 0.44)
        case .sky:
            return Color(red: 0.25, green: 0.55, blue: 0.92)
        case .lavender:
            return Color(red: 0.47, green: 0.38, blue: 0.86)
        }
    }
}

extension View {
    func appScreenBackground() -> some View {
        self.background(
            LinearGradient(
                colors: [Color.white, Color.themeTertiary, Color.white],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }

    @ViewBuilder
    func practiceGlassCard(cornerRadius: CGFloat) -> some View {
        if #available(iOS 26.0, *) {
            self
                .glassEffect(.regular, in: .rect(cornerRadius: cornerRadius))
        } else {
            self
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(Color.white.opacity(0.88))
                        .shadow(color: Color.themePrimary.opacity(0.08), radius: 18, y: 10)
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
                .background(Color.white.opacity(0.9))
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                .shadow(color: Color.themePrimary.opacity(0.06), radius: 14, y: 8)
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
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.large, style: .continuous))
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
                .background(Color.white.opacity(0.92))
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.large, style: .continuous))
                .shadow(color: Color.themePrimary.opacity(0.06), radius: 12, y: 6)
        }
    }
}
