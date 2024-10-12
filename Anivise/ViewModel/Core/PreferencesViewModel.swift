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
    // Add the states to manage saving progress and alerts
    @Published var isSaving = false
    @Published var isRestoring = false
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    private var genreViewModel = GenreViewModel()
    
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

    // Save genres to Firestore (user's favourited genres)
    func saveGenresToFirestore() {
        guard let user = Auth.auth().currentUser else { return }
        let userID = user.uid
        // trigger ProgressView
        isSaving = true
        
        // Convert the selected genres only (based on isFavourited)
        let favouriteGenres = genreViewModel.loadGenresFromCoreData()
            .filter { $0.isFavourited == true } // Only genres marked as favourite
            .compactMap { $0.name } // Ensure we only get the names
        
        // Ensure there are no empty genre names
        if favouriteGenres.isEmpty {
            self.alertMessage = "No favourite genres selected to save."
            self.showAlert = true
            self.isSaving = false
            return
        }
        
        // Activate timeout timer
        var timeoutWorkItem: DispatchWorkItem?
        timeoutWorkItem = DispatchWorkItem {
            self.isSaving = false
            self.alertMessage = "Timed out in 10 seconds. Either server is down or no internet connection."
            self.showAlert = true
        }

        // Timeout if operation takes more than 10 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: timeoutWorkItem!)

        FirestoreManager().saveFavourites(userID: userID, favouriteGenres: favouriteGenres) { error in
            self.isSaving = false
            // Stop the timeout countdown
            timeoutWorkItem?.cancel()

            if let error = error {
                self.alertMessage = "Failed to save genres: \(error.localizedDescription)"
                self.showAlert = true
            } else {
                self.alertMessage = "Successfully saved genres to Cloud!"
                self.showAlert = true
            }
        }
    }
    
    // Restore genres from Firestore and update the isFavourited flags in Core Data
    func restoreGenresFromCloud() {
        guard let user = Auth.auth().currentUser else { return }
        let userID = user.uid

        isRestoring = true
        var timeoutWorkItem: DispatchWorkItem?
        timeoutWorkItem = DispatchWorkItem {
            self.isRestoring = false
            self.alertMessage = "Timed out in 10 seconds. Server down or no internet."
            self.showAlert = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: timeoutWorkItem!)

        FirestoreManager().fetchFavourites(userID: userID) { [weak self] genreNames, error in
            self?.isRestoring = false
            timeoutWorkItem?.cancel()

            if let error = error {
                self?.alertMessage = "Failed to restore genres: \(error.localizedDescription)"
                self?.showAlert = true
            } else if let genreNames = genreNames {
                // Update Core Data with restored genres (mark as favourited)
                self?.genreViewModel.updateFavouritedGenres(restoredGenres: genreNames)
                self?.alertMessage = "Successfully restored genres from Cloud!"
                self?.showAlert = true
            }
        }
    }
}
