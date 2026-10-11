//
//  Challenge1App.swift
//  Challenge1
//
//  Created by Saifulloh Rahman on 20/04/26.
//

import SwiftUI

@main
struct Challenge1App: App {
    @State private var sessionStore = PracticeSessionStore()
    init() {
        AppFontRegistrar.registerFonts()
    }

    var body: some Scene {
        WindowGroup {
            OnboardingRootView()
                .environment(sessionStore)
        }
    }
}
