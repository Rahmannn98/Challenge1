import Foundation

enum TopicPreset: String, CaseIterable, Identifiable {
    case education
    case career
    case relationships
    case travel
    case hobbies
    case lifestyle
    case technology
    case environment

    var id: Self { self }

    var topic: SpeakingTopic {
        switch self {
        case .education:
            return SpeakingTopic(
                title: "Education",
                subtitle: "Talk about learning, school, and knowledge",
                symbolName: "graduationcap.fill",
                imageName: "Monyet2",
                accentColorName: "mint",
                questions: [
                    "How has your education shaped who you are today?",
                    "Do you prefer online or offline learning? Why?",
                    "What is the most valuable lesson you have learned?",
                    "How do you stay motivated when studying?"
                ]
            )
        case .career:
            return SpeakingTopic(
                title: "Career",
                subtitle: "Discuss work, goals, and professional life",
                symbolName: "briefcase.fill",
                imageName: "Monyet3",
                accentColorName: "peach",
                questions: [
                    "What career are you interested in?",
                    "What skills are important for your dream job?",
                    "Describe a person whose career inspires you.",
                    "How do you prepare for your future career?"
                ]
            )
        case .relationships:
            return SpeakingTopic(
                title: "Relationships",
                subtitle: "Talk about love, friendships, and family",
                symbolName: "heart.fill",
                imageName: "Monyet4",
                accentColorName: "rose",
                questions: [
                    "What makes a friendship meaningful?",
                    "How do you keep a relationship healthy?",
                    "Describe someone who supports you.",
                    "Why is trust important in relationships?"
                ]
            )
        case .travel:
            return SpeakingTopic(
                title: "Travel",
                subtitle: "Share about places, trips, and cultures",
                symbolName: "airplane",
                imageName: "Monyet5",
                accentColorName: "sky",
                questions: [
                    "What place would you like to visit?",
                    "How does travel change your perspective?",
                    "Describe your most memorable trip.",
                    "Why should people learn about other cultures?"
                ]
            )
        case .hobbies:
            return SpeakingTopic(
                title: "Hobbies",
                subtitle: "Talk about what you enjoy doing",
                symbolName: "gamecontroller.fill",
                imageName: "Monyet6",
                accentColorName: "lavender",
                questions: [
                    "What hobby helps you relax?",
                    "How did you start your favorite hobby?",
                    "Should everyone have a hobby? Why?",
                    "What hobby would you like to try next?"
                ]
            )
        case .lifestyle:
            return SpeakingTopic(
                title: "Lifestyle",
                subtitle: "Discuss daily life, habits, and balance",
                symbolName: "leaf.fill",
                imageName: "Monyet7",
                accentColorName: "peach",
                questions: [
                    "What habit improves your day?",
                    "How do you keep a balanced lifestyle?",
                    "Describe your ideal weekend.",
                    "Why is rest important?"
                ]
            )
        case .technology:
            return SpeakingTopic(
                title: "Technology",
                subtitle: "Share opinions about tech and innovation",
                symbolName: "laptopcomputer",
                imageName: "MonyetBaik",
                accentColorName: "rose",
                questions: [
                    "How does technology help your daily life?",
                    "What technology do you use the most?",
                    "Should students use AI for learning? Why?",
                    "What future technology excites you?"
                ]
            )
        case .environment:
            return SpeakingTopic(
                title: "Environment",
                subtitle: "Talk about nature and sustainability",
                symbolName: "globe.asia.australia.fill",
                imageName: "Monyet2",
                accentColorName: "mint",
                questions: [
                    "How can people protect the environment?",
                    "Why is recycling important?",
                    "Describe a clean and healthy city.",
                    "What small action can reduce waste?"
                ]
            )
        }
    }
}

enum PracticeBranch: String, CaseIterable, Identifiable {
    case generalPractice

    var id: Self { self }

    var title: String {
        switch self {
        case .generalPractice:
            return "General Practice"
        }
    }
}

struct SpeakingTopic: Identifiable, Equatable {
    let id: UUID
    var title: String
    var subtitle: String
    var symbolName: String
    var imageName: String
    var accentColorName: String
    var questions: [String]

    init(
        id: UUID = UUID(),
        title: String,
        subtitle: String,
        symbolName: String,
        imageName: String,
        accentColorName: String,
        questions: [String]
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.symbolName = symbolName
        self.imageName = imageName
        self.accentColorName = accentColorName
        self.questions = questions
    }

    var starterQuestion: String {
        questions.first ?? "Tell me more about \(title)."
    }

    var accentColor: TopicAccentColor {
        TopicAccentColor(rawValue: accentColorName) ?? .mint
    }
}

enum TopicAccentColor: String {
    case mint
    case peach
    case rose
    case sky
    case lavender
}
