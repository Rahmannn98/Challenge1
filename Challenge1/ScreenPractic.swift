//
//  Screen.swift
//  Challenge1
//
//  Created by Saifulloh Rahman on 22/04/26.
//
import SwiftUI

struct ScreenPractic: View {
    let topic: Topic

    @State private var selectedMinutes = 1
    @State private var selectedSeconds = 0
    @State private var totalDuration = 60
    @State private var currentQuestion: String

    init(topic: Topic) {
        self.topic = topic
        _currentQuestion = State(initialValue: topic.starterQuestion)
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 28) {
                VStack(spacing: 12) {
                    Text(topic.title)
                        .font(.largeTitle.bold())
                        .foregroundStyle(Color.themePrimary)
                    Text("Prepare your practice")
                        .font(.headline)
                        .foregroundStyle(Color.themeSecondary)
                }
                .padding(.top, 20)

                VStack(spacing: 18) {
                    Text("Selected Question")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(Color.themeSecondary)

                    Text(currentQuestion)
                        .font(.system(size: 31, weight: .black, design: .rounded))
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)
                        .foregroundStyle(Color.themePrimary)
                        .frame(maxWidth: .infinity)
                }

                actionButton(title: "Generate Question", systemImage: "arrow.triangle.2.circlepath") {
                    generateQuestion()
                }

                VStack(spacing: 14) {
                    Text("Set Duration")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(Color.themePrimary)

                    HStack(spacing: 12) {
                        durationPicker(title: "Min", selection: $selectedMinutes, range: 0...59)
                        durationPicker(title: "Sec", selection: $selectedSeconds, range: 0...59)
                    }

                    Text("Practice time: \(timeString(from: totalDuration))")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(Color.themePrimary)
                }

                NavigationLink {
                    PracticeSessionView(
                        topicTitle: topic.title,
                        question: currentQuestion,
                        totalDuration: totalDuration
                    )
                } label: {
                    Label("Start Practice", systemImage: "play.fill")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.themePrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 22))
                }

                Image(topic.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .frame(height: 250)
                    .cornerRadius(16)
                    .padding(.top, 6)
            }
            .padding(.horizontal, 24)
            .padding(.top, 12)
            .padding(.bottom, 28)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.themeTertiary)
        .ignoresSafeArea()
        .onAppear {
            syncDuration()
        }
        .onChange(of: selectedMinutes) { _, _ in
            syncDuration()
        }
        .onChange(of: selectedSeconds) { _, _ in
            syncDuration()
        }
    }

    @ViewBuilder
    private func actionButton(title: String, systemImage: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .font(.headline.weight(.semibold))
                .foregroundStyle(Color.themePrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.themeQuaternary)
                .clipShape(RoundedRectangle(cornerRadius: 18))
        }
    }

    @ViewBuilder
    private func durationPicker(title: String, selection: Binding<Int>, range: ClosedRange<Int>) -> some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(Color.themePrimary)

            Picker(title, selection: selection) {
                ForEach(Array(range), id: \.self) { value in
                    Text(String(format: "%02d", value))
                        .tag(value)
                }
            }
            .pickerStyle(.wheel)
            .frame(maxWidth: .infinity)
            .frame(height: 110)
            .background(Color.white.opacity(0.55))
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
    }

    private func generateQuestion() {
        let availableQuestions = topic.questions.filter { $0 != currentQuestion }
        currentQuestion = availableQuestions.randomElement() ?? topic.starterQuestion
    }

    private func syncDuration() {
        totalDuration = max(1, (selectedMinutes * 60) + selectedSeconds)
    }

    private func timeString(from duration: Int) -> String {
        let minutes = duration / 60
        let seconds = duration % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

private struct PracticeSessionView: View {
    let topicTitle: String
    let question: String
    let totalDuration: Int

    @State private var remainingSeconds: Int
    @State private var timerSessionID = UUID()

    init(topicTitle: String, question: String, totalDuration: Int) {
        self.topicTitle = topicTitle
        self.question = question
        self.totalDuration = totalDuration
        _remainingSeconds = State(initialValue: totalDuration)
    }

    var body: some View {
        VStack(spacing: 32) {
            VStack(spacing: 10) {
                Text(topicTitle)
                    .font(.largeTitle.bold())
                    .foregroundStyle(Color.themePrimary)
                Text("Practice Session")
                    .font(.headline)
                    .foregroundStyle(Color.themeSecondary)
            }
            .padding(.top, 40)

            Text(question)
                .font(.system(size: 32, weight: .black, design: .rounded))
                .multilineTextAlignment(.center)
                .lineSpacing(6)
                .foregroundStyle(Color.themePrimary)
                .frame(maxWidth: .infinity)

            Spacer()

            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.45), lineWidth: 16)

                Circle()
                    .trim(from: 0, to: progressValue)
                    .stroke(
                        Color.themePrimary,
                        style: StrokeStyle(lineWidth: 16, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.4), value: remainingSeconds)

                VStack(spacing: 8) {
                    Image(systemName: "clock.badge")
                        .font(.system(size: 26, weight: .semibold))
                    Text(timeString)
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                    Text(remainingSeconds == 0 ? "Time is up" : "Stay focused")
                        .font(.subheadline.weight(.medium))
                }
            }
            .frame(width: 230, height: 230)
            .foregroundColor(Color.themePrimary)

            Spacer()

            Button {
                restartSession()
            } label: {
                Label("Restart Timer", systemImage: "gobackward")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(Color.themePrimary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.themeQuaternary)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
            }
            .padding(.bottom, 32)
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.themeTertiary)
        .ignoresSafeArea()
        .task(id: timerSessionID) {
            await runCountdown()
        }
    }

    private var progressValue: CGFloat {
        guard totalDuration > 0 else { return 0 }
        return CGFloat(remainingSeconds) / CGFloat(totalDuration)
    }

    private var timeString: String {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func restartSession() {
        remainingSeconds = totalDuration
        timerSessionID = UUID()
    }

    private func runCountdown() async {
        while !Task.isCancelled {
            guard remainingSeconds > 0 else { return }

            try? await Task.sleep(for: .seconds(1))

            guard !Task.isCancelled else { return }
            remainingSeconds -= 1
        }
    }
}
