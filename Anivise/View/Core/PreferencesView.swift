//
//  PreferencesView.swift
//  Anivise
//
//  Created by Quang Minh Nguyen on 6/10/2024.
//

import SwiftUI
import FirebaseAuth

struct PreferencesView: View {
    @StateObject private var viewModel = PreferencesViewModel() // Bind to ViewModel
    @State private var showLogin = false
    @State private var showOnboarding = false

    var body: some View {
        List {
            Section("Appearance"){
                Text("Coming Soon")
                // Add: Switch between dark/light mode or follow system theme
                // Add: Toggle Custom haptic feedback on/off
            }
            
            Section("Cloud Sync") {
                if viewModel.userLoggedIn {
                    // Display the user's email
                    if let email = viewModel.userEmail {
                        Text("Hello, \(email)!")
                    }

                    // Sign Out button
                    Button(action: {
                        viewModel.signOut()
                    }) {
                        Text("Sign Out")
                            .foregroundColor(.red)
                    }
                } else {
                    Text("Sign in to sync your preferences across devices")
                    // Sign In button
                    Button {
                        showLogin.toggle()
                    } label: {
                        Text("Sign In")
                    }
                    .sheet(isPresented: $showLogin) {
                        NavigationStack {
                            LoginView()
                                .navigationTitle("Sign In")
                                .toolbar {
                                    ToolbarItem(placement: .navigationBarTrailing) {
                                        Button(action: {
                                            showLogin = false
                                        }) {
                                            CloseButton()
                                                .frame(width: 36, height: 36)
                                                .padding(.top)
                                        }
                                    }
                                }
                        }
                        .presentationDetents([.height(550), .large])
                    }
                }
            }
            .onAppear {
                viewModel.startAuthListener() // Start listening to auth changes
            }
            .onDisappear {
                viewModel.stopAuthListener() // Stop the listener when the view disappears
            }

            Section("Onboarding") {
                Button(){
                    showOnboarding.toggle()
                } label: {
                    Text("Show Onboarding")
                }
                .sheet(isPresented: $showOnboarding) {
                    OnboardingView()
                }
            }
        }
    }
}

#Preview {
    PreferencesView()
}
