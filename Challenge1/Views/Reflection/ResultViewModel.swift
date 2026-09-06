import Foundation

struct ResultViewModel {
    let topicTitle: String
    let branch: PracticeBranch
    let question: String
    let totalDuration: Int

    var branchTitle: String {
        branch.title
    }

    var earnedXP: Int {
        40 + (totalDuration / 6)
    }

    var formattedDuration: String {
        TimeFormatter.practiceTime(totalDuration)
    }
}
