//
//  Succsess.swift
//  Challenge1
//
//  Created by Saifulloh Rahman on 03/05/26.
//

import SwiftUI

struct Succsess: View {
    let onDone: () -> Void

    @Environment(\.dismiss) private var dismiss

    @State private var heroBounce = false
    @State private var accentFloat = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.white,
                    Color.themeQuaternary.opacity(0.55),
                    Color.white
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 28) {
                Spacer(minLength: 24)

                VStack(spacing: 12) {
                    Text("Success")
                        .font(.caption.weight(.bold))
                        .tracking(1.4)
                        .foregroundStyle(Color.themeSecondary)

                    Text("Congratulations")
                        .font(.system(size: 36, weight: .black, design: .rounded))
                        .foregroundStyle(Color.themePrimary)

                    Text("You finished your practice session. Keep the momentum and return for the next round.")
                        .font(.subheadline.weight(.medium))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.themeSecondary)
                        .padding(.horizontal, 16)
                }

                ZStack {
                    Circle()
                        .fill(Color.themeSecondary.opacity(0.12))
                        .frame(width: 250, height: 250)
                        .scaleEffect(heroBounce ? 1.03 : 0.92)
                        .blur(radius: 2)

                    Image("Monyet4")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 230, height: 230)
                        .offset(y: heroBounce ? -10 : 8)
                        .shadow(color: Color.themeSecondary.opacity(0.24), radius: 24, y: 14)
                }
                .frame(height: 280)

                VStack(alignment: .leading, spacing: 12) {
                    Label("Practice completed", systemImage: "checkmark.seal.fill")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(Color.themePrimary)

                    Text("Your session has been saved as completed.")
                        .font(.subheadline)
                        .foregroundStyle(Color.themeSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(22)
                .practiceGlassCard(cornerRadius: 28)

                Button {
                    handleDone()
                } label: {
                    Text("Done")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
                .practicePrimaryAction()

                Spacer(minLength: 20)
            }
            .frame(maxWidth: 720)
            .padding(.horizontal, 24)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.25).repeatForever(autoreverses: true)) {
                heroBounce = true
            }

            withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
                accentFloat = true
            }
        }
    }

    private func handleDone() {

        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(150))
            onDone()
        }
    }
}

#Preview {
    Succsess(onDone: {})
}
