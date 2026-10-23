
import SwiftUI

struct ContentView: View {
    @State private var viewModel = HomeViewModel()
    @State private var navigationPath = NavigationPath()
    @State private var showsProfile = false
    @State private var carouselIndex: Int?

    @Environment(PracticeSessionStore.self) private var store

    private let cardSpacing: CGFloat = 14
    private let carouselHeight: CGFloat = 350

    private var topicCount: Int {
        viewModel.topics.count
    }

    private var loopedTopics: [SpeakingTopic] {
        guard topicCount > 1 else {
            return viewModel.topics
        }

        return viewModel.topics + viewModel.topics + viewModel.topics
    }

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 22) {
                    topBar
                    heroSection
                    topicHeader
                    topicCarousel
                }
                .padding(.horizontal, AppSpacing.screen)
                .padding(.top, 14)
                .padding(.bottom, AppSpacing.large)
            }
            .appScreenBackground()
            .navigationDestination(for: HomeDestination.self) { destination in
                switch destination {
                case .history:
                    RecordingHistoryView()

                case .practiceSetup(let topicID):
                    if let topic = viewModel.topics.first(
                        where: { $0.id == topicID }
                    ) {
                        PracticeSetupView(topic: topic)
                    } else {
                        ContentUnavailableView(
                            "Topic unavailable",
                            systemImage: "bubble.left.and.exclamationmark"
                        )
                    }
                }
            }
        }
        .font(.jakarta(15, relativeTo: .body))
        .task {
            for await _ in NotificationCenter.default.notifications(
                named: .returnToHome
            ) {
                navigationPath = NavigationPath()
            }
        }
        .sheet(isPresented: $showsProfile) {
            ProfileView()
        }
        .onAppear {
            positionCarouselAtSelectedTopic()
        }
        .onChange(of: viewModel.topics.count) { _, _ in
            positionCarouselAtSelectedTopic()
        }
    }

    private var topBar: some View {
        HStack(spacing: 12) {
            Button {
                showsProfile = true
            } label: {
                Text(store.profile.initials)
                    .font(
                        .jakarta(
                            17,
                            relativeTo: .headline,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(
                        LinearGradient(
                            colors: [
                                Color.brandDeepLavender,
                                Color.brandPlum
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Edit profile")

            VStack(alignment: .leading, spacing: 2) {
                Text("Good morning,")
                    .font(
                        .jakarta(
                            12,
                            relativeTo: .caption,
                            weight: .medium
                        )
                    )
                    .foregroundStyle(Color.appTextSecondary)

                Text("\(store.profile.displayName)!")
                    .font(
                        .jakarta(
                            17,
                            relativeTo: .headline,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(Color.appTextPrimary)
            }

            Spacer()

            NavigationLink(value: HomeDestination.history) {
                Image(systemName: "clock.arrow.circlepath")
                    .font(.system(size: 23, weight: .medium))
                    .foregroundStyle(Color.appPrimary)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Practice history")
        }
    }

    private var heroSection: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(
                cornerRadius: AppRadius.extraLarge,
                style: .continuous
            )
            .fill(
                LinearGradient(
                    colors: [
                        Color.brandLavender.opacity(0.35),
                        Color.brandMutedPurple.opacity(0.22)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )

            Image("Monyet4")
                .resizable()
                .scaledToFit()
                .frame(width: 165)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 4)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 12) {
                Text("Speak\nConfidently,\nAnywhere")
                    .font(
                        .jakarta(
                            26,
                            relativeTo: .title2,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(Color.appTextPrimary)
                    .lineSpacing(-1)

                Text("Practice real conversations\nwith the PREP method.")
                    .font(
                        .jakarta(
                            13,
                            relativeTo: .footnote,
                            weight: .medium
                        )
                    )
                    .foregroundStyle(Color.appTextSecondary)

                if let topic = viewModel.selectedTopic {
                    NavigationLink(
                        value: HomeDestination.practiceSetup(
                            topicID: topic.id
                        )
                    ) {
                        Label(
                            "Start Practicing",
                            systemImage: "arrow.right"
                        )
                        .font(
                            .jakarta(
                                14,
                                relativeTo: .subheadline,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(.white)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 12)
                    }
                    .practicePrimaryAction()
                }
            }
            .padding(18)
            .frame(maxWidth: 210, alignment: .leading)
        }
        .frame(height: 210)
        .clipShape(
            RoundedRectangle(
                cornerRadius: AppRadius.extraLarge,
                style: .continuous
            )
        )
    }

    private var topicHeader: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Find Your Next Conversation")
                .font(
                    .jakarta(
                        26,
                        relativeTo: .title2,
                        weight: .bold
                    )
                )
                .foregroundStyle(Color.appTextPrimary)
                .accessibilityAddTraits(.isHeader)

            Text(
                "Choose a topic and start practicing. Real topics, real confidence."
            )
            .font(
                .jakarta(
                    14,
                    relativeTo: .subheadline,
                    weight: .medium
                )
            )
            .foregroundStyle(Color.appTextSecondary)
            .lineSpacing(2)
        }
        .padding(.top, 4)
    }

    private var topicCarousel: some View {
        GeometryReader { geometry in
            let cardWidth = geometry.size.width * 0.80
            let sideInset = max(
                0,
                (geometry.size.width - cardWidth) / 2
            )

            if viewModel.topics.isEmpty {
                ContentUnavailableView(
                    "No topics available",
                    systemImage: "text.bubble",
                    description: Text(
                        "Add a topic to start practicing."
                    )
                )
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity
                )
            } else {
                ScrollView(.horizontal) {
                    LazyHStack(spacing: cardSpacing) {
                        ForEach(
                            Array(loopedTopics.enumerated()),
                            id: \.offset
                        ) { index, topic in
                            NavigationLink(
                                value: HomeDestination.practiceSetup(
                                    topicID: topic.id
                                )
                            ) {
                                TopicCard(topic: topic)
                                    .frame(
                                        width: cardWidth,
                                        height: carouselHeight - 20
                                    )
                                    .scaleEffect(
                                        scale(for: index)
                                    )
                                    .opacity(
                                        opacity(for: index)
                                    )
                            }
                            .buttonStyle(.plain)
                            .id(index)
                            .contextMenu {
                                Button(role: .destructive) {
                                    deleteTopic(topic)
                                } label: {
                                    Label(
                                        "Delete",
                                        systemImage: "trash"
                                    )
                                }
                            }
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.viewAligned)
                .scrollPosition(id: $carouselIndex)
                .scrollClipDisabled()
                .contentMargins(
                    .horizontal,
                    sideInset,
                    for: .scrollContent
                )
                .onChange(of: carouselIndex) { _, newIndex in
                    handleCarouselChange(newIndex)
                }
            }
        }
        .frame(height: carouselHeight)
    }

    private func scale(for index: Int) -> CGFloat {
        guard let currentIndex = carouselIndex else {
            return 0.88
        }

        let distance = abs(index - currentIndex)

        switch distance {
        case 0:
            return 1.0
        case 1:
            return 0.86
        default:
            return 0.78
        }
    }

    private func opacity(for index: Int) -> Double {
        guard let currentIndex = carouselIndex else {
            return 0.75
        }

        let distance = abs(index - currentIndex)

        switch distance {
        case 0:
            return 1.0
        case 1:
            return 0.85
        default:
            return 0.68
        }
    }

    private func positionCarouselAtSelectedTopic() {
        guard topicCount > 0 else {
            carouselIndex = nil
            viewModel.selectedIndex = 0
            return
        }

        viewModel.selectedIndex = min(
            max(viewModel.selectedIndex, 0),
            topicCount - 1
        )

        let targetIndex = topicCount > 1
            ? topicCount + viewModel.selectedIndex
            : viewModel.selectedIndex

        var transaction = Transaction()
        transaction.disablesAnimations = true

        withTransaction(transaction) {
            carouselIndex = targetIndex
        }
    }

    private func handleCarouselChange(_ newIndex: Int?) {
        guard let newIndex, topicCount > 1 else {
            if topicCount == 1 {
                viewModel.selectedIndex = 0
            }
            return
        }

        let actualIndex = newIndex % topicCount

        if viewModel.selectedIndex != actualIndex {
            viewModel.selectedIndex = actualIndex
        }

        if newIndex < topicCount {
            recenterCarousel(to: newIndex + topicCount)
        } else if newIndex >= topicCount * 2 {
            recenterCarousel(to: newIndex - topicCount)
        }
    }

    private func recenterCarousel(to index: Int) {
        DispatchQueue.main.async {
            var transaction = Transaction()
            transaction.disablesAnimations = true

            withTransaction(transaction) {
                carouselIndex = index
            }
        }
    }

    private func deleteTopic(_ topic: SpeakingTopic) {
        viewModel.deleteTopic(topic)
        positionCarouselAtSelectedTopic()
    }
}

private enum HomeDestination: Hashable {
    case history
    case practiceSetup(topicID: UUID)
}

#Preview {
    ContentView()
        .environment(PracticeSessionStore())
}
