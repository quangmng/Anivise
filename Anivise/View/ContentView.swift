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
                NavigationStack {
                    OnboardingView()
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button() {
                                showOnboarding = false // Close sheet manually
                            } label: {
                                CloseButton()
                                    .frame(width: 36, height: 36)
                                    .padding(.top)
                            }
                        }
                    }
                }
            }
    }
}

#Preview {
    ContentView()
}
