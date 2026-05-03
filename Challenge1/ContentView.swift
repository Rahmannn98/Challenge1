//
//  ContentView.swift
//  Challenge1
//
//  Created by Saifulloh Rahman on 20/04/26.
//

import SwiftUI

struct ContentView: View {
    @State private var topics: [Topic] = [
        .education,
        .anniversary,
        .career
    ]
    @State private var newTopicTitle = ""

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    Header()

                    HeroCard()

                    Text("Choose the Topic")
                        .font(.title.bold())
                        .foregroundColor(.themePrimary)

                    addTopicSection

                    LazyVStack(spacing: 12) {
                        ForEach(topics) { topic in
                            topicRow(for: topic)
                        }
                    }
                }
                .padding()
            }
        }
    }

    private var addTopicSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Add New Topic")
                .font(.headline.bold())
                .foregroundColor(.themePrimary)

            HStack(spacing: 12) {
                TextField("Type your topic here", text: $newTopicTitle)
                    .textFieldStyle(.roundedBorder)

                Button("Add") {
                    addTopic()
                }
                .buttonStyle(.borderedProminent)
                .tint(.themePrimary)
                .disabled(newTopicTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .padding()
        .background(Color.themeSecondary.opacity(0.18))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func topicRow(for topic: Topic) -> some View {
        ZStack(alignment: .topTrailing) {
            NavigationLink(destination: ScreenPractic(topic: topic)) {
                OptionCard(title: topic.title, imageName: topic.imageName)
            }
            .buttonStyle(.plain)

            Button {
                deleteTopic(topic)
            } label: {
                Image(systemName: "trash.fill")
                    .font(.footnote.bold())
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.red)
                    .clipShape(Circle())
            }
            .padding(.top, 10)
            .padding(.trailing, 18)
        }
    }

    private func addTopic() {
        let trimmedTitle = newTopicTitle.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedTitle.isEmpty else { return }

        topics.append(
            Topic(
                title: trimmedTitle,
                imageName: "Monyet2",
                questions: ["Tell me more about \(trimmedTitle)."]
            )
        )
        newTopicTitle = ""
    }

    private func deleteTopic(_ topic: Topic) {
        topics.removeAll { $0.id == topic.id }
    }

    struct Header: View {
        var body: some View {
            VStack(alignment: .leading) {
                Text("Hai, Rahman!")
                    .font(.largeTitle.bold())
                    .foregroundColor(.themePrimary)

                Text("How are you feeling, today?")
                    .font(.subheadline)
                    .foregroundColor(.themeSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    ContentView()
}
