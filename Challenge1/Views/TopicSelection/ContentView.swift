import SwiftUI

struct ContentView: View {
    @State private var viewModel = HomeViewModel()
    @State private var navigationPath = NavigationPath()
    @State private var showsProfile = false
    @Environment(PracticeSessionStore.self) private var store

    private let columns = [
        GridItem(.flexible(), spacing: AppSpacing.medium),
        GridItem(.flexible(), spacing: AppSpacing.medium)
    ]

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 22) {
                    topBar
                    heroSection
                    topicHeader
                    topicGrid
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
                    if let topic = viewModel.topics.first(where: { $0.id == topicID }) {
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
            for await _ in NotificationCenter.default.notifications(named: .returnToHome) {
                navigationPath = NavigationPath()
            }
        }
        .sheet(isPresented: $showsProfile) {
            ProfileView()
        }
    }

    private var topBar: some View {
        HStack(spacing: 12) {
            Button {
                showsProfile = true
            } label: {
                Text(store.profile.initials)
                    .font(.jakarta(17, relativeTo: .headline, weight: .bold))
                    .foregroundStyle(Color.white)
                    .frame(width: 44, height: 44)
                    .background(
                        LinearGradient(
                            colors: [Color.brandDeepLavender, Color.brandPlum],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(Circle())
                    .shadow(color: Color.brandPlum.opacity(0.18), radius: 8, y: 4)
            }
            .accessibilityLabel("Edit profile")

            VStack(alignment: .leading, spacing: 2) {
                Text("Good morning,")
                    .font(.jakarta(12, relativeTo: .caption, weight: .medium))
                    .foregroundStyle(Color.appTextSecondary)

                Text("\(store.profile.displayName)!")
                    .font(.jakarta(17, relativeTo: .headline, weight: .bold))
                    .foregroundStyle(Color.appTextPrimary)
            }

            Spacer()

            NavigationLink(value: HomeDestination.history) {
                Image(systemName: "clock.arrow.circlepath")
                    .font(.jakarta(16, relativeTo: .subheadline, weight: .bold))
                    .foregroundStyle(Color.appPrimary)
                    .frame(width: 42, height: 42)
                    .background(Color.white.opacity(0.92))
                    .clipShape(Circle())
                    .shadow(color: Color.brandPlum.opacity(0.06), radius: 8, y: 4)
            }
            .accessibilityLabel("Practice history")
        }
    }

    private var heroSection: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: AppRadius.extraLarge, style: .continuous)
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
                    .font(.jakarta(26, relativeTo: .title2, weight: .bold))
                    .foregroundStyle(Color.appTextPrimary)
                    .lineSpacing(-1)

                Text("Practice real conversations\nwith the PREP method.")
                    .font(.jakarta(13, relativeTo: .footnote, weight: .medium))
                    .foregroundStyle(Color.appTextSecondary)

                if let topic = viewModel.topics.first {
                    NavigationLink(value: HomeDestination.practiceSetup(topicID: topic.id)) {
                        Label("Start Practicing", systemImage: "arrow.right")
                            .font(.jakarta(14, relativeTo: .subheadline, weight: .bold))
                            .foregroundStyle(Color.white)
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
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.extraLarge, style: .continuous))
    }

    private var topicHeader: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Find Your Next Conversation")
                .font(.jakarta(26, relativeTo: .title2, weight: .bold))
                .foregroundStyle(Color.appTextPrimary)
                .accessibilityAddTraits(.isHeader)

            Text("Choose a topic and start practicing. Real topics, real confidence.")
                .font(.jakarta(14, relativeTo: .subheadline, weight: .medium))
                .foregroundStyle(Color.appTextSecondary)
                .lineSpacing(2)
        }
        .padding(.top, 4)
    }

    private var topicGrid: some View {
        LazyVGrid(columns: columns, spacing: AppSpacing.medium) {
            ForEach(viewModel.topics) { topic in
                NavigationLink(value: HomeDestination.practiceSetup(topicID: topic.id)) {
                    TopicCard(topic: topic)
                }
                .buttonStyle(.plain)
                .contextMenu {
                    Button(role: .destructive) {
                        viewModel.deleteTopic(topic)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
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
