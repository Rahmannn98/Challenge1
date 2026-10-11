import SwiftUI

struct ContentView: View {
    @State private var viewModel = HomeViewModel()
    @State private var navigationID = UUID()
    @State private var showsProfile = false
    @Environment(PracticeSessionStore.self) private var store

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 22) {
                    topBar
                    heroSection
                    topicHeader
                    topicGrid
                }
                .padding(.horizontal, AppSpacing.screen)
                .padding(.top, 18)
                .padding(.bottom, 24)
            }
            .appScreenBackground()
        }
        .id(navigationID)
        .font(.jakarta(15))
        .task {
            for await _ in NotificationCenter.default.notifications(named: .returnToHome) {
                navigationID = UUID()
            }
        }
        .sheet(isPresented: $showsProfile) { ProfileView() }
    }

    private var topBar: some View {
        HStack(spacing: 12) {
            Button { showsProfile = true } label: {
            Text(store.profile.initials)
                .font(.jakarta(18, weight: .bold))
                .foregroundStyle(Color.white)
                .frame(width: 46, height: 46)
                .background(
                    LinearGradient(
                        colors: [Color.themeMint, Color.themeSecondary],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(Circle())
                .shadow(color: Color.themeMint.opacity(0.28), radius: 12, y: 6)
            }
            .accessibilityLabel("Edit profile")

            VStack(alignment: .leading, spacing: 3) {
                Text("Good morning,")
                    .font(.jakarta(12, weight: .medium))
                    .foregroundStyle(Color.themeSecondary)

                Text("\(store.profile.displayName)!")
                    .font(.jakarta(17, weight: .bold))
                    .foregroundStyle(Color.themePrimary)
            }

            Spacer()

            NavigationLink { RecordingHistoryView() } label: {
            Image(systemName: "clock.arrow.circlepath")
                .font(.jakarta(16, weight: .bold))
                .foregroundStyle(Color.themePrimary)
                .frame(width: 42, height: 42)
                .background(Color.white.opacity(0.92))
                .clipShape(Circle())
                .shadow(color: Color.themePrimary.opacity(0.08), radius: 12, y: 6)
            }
            .accessibilityLabel("Practice history")
        }
    }

    private var heroSection: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: AppRadius.large, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color.themeSky.opacity(0.86), Color.themeQuaternary.opacity(0.72)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Image("Monyet4")
                .resizable()
                .scaledToFit()
                .frame(width: 165)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 2)

            VStack(alignment: .leading, spacing: 14) {
                Text("Speak\nConfidently,\nAnywhere")
                    .font(.jakarta(28, weight: .bold))
                    .foregroundStyle(Color.themePrimary)
                    .lineSpacing(-1)

                Text("Practice real conversations\nwith the PREP method.")
                    .font(.jakarta(13, weight: .medium))
                    .foregroundStyle(Color.themeSecondary)

                NavigationLink {
                    PracticeSetupView(topic: viewModel.topics.first ?? TopicPreset.education.topic)
                } label: {
                    Label("Start Practicing", systemImage: "arrow.right")
                        .font(.jakarta(15, weight: .bold))
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                }
                .practicePrimaryAction()
                .padding(.trailing, 8)
            }
            .padding(18)
            .frame(maxWidth: 210, alignment: .leading)
        }
        .frame(height: 220)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.extraLarge, style: .continuous))
    }


    private var topicHeader: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Find Your\nNext Conversation")
                .font(.jakarta(28, weight: .bold))
                .foregroundStyle(Color.themePrimary)

            Text("Choose a topic and start practicing.\nReal topics, real confidence.")
                .font(.jakarta(13, weight: .medium))
                .foregroundStyle(Color.themeSecondary)
        }
    }

    private var topicGrid: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(viewModel.topics) { topic in
                NavigationLink(destination: PracticeSetupView(topic: topic)) {
                    OptionCard(topic: topic)
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

#Preview {
    ContentView()
}
