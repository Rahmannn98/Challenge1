import SwiftUI

struct ContentView: View {
    @State private var viewModel = HomeViewModel()
    @State private var navigationID = UUID()

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 22) {
                        topBar
                        heroSection
                        quickActions
                        topicHeader
                        topicSearch
                        topicFilters
                        topicGrid
                    }
                    .padding(.horizontal, AppSpacing.screen)
                    .padding(.top, 18)
                    .padding(.bottom, 96)
                }
                .appScreenBackground()

                bottomNavigation
            }
        }
        .id(navigationID)
        .font(.jakarta(15))
        .task {
            for await _ in NotificationCenter.default.notifications(named: .returnToHome) {
                navigationID = UUID()
            }
        }
    }

    private var topBar: some View {
        HStack(spacing: 12) {
            Text(String(viewModel.profile.displayName.prefix(1)))
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

            VStack(alignment: .leading, spacing: 3) {
                Text("Good morning,")
                    .font(.jakarta(12, weight: .medium))
                    .foregroundStyle(Color.themeSecondary)

                Text("\(viewModel.profile.displayName)!")
                    .font(.jakarta(17, weight: .bold))
                    .foregroundStyle(Color.themePrimary)
            }

            Spacer()

            Image(systemName: "bell.badge.fill")
                .font(.jakarta(16, weight: .bold))
                .foregroundStyle(Color.themePrimary)
                .frame(width: 42, height: 42)
                .background(Color.white.opacity(0.92))
                .clipShape(Circle())
                .shadow(color: Color.themePrimary.opacity(0.08), radius: 12, y: 6)
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

    private var quickActions: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            featureCard(title: "Choose a Topic", subtitle: "Pick from various\nlife scenarios", symbolName: "briefcase.fill", color: .themePeach)
            featureCard(title: "Practice with PREP", subtitle: "Follow the timer\nguidance", symbolName: "mic.fill", color: Color(red: 0.88, green: 0.86, blue: 1.0))
            featureCard(title: "Listen & Reflect", subtitle: "Review your\nrecording", symbolName: "play.circle.fill", color: .themeSky)
            featureCard(title: "Track Progress", subtitle: "See your growth\nover time", symbolName: "chart.bar.fill", color: .themeQuaternary)
        }
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

    private var topicSearch: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color.themeSecondary)

            TextField("Search or add topic...", text: $viewModel.newTopicTitle)
                .font(.jakarta(13, weight: .medium))

            Button {
                viewModel.addTopic()
            } label: {
                Image(systemName: "slider.horizontal.3")
                    .font(.jakarta(14, weight: .bold))
                    .foregroundStyle(Color.themePrimary)
                    .frame(width: 38, height: 38)
                    .background(Color.themeTertiary)
                    .clipShape(Circle())
            }
            .disabled(!viewModel.canAddTopic)
        }
        .padding(.leading, 16)
        .padding(.trailing, 6)
        .padding(.vertical, 6)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.large, style: .continuous))
        .shadow(color: Color.themePrimary.opacity(0.06), radius: 14, y: 8)
    }

    private var topicFilters: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                filterChip("All", isSelected: true)
                filterChip("Personal")
                filterChip("Academic")
                filterChip("Career")
                filterChip("Social")
            }
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

    private func featureCard(title: String, subtitle: String, symbolName: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: symbolName)
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(Color.themePrimary)
                .frame(width: 58, height: 58)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

            VStack(alignment: .leading, spacing: 7) {
                Text(title)
                    .font(.jakarta(14, weight: .bold))
                    .foregroundStyle(Color.themePrimary)

                Text(subtitle)
                    .font(.jakarta(12, weight: .medium))
                    .foregroundStyle(Color.themeSecondary)
                    .lineSpacing(2)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 148, alignment: .leading)
        .padding(16)
        .background(Color.white.opacity(0.86))
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.large, style: .continuous))
        .shadow(color: Color.themePrimary.opacity(0.05), radius: 14, y: 8)
    }

    private func filterChip(_ title: String, isSelected: Bool = false) -> some View {
        Text(title)
            .font(.jakarta(12, weight: .bold))
            .foregroundStyle(isSelected ? Color.white : Color.themeInkMuted)
            .padding(.horizontal, 15)
            .padding(.vertical, 9)
            .background(isSelected ? Color.themePrimary : Color.white.opacity(0.88))
            .clipShape(Capsule())
    }

    private var bottomNavigation: some View {
        HStack {
            navItem("house.fill", "Home", isSelected: true)
            navItem("square.grid.2x2.fill", "Topics")
            navItem("mic.fill", "Practice")
            navItem("chart.bar.fill", "Progress")
            navItem("person.fill", "Profile")
        }
        .padding(.horizontal, 18)
        .padding(.top, 12)
        .padding(.bottom, 10)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .padding(.horizontal, 18)
        .padding(.bottom, 10)
    }

    private func navItem(_ symbolName: String, _ title: String, isSelected: Bool = false) -> some View {
        VStack(spacing: 5) {
            Image(systemName: symbolName)
                .font(.jakarta(15, weight: .bold))

            Text(title)
                .font(.jakarta(10, weight: .bold))
        }
        .foregroundStyle(isSelected ? Color.themePrimary : Color.themeSecondary.opacity(0.68))
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ContentView()
}
