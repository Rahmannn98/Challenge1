import Foundation

enum TimeFormatter {
    static func practiceTime(_ duration: Int) -> String {
        let minutes = duration / 60
        let seconds = duration % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

func formatTime(totalDuration: Int) -> String {
    TimeFormatter.practiceTime(totalDuration)
}
