import SwiftUI

struct PracticeActionButton: View {
    enum Style {
        case primary
        case secondary
    }

    let title: String
    let systemImage: String
    let style: Style
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .font(.headline.weight(.semibold))
                .foregroundStyle(foregroundColor)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
        }
        .modifier(ActionButtonModifier(style: style))
    }

    private var foregroundColor: Color {
        switch style {
        case .primary:
            return .white
        case .secondary:
            return .themePrimary
        }
    }
}

private struct ActionButtonModifier: ViewModifier {
    let style: PracticeActionButton.Style

    @ViewBuilder
    func body(content: Content) -> some View {
        switch style {
        case .primary:
            content.practicePrimaryAction()
        case .secondary:
            content.practiceSecondaryAction()
        }
    }
}
