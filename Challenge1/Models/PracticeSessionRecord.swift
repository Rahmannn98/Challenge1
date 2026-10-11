import Foundation

struct PracticeSessionRecord: Identifiable, Codable, Equatable {
    let id: UUID
    var topicTitle: String
    var question: String
    var startedAt: Date
    var duration: TimeInterval
    var transcript: String
    var audioFileName: String?
    var feedback: PracticeFeedback?

    init(
        id: UUID = UUID(), topicTitle: String, question: String, startedAt: Date = .now,
        duration: TimeInterval, transcript: String, audioFileName: String?, feedback: PracticeFeedback? = nil
    ) {
        self.id = id
        self.topicTitle = topicTitle
        self.question = question
        self.startedAt = startedAt
        self.duration = duration
        self.transcript = transcript
        self.audioFileName = audioFileName
        self.feedback = feedback
    }
}

struct PracticeFeedback: Codable, Equatable {
    var prepScore: Int?
    var clarityScore: Int?
    var fluencyScore: Int?
    var summary: String
    var limitations: String
}
