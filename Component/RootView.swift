//
//  OnBoard.swift
//  Challenge1
//
//  Created by Saifulloh Rahman on 22/04/26.
//

import SwiftUI

struct OnBoarding: View {
    @AppStorage("hasSeeOnboarding") var hasSeeOnboarding: Bool = false
    var body: some View {
        if hasSeeOnboarding {
            ContentView()
        } else {
            OnboardingView(hasSeeOnboarding: $hasSeeOnboarding)
            
        }
        
    }
}
