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
    @State private var userLoggedIn = (Auth.auth().currentUser != nil)
    @State private var showLogin = false
    @State private var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    @State private var showGenre = false
    @State private var showOnboard = false
    // Add the states to manage saving progress and alerts
    @State private var isSaving = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        List {
            Section("Personalise") {
                Button(){
                    showGenre.toggle()
                } label: {
                    Text("Reopen Genre Selection")
                }
            }
            .sheet(isPresented: $showGenre) {
                GenreSelectView()
            }
            
            if userLoggedIn {
                Section("Cloud Sync") {
                    // Show the ProgressView or the Save Button based on `isSaving` state
                    if isSaving {
                        HStack {
                            Text("Saving genres to Cloud...")
                            Spacer()
                            ProgressView()
                            
                        }
                    } else {
                        Button(){
                            saveGenresToFirestore() // Handle save in this view
                        } label:{
                            HStack {
                                Image(systemName: "icloud.and.arrow.up")
                                    .foregroundColor(.blue)
                                Text("Save Genres to Cloud")
                            }
                        }
                        Button() {
                            
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
                if userLoggedIn {
                    // Display the user's email
                    if let email = viewModel.userEmail {
                        Text("Hello, \(email)!")
                    }

                    Button(action: {
                        viewModel.signOut()
                    }) {
                        Text("Sign Out")
                            .foregroundColor(.red)
                    }
                } else {
                    Text("Sign in to sync your preferences across devices")
                    Button {
                        showLogin = true // Show login sheet when explicitly triggered
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
                                            showLogin = false // Close sheet manually
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
                startAuthListener() // Start listening to auth changes
            }
            .onDisappear {
                stopAuthListener() // Stop the listener when the view disappears
            }

            Section("Onboarding") {
                Button {
                    showGenre.toggle()
                } label: {
                    Text("Show Onboarding")
                }
                .sheet(isPresented: $showOnboard) {
                    OnboardingView()
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Cloud Sync"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    // Handle the Firebase state change listener
    private func startAuthListener() {
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                userLoggedIn = true
                viewModel.userEmail = user.email
                showLogin = false
                viewModel.loadUserPreferencesFromCloud(userID: user.uid)
            } else {
                userLoggedIn = false
                viewModel.userEmail = nil
            }
        }
    }

    private func stopAuthListener() {
        if let handle = authStateDidChangeListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    // Save genres to Firestore and handle progress/alert
    private func saveGenresToFirestore() {
        guard let user = Auth.auth().currentUser else { return }
        let userID = user.uid

        // Start showing the progress view
        isSaving = true
        let genresToSave = viewModel.loadGenresFromCoreData() // Fetch genres from Core Data

        var timeoutWorkItem: DispatchWorkItem?
        // Create a dispatch work item for the timeout
        timeoutWorkItem = DispatchWorkItem {
            // If the save hasn't completed in 15 seconds, show the timeout alert
            isSaving = false
            alertMessage = "Timed Out in 15 seconds. Either the server is down or you are not connected to the internet. Try again later."
            showAlert = true
        }

        // Schedule the timeout work item to run in 15 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 15, execute: timeoutWorkItem!)
        
        FirestoreManager().saveFavourites(userID: userID, favouriteGenres: genresToSave) { error in
            // Stop showing the progress view
            isSaving = false

            // Cancel the timeout if the operation completes in less than 15 seconds
            timeoutWorkItem?.cancel()
            
            if let error = error {
                // Show failure message
                alertMessage = "Failed to save genres to Cloud: \(error.localizedDescription)"
                showAlert = true
            } else {
                // Show success message
                alertMessage = "Successfully saved genres to Cloud!"
                showAlert = true
            }
        }
    }
}

#Preview {
    PreferencesView()
}
