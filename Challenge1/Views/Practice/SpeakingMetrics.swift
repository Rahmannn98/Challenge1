//
//  SpeakingMetrics.swift
//  Challenge1
//
//  Created by Saifulloh Rahman on 09/09/26.
//

import Foundation

struct SpeakingMetrics {

    var duration: TimeInterval = 0

    var transcript: String = ""

    var wordCount: Int = 0

    var wordsPerMinute: Double = 0

    var fillerWordCount: Int = 0

    var fillerWordRate: Double = 0

    var averageConfidence: Double = 0

    var pauseCount: Int = 0

    var prepCompleted: Int = 0

    var totalPrepStages: Int = 4

    var prepScore: Double {
        guard totalPrepStages > 0 else { return 0 }

        return Double(prepCompleted) / Double(totalPrepStages)
    }

    var speakingScore: Int {
        let speedScore = min(wordsPerMinute / 150.0, 1.0)
        let fillerScore = max(0, 1.0 - fillerWordRate)
        let confidenceScore = averageConfidence

        let score =
            (speedScore * 0.30) +
            (fillerScore * 0.25) +
            (confidenceScore * 0.25) +
            (prepScore * 0.20)

        return Int((score * 100).rounded())
    }
}
