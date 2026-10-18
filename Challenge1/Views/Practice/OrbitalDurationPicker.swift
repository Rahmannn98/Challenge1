import SwiftUI

enum DurationMode: String, CaseIterable, Identifiable {
    case minutes
    case seconds

    var id: String { rawValue }

    var title: String {
        switch self {
        case .minutes: return "Minutes"
        case .seconds: return "Seconds"
        }
    }

    var subtitle: String {
        switch self {
        case .minutes: return "Target speech time"
        case .seconds: return "Fine-tune seconds"
        }
    }
}

struct OrbitalDurationPicker: View {
    @Binding var selectedMinutes: Int
    @Binding var selectedSeconds: Int
    let formattedDuration: String
    let onReset: () -> Void

    @State private var mode: DurationMode = .minutes
    @State private var dragAccumulator: CGFloat = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let range = 0...59
    private let radius: CGFloat = 190
    private let apexX: CGFloat = 92
    private let containerHeight: CGFloat = 186
    private let stepAngleDegrees: Double = 13.5
    private let feedbackGenerator = UISelectionFeedbackGenerator()

    private var currentValue: Int {
        get { mode == .minutes ? selectedMinutes : selectedSeconds }
        nonmutating set {
            let clamped = min(max(newValue, range.lowerBound), range.upperBound)
            if mode == .minutes {
                selectedMinutes = clamped
            } else {
                selectedSeconds = clamped
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            headerRow
            modeSelector
            orbitalCanvas
            summaryRow
        }
        .padding(18)
        .background(Color.white.opacity(0.95), in: .rect(cornerRadius: AppRadius.large))
        .overlay(
            RoundedRectangle(cornerRadius: AppRadius.large, style: .continuous)
                .strokeBorder(Color.brandLavender.opacity(0.25), lineWidth: 1)
        )
        .shadow(color: Color.brandPlum.opacity(0.05), radius: 14, y: 7)
    }

    private var headerRow: some View {
        HStack(alignment: .firstTextBaseline) {
            Text("Practice Duration")
                .font(.jakarta(17, relativeTo: .headline, weight: .bold))
                .foregroundStyle(Color.appTextPrimary)
                .accessibilityAddTraits(.isHeader)

            Spacer()

            Button("Choose another question", systemImage: "arrow.triangle.2.circlepath") {
                onReset()
            }
            .labelStyle(.iconOnly)
            .font(.headline)
            .foregroundStyle(Color.appPrimary)
            .frame(width: 40, height: 40)
            .background(Color.appSurfaceSecondary, in: Circle())
            .accessibilityLabel("Choose another question")
            .accessibilityHint("Selects another sample question.")
        }
    }

    private var modeSelector: some View {
        HStack(spacing: 4) {
            ForEach(DurationMode.allCases) { item in
                Button {
                    if reduceMotion {
                        mode = item
                    } else {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            mode = item
                        }
                    }
                    feedbackGenerator.selectionChanged()
                } label: {
                    Text(item.title)
                        .font(.jakarta(12, relativeTo: .caption, weight: .bold))
                        .foregroundStyle(mode == item ? Color.appTextPrimary : Color.appTextSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 7)
                        .background(
                            mode == item ? Color.white : Color.clear,
                            in: Capsule()
                        )
                        .shadow(
                            color: mode == item ? Color.brandPlum.opacity(0.08) : Color.clear,
                            radius: 3,
                            y: 1
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(3)
        .background(Color.appSurfaceTertiary, in: Capsule())
    }

    private var orbitalCanvas: some View {
        GeometryReader { geometry in
            let height = geometry.size.height
            let centerY = height / 2
            let centerX = apexX - radius

            ZStack {
                // Background card container
                RoundedRectangle(cornerRadius: AppRadius.medium, style: .continuous)
                    .fill(Color.appSurfaceSecondary.opacity(0.65))

                // Subtle circular arc path
                Path { path in
                    path.addArc(
                        center: CGPoint(x: centerX, y: centerY),
                        radius: radius,
                        startAngle: .degrees(-48),
                        endAngle: .degrees(48),
                        clockwise: false
                    )
                }
                .stroke(
                    Color.brandPlum.opacity(0.12),
                    style: StrokeStyle(lineWidth: 1.5, lineCap: .round)
                )

                // Markers and neighboring values along the orbital arc
                ForEach(-3...3, id: \.self) { offset in
                    let val = currentValue + offset
                    if range.contains(val) {
                        let angleDegrees = Double(offset) * stepAngleDegrees
                        let angleRad = angleDegrees * .pi / 180
                        let markerX = centerX + radius * cos(angleRad)
                        let markerY = centerY + radius * sin(angleRad)

                        // Orbit dot marker
                        if offset == 0 {
                            // Active selected marker
                            Circle()
                                .fill(Color.brandLavender.opacity(0.4))
                                .frame(width: 18, height: 18)
                                .position(x: markerX, y: markerY)

                            Circle()
                                .fill(Color.brandDeepLavender)
                                .frame(width: 8, height: 8)
                                .position(x: markerX, y: markerY)
                        } else {
                            // Neighboring marker
                            Circle()
                                .fill(Color.brandDeepLavender.opacity(0.35))
                                .frame(width: 4, height: 4)
                                .position(x: markerX, y: markerY)
                        }

                        // Neighboring duration numbers
                        if offset != 0 {
                            let textRadius = radius - 24
                            let textX = centerX + textRadius * cos(angleRad)
                            let textY = centerY + textRadius * sin(angleRad)
                            let opacity = max(0.22, 0.55 - Double(abs(offset)) * 0.12)

                            Button {
                                selectValue(val)
                            } label: {
                                Text(val, format: .number.precision(.integerLength(2)))
                                    .font(.jakarta(12, relativeTo: .caption2, weight: .bold))
                                    .foregroundStyle(Color.appTextSecondary.opacity(opacity))
                                    .rotationEffect(.degrees(angleDegrees))
                            }
                            .buttonStyle(.plain)
                            .position(x: textX, y: textY)
                        }
                    }
                }

                // Selected prominent readout near the center-right
                HStack(alignment: .lastTextBaseline, spacing: 8) {
                    Text(currentValue, format: .number.precision(.integerLength(2)))
                        .font(.jakarta(48, relativeTo: .largeTitle, weight: .bold))
                        .foregroundStyle(Color.appTextPrimary)
                        .contentTransition(.numericText())

                    VStack(alignment: .leading, spacing: 2) {
                        Text(mode.title)
                            .font(.jakarta(15, relativeTo: .subheadline, weight: .bold))
                            .foregroundStyle(Color.appTextPrimary)

                        Text(mode.subtitle)
                            .font(.jakarta(11, relativeTo: .caption2, weight: .medium))
                            .foregroundStyle(Color.appTextSecondary)
                            .lineLimit(1)
                    }

                    Spacer(minLength: 0)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, apexX + 22)
                .padding(.trailing, 12)
            }
            .clipShape(.rect(cornerRadius: AppRadius.medium))
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 4)
                    .onChanged { value in
                        handleDragChanged(translation: value.translation.height)
                    }
                    .onEnded { _ in
                        dragAccumulator = 0
                    }
            )
        }
        .frame(height: containerHeight)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(mode.title) orbital selector")
        .accessibilityValue("\(currentValue) \(mode.title.lowercased())")
        .accessibilityHint("Swipe up or down with one finger to adjust value.")
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment:
                selectValue(min(range.upperBound, currentValue + 1))
            case .decrement:
                selectValue(max(range.lowerBound, currentValue - 1))
            @unknown default:
                break
            }
        }
    }

    private var summaryRow: some View {
        HStack {
            Text("Practice time: \(formattedDuration)")
                .font(.jakarta(13, relativeTo: .footnote, weight: .bold))
                .foregroundStyle(Color.appTextPrimary)

            Spacer()
        }
    }

    private func selectValue(_ newValue: Int) {
        let clamped = min(max(newValue, range.lowerBound), range.upperBound)
        guard clamped != currentValue else { return }

        if reduceMotion {
            currentValue = clamped
        } else {
            withAnimation(.spring(response: 0.28, dampingFraction: 0.78)) {
                currentValue = clamped
            }
        }
        feedbackGenerator.selectionChanged()
    }

    private func handleDragChanged(translation: CGFloat) {
        let threshold: CGFloat = 16
        let delta = translation - dragAccumulator

        if abs(delta) >= threshold {
            let step = delta < 0 ? 1 : -1
            selectValue(currentValue + step)
            dragAccumulator = translation
        }
    }
}
