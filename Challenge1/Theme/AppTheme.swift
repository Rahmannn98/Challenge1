import CoreText
import SwiftUI

// MARK: - Font Registration

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

// MARK: - Spacing Tokens

enum AppSpacing {
    static let tiny: CGFloat = 4
    static let small: CGFloat = 8
    static let medium: CGFloat = 12
    static let card: CGFloat = 16
    static let screen: CGFloat = 24
    static let large: CGFloat = 32
}

// MARK: - Corner Radius Tokens

enum AppRadius {
    static let small: CGFloat = 8
    static let medium: CGFloat = 14
    static let large: CGFloat = 20
    static let extraLarge: CGFloat = 28
    static let pill: CGFloat = 999
}

// MARK: - Brand & Semantic Color Tokens

extension Color {
    // 4 Core Brand Colors
    /// Lavender: #C4A4DA
    static let brandLavender = Color(red: 0.7686, green: 0.6431, blue: 0.8549)
    /// Muted Purple: #9E7EB5
    static let brandMutedPurple = Color(red: 0.6196, green: 0.4941, blue: 0.7098)
    /// Deep Lavender: #7F5D99
    static let brandDeepLavender = Color(red: 0.4980, green: 0.3647, blue: 0.6000)
    /// Plum: #4C2365
    static let brandPlum = Color(red: 0.2980, green: 0.1373, blue: 0.3961)

    // Semantic Color Tokens
    static let appPrimary = brandPlum
    static let appSecondary = brandDeepLavender
    static let appAccent = brandMutedPurple
    static let appBackground = Color(red: 0.980, green: 0.972, blue: 0.988) // #FAF7FC
    static let appSurface = Color.white
    static let appSurfaceSecondary = Color(red: 0.957, green: 0.933, blue: 0.973) // #F4EEF8
    static let appSurfaceTertiary = Color(red: 0.929, green: 0.898, blue: 0.953)  // #EDE5F3
    static let appTextPrimary = brandPlum
    static let appTextSecondary = brandDeepLavender
    static let appBorder = brandLavender.opacity(0.3)
    static let appSelected = brandPlum
    static let appSuccess = Color(red: 0.18, green: 0.64, blue: 0.48)
    static let appError = Color(red: 0.85, green: 0.28, blue: 0.38)

    // Legacy theme mappings (mapped directly to purple system for 100% cohesion)
    static let themePrimary = appPrimary
    static let themeSecondary = appSecondary
    static let themeTertiary = appSurfaceSecondary
    static let themeQuaternary = brandLavender.opacity(0.35)
    static let themeMint = brandDeepLavender
    static let themeSky = brandMutedPurple.opacity(0.35)
    static let themeRose = Color(red: 0.93, green: 0.84, blue: 0.91)
    static let themePeach = Color(red: 0.95, green: 0.88, blue: 0.94)
    static let themeInkMuted = brandDeepLavender.opacity(0.85)
}

// MARK: - Notifications

extension Notification.Name {
    static let returnToHome = Notification.Name("returnToHome")
}

// MARK: - Typography

extension Font {
    static func jakarta(
        _ size: CGFloat,
        relativeTo textStyle: Font.TextStyle = .body,
        weight: Weight = .regular
    ) -> Font {
        .custom("PlusJakartaSans-Regular", size: size, relativeTo: textStyle)
            .weight(weight)
    }
}

// MARK: - Topic Accent Styles

extension TopicAccentColor {
    var background: Color {
        switch self {
        case .mint:
            return Color(red: 0.953, green: 0.922, blue: 0.969)
        case .peach:
            return Color(red: 0.965, green: 0.929, blue: 0.941)
        case .rose:
            return Color(red: 0.969, green: 0.918, blue: 0.949)
        case .sky:
            return Color(red: 0.925, green: 0.937, blue: 0.973)
        case .lavender:
            return Color(red: 0.929, green: 0.894, blue: 0.953)
        }
    }

    var foreground: Color {
        switch self {
        case .mint:
            return Color.brandDeepLavender
        case .peach:
            return Color(red: 0.72, green: 0.32, blue: 0.52)
        case .rose:
            return Color(red: 0.65, green: 0.28, blue: 0.55)
        case .sky:
            return Color(red: 0.38, green: 0.42, blue: 0.72)
        case .lavender:
            return Color.brandPlum
        }
    }
}

// MARK: - Reusable Topic Card Style Mapping

struct TopicCardStyle {
    let background: Color
    let iconBackground: Color
    let iconForeground: Color
    let titleColor: Color
    let subtitleColor: Color

