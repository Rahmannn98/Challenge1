import SwiftUI

struct ProfileView: View {
    @Environment(PracticeSessionStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Your profile") {
                    TextField("Display name", text: $name)
                        .textContentType(.name)
                    Text("Your initials: \(store.profile.initials)")
                        .foregroundStyle(.secondary)
                }
                Section("Privacy") {
                    Text("Your profile and practice history are stored only on this device.")
                        .font(.footnote)
                }
            }
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { store.updateProfile(name: name); dismiss() }
                        .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .onAppear { name = store.profile.displayName }
        }
    }
}
