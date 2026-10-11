import Foundation

struct PracticeEvaluationService {
    func evaluate(transcript: String, duration: TimeInterval) -> PracticeFeedback? {
        let words = transcript.lowercased().split { !$0.isLetter }.map(String.init)
        guard !words.isEmpty else { return nil }

        let containsPoint = containsAny(words, ["think", "believe", "opinion", "answer", "important"])
        let containsReason = containsAny(words, ["because", "since", "therefore", "reason"])
        let containsExample = containsAny(words, ["example", "instance", "such", "when"])
        let containsClosing = containsAny(words, ["overall", "finally", "conclude", "so"])
        let prepParts = [containsPoint, containsReason, containsExample, containsClosing].filter { $0 }.count
        let prepScore = Int((Double(prepParts) / 4 * 100).rounded())

        let sentenceCount = max(1, transcript.split(whereSeparator: { ".!?".contains($0) }).count)
        let averageWords = Double(words.count) / Double(sentenceCount)
        let clarityScore = min(100, max(25, Int((55 + min(averageWords, 18) * 2.5).rounded())))

        let wpm = duration > 0 ? Double(words.count) / duration * 60 : 0
        let fluencyScore: Int? = duration > 0 ? min(100, max(0, Int((100 - abs(wpm - 130) * 0.75).rounded()))) : nil

        let missing = [
            containsPoint ? nil : "a clear point",
            containsReason ? nil : "a reason",
            containsExample ? nil : "an example",
            containsClosing ? nil : "a closing point"
        ].compactMap { $0 }
        let summary = missing.isEmpty ? "Your transcript includes all four PREP signals." : "Try adding \(missing.joined(separator: ", "))."
        return PracticeFeedback(
            prepScore: prepScore, clarityScore: clarityScore, fluencyScore: fluencyScore,
            summary: summary,
            limitations: "This is a local transcript-based estimate. Fluency is based only on speaking rate; it does not assess pronunciation, accent, or pauses."
        )
    }

    private func containsAny(_ words: [String], _ candidates: Set<String>) -> Bool {
        !Set(words).isDisjoint(with: candidates)
    }
}
