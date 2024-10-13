//
//  PreferencesView.swift
//  Anivise
//
//  Created by Quang Minh Nguyen on 6/10/2024.
//

import SwiftUI
import FirebaseAuth

struct PreferencesView: View {
    @StateObject private var viewModel = PreferencesViewModel()
    @StateObject private var genreViewModel = GenreViewModel()
    @State private var showLogin = false
    @State private var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    @State private var showGenre = false
    @State private var showOnboarding = false
    @State private var pendingPresentation: (() -> Void)? = nil // Store the pending presentation

    var body: some View {
        List {
            Section("Personalise") {
                Button(){
                    showGenre = true
                } label: {
                    HStack{
                        Image(systemName: "star.square.on.square.fill")
                        Text("Reopen Genre Selection")
                    }
                }
                .sheet(isPresented: $showGenre) {
                    NavigationStack{
                        GenreSelectView()
                            .onAppear {genreViewModel.loadGenres()}
                    }
                }
                .presentationDetents([.large])
            }
            
            
            if viewModel.userLoggedIn {
                Section("Cloud Sync") {
                    // Show the ProgressView or the Save Button based on `isSaving` state
                    if viewModel.isSaving {
                        HStack {
                            Text("Saving your preferences to Cloud...")
                            Spacer()
                            ProgressView()
                        }
                    } else {
                        Button(){
                            viewModel.saveGenresToFirestore()
                        } label:{
                            HStack {
                                Image(systemName: "icloud.and.arrow.up")
                                    .foregroundColor(.blue)
                                Text("Save preferences to Cloud")
                            }
                        }
                    }
                    if viewModel.isRestoring {
                        HStack {
                            Text("Restoring your Cloud preferences...")
                            Spacer()
                            ProgressView()
                        }
                        } else {
                            Button() {
                                viewModel.restoreGenresFromCloud()
                            } label: {
                                HStack {
                                    Image(systemName: "icloud.and.arrow.down")
                                        .foregroundColor(.blue)
                                    Text("Restore Cloud preferences")
                                }
                            }
                        }
                }
            }
            
            Section("Account") {
                if viewModel.userLoggedIn {
                    // Display the user's email
                    if let email = viewModel.userEmail {
                        HStack {
                            Image(systemName: "person.fill")
                            Text("Hello, \(email)!")
                        }
                    }

                    Button(){
                        viewModel.signOut()
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Sign Out")
                        }
                        .foregroundColor(.red)
                    }
                } else {
                    Text("Sign in to sync your preferences across devices")
                    Button {
                        showLogin = true // Show login sheet when triggered
                    } label: {
                        HStack{
                            Image(systemName: "person.fill")
                            Text("Sign In")
                        }
                    }
                    .sheet(isPresented: $showLogin) {
                        NavigationStack {
                            LoginView()
                                .navigationTitle("Sign In")
                                .toolbar {
                                    ToolbarItem(placement: .navigationBarTrailing) {
                                        Button() {
                                            showLogin = false // Close sheet manually
                                        } label: {
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
                startAuthListener() // Start listening to auth changes
            }
            .onDisappear {
                stopAuthListener() // Stop the listener when the view disappears
            }

            Section("Onboarding") {
                Button {
                    showOnboarding.toggle()
                } label: {
                    HStack{
                        Image(systemName: "list.bullet")
                        Text("Show Onboarding")
                    }
                }
                .sheet(isPresented: $showOnboarding) {
                    NavigationStack {
                        ReOnboardView()
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
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Cloud Sync"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    // Handle the Firebase Authentication state change listener
    private func startAuthListener() {
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                viewModel.userLoggedIn = true
                viewModel.userEmail = user.email
                showLogin = false
            } else {
                viewModel.userLoggedIn = false
                viewModel.userEmail = nil
            }
        }
    }

    private func stopAuthListener() {
        if let handle = authStateDidChangeListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    // Function to queue up presentations
    private func schedulePresentation(_ presentation: @escaping () -> Void) {
        if pendingPresentation == nil && !showLogin && !showGenre && !showOnboarding {
            // If nothing is being shown, present immediately
            presentation()
        } else {
            // Queue the presentation if something is already being shown
            pendingPresentation = presentation
        }
    }
    
    
    // Process the next pending presentation, if any
    private func processNextPendingPresentation() {
        if let nextPresentation = pendingPresentation {
            pendingPresentation = nil
            nextPresentation()
        }
    }
    
}

#Preview {
    PreferencesView()
}