    static func style(for topic: SpeakingTopic) -> TopicCardStyle {
        switch topic.title.lowercased() {
        case "education":
            return TopicCardStyle(
                background: Color(red: 0.953, green: 0.922, blue: 0.969), // Soft Lavender Mist
                iconBackground: Color.white.opacity(0.85),
                iconForeground: Color.brandPlum,
                titleColor: Color.brandPlum,
                subtitleColor: Color.brandDeepLavender
            )
        case "career":
            return TopicCardStyle(
                background: Color(red: 0.937, green: 0.902, blue: 0.957), // Muted Purple tint
                iconBackground: Color.white.opacity(0.85),
                iconForeground: Color.brandDeepLavender,
                titleColor: Color.brandPlum,
                subtitleColor: Color.brandDeepLavender
            )
        case "relationships":
            return TopicCardStyle(
                background: Color(red: 0.969, green: 0.918, blue: 0.949), // Orchid-Rose tint
                iconBackground: Color.white.opacity(0.85),
                iconForeground: Color(red: 0.65, green: 0.28, blue: 0.55),
                titleColor: Color.brandPlum,
                subtitleColor: Color.brandDeepLavender
            )
        case "travel":
            return TopicCardStyle(
                background: Color(red: 0.925, green: 0.937, blue: 0.973), // Periwinkle Lavender tint
                iconBackground: Color.white.opacity(0.85),
                iconForeground: Color(red: 0.38, green: 0.42, blue: 0.72),
                titleColor: Color.brandPlum,
                subtitleColor: Color.brandDeepLavender
            )
        case "hobbies":
            return TopicCardStyle(
                background: Color(red: 0.929, green: 0.894, blue: 0.953), // Deep Lavender tint
                iconBackground: Color.white.opacity(0.85),
                iconForeground: Color.brandPlum,
                titleColor: Color.brandPlum,
                subtitleColor: Color.brandDeepLavender
            )
        case "lifestyle":
            return TopicCardStyle(
                background: Color(red: 0.965, green: 0.929, blue: 0.941), // Blossom Lavender tint
                iconBackground: Color.white.opacity(0.85),
                iconForeground: Color(red: 0.68, green: 0.32, blue: 0.48),
                titleColor: Color.brandPlum,
                subtitleColor: Color.brandDeepLavender
            )
        case "technology":
            return TopicCardStyle(
                background: Color(red: 0.918, green: 0.910, blue: 0.961), // Slate Lavender tint
                iconBackground: Color.white.opacity(0.85),
                iconForeground: Color(red: 0.35, green: 0.32, blue: 0.62),
                titleColor: Color.brandPlum,
                subtitleColor: Color.brandDeepLavender
            )
        case "environment":
            return TopicCardStyle(
                background: Color(red: 0.922, green: 0.949, blue: 0.937), // Sage Lavender tint
                iconBackground: Color.white.opacity(0.85),
                iconForeground: Color(red: 0.25, green: 0.52, blue: 0.42),
                titleColor: Color.brandPlum,
                subtitleColor: Color.brandDeepLavender
            )
        default:
            return TopicCardStyle(
                background: Color.appSurfaceSecondary,
                iconBackground: Color.white.opacity(0.85),
                iconForeground: Color.brandPlum,
                titleColor: Color.brandPlum,
                subtitleColor: Color.brandDeepLavender
            )
        }
    }
}

// MARK: - Reusable View Modifiers & Styles

extension View {
    func appScreenBackground() -> some View {
        self.background(
            LinearGradient(
                colors: [Color.white, Color.appBackground, Color(red: 0.97, green: 0.95, blue: 0.98)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }

    @ViewBuilder
    func practiceGlassCard(cornerRadius: CGFloat = AppRadius.large) -> some View {
        if #available(iOS 26.0, *) {
            self
                .glassEffect(.regular, in: .rect(cornerRadius: cornerRadius))
        } else {
            self
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(Color.white.opacity(0.92))
                        .shadow(color: Color.brandPlum.opacity(0.06), radius: 16, y: 8)
                )
        }
    }

    @ViewBuilder
    func practiceInteractiveGlass(cornerRadius: CGFloat = AppRadius.large) -> some View {
        if #available(iOS 26.0, *) {
            self
                .glassEffect(.regular.interactive(), in: .rect(cornerRadius: cornerRadius))
        } else {
            self
                .background(Color.white.opacity(0.92))
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                .shadow(color: Color.brandPlum.opacity(0.06), radius: 14, y: 7)
        }
    }

    @ViewBuilder
    func practicePrimaryAction() -> some View {
        if #available(iOS 26.0, *) {
            self
                .buttonStyle(.glassProminent)
                .tint(.appPrimary)
        } else {
            self
                .background(Color.appPrimary)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.large, style: .continuous))
                .shadow(color: Color.appPrimary.opacity(0.24), radius: 12, y: 6)
        }
    }

    @ViewBuilder
    func practiceSecondaryAction() -> some View {
        if #available(iOS 26.0, *) {
            self
                .buttonStyle(.glass)
                .tint(.appSecondary)
        } else {
            self
                .background(Color.appSurfaceSecondary)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.large, style: .continuous))
                .shadow(color: Color.brandPlum.opacity(0.06), radius: 10, y: 5)
        }
    }
}
