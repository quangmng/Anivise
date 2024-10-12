//
//  PreferencesViewModel.swift
//  Anivise
//
//  Created by Quang Minh Nguyen on 8/10/2024.
//

import FirebaseAuth
import FirebaseFirestore
import CoreData

class PreferencesViewModel: ObservableObject {
    @Published var userLoggedIn = Auth.auth().currentUser != nil
    @Published var userEmail: String? = Auth.auth().currentUser?.email
    @Published var selectedGenres: [String] = [] // Genres loaded from Core Data

    
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
                print("Failed to load favourites from Cloud: \(error)")
            } else {
                self?.selectedGenres = genres ?? []
            }
        }
    }

    // Fetch genres from Core Data
    func loadGenresFromCoreData() -> [String] {
        let context = PersistenceController.shared.container.viewContext
        let request: NSFetchRequest<UserPreference> = UserPreference.fetchRequest()

        do {
            if let userPreference = try context.fetch(request).first {
                return userPreference.favouriteGenres?.components(separatedBy: ",") ?? []
            } else {
                return []
            }
        } catch {
            print("Failed to fetch genres from Core Data: \(error)")
            return []
        }
    }

    // Save genres to Firestore
    func saveGenresToFirestore() {
        guard let user = Auth.auth().currentUser else { return }
        let userID = user.uid

        // Fetch genres from Core Data
        let genresToSave = loadGenresFromCoreData()

        FirestoreManager().saveFavourites(userID: userID, favouriteGenres: genresToSave) { error in
            if let error = error {
                print("Failed to save genres to Cloud: \(error)")
            } else {
                print("Successfully saved genres to Cloud!")
            }
        }
    }
}
