//
//  PreferencesViewModel.swift
//  Anivise
//
//  Created by Quang Minh Nguyen on 8/10/2024.
//

import FirebaseAuth
import FirebaseFirestore

class PreferencesViewModel: ObservableObject {
    @Published var userLoggedIn = Auth.auth().currentUser != nil
    @Published var userEmail: String? = Auth.auth().currentUser?.email
    @Published var selectedGenres: [String] = []
    
    private var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?

    // Firebase Authentication: Set up listener for auth state changes
    func startAuthListener() {
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            if let user = user {
                self?.userLoggedIn = true
                self?.userEmail = user.email
                self?.loadUserPreferencesFromCloud(userID: user.uid)
            } else {
                self?.userLoggedIn = false
                self?.userEmail = nil
            }
        }
    }

    func stopAuthListener() {
        if let handle = authStateDidChangeListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    // Sign out the user
    func signOut() {
        do {
            try Auth.auth().signOut()
            userLoggedIn = false
            userEmail = nil
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }

    // Load user preferences (favourite genres) from Firestore
    func loadUserPreferencesFromCloud(userID: String) {
        FirestoreManager().fetchFavourites(userID: userID) { [weak self] genres, error in
            if let error = error {
                print("Failed to load favourites from Firestore: \(error)")
            } else {
                self?.selectedGenres = genres ?? []
            }
        }
    }
}
