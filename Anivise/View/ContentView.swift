//
//  ContentView.swift
//  Anivise
//
//  Created by Quang Minh Nguyen on 5/10/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var showOnboarding = !PreferencesHelper.isOnboardingCompleted()
    
    var body: some View {
        MainView()
            .onAppear {
                // Show the onboarding if it has not been completed
                showOnboarding = !PreferencesHelper.isOnboardingCompleted()
            }
            .sheet(isPresented: $showOnboarding) {
                OnboardingView()
            }
    }
}

#Preview {
    ContentView()
}
