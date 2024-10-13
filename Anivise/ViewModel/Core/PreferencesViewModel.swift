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
        
        // Reload the favouritedGenres to ensure it's up-to-date
        genreViewModel.loadUserGenres()
        print("Firestore genres to upload: \(genreViewModel.favouritedGenres)")
        
        
        // Ensure there are no empty genre names
        if genreViewModel.favouritedGenres.isEmpty {
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

        FirestoreManager().saveFavourites(userID: userID, favouriteGenres: genreViewModel.favouritedGenres) { error in
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
            self.alertMessage = "Timed out in 10 seconds. Either Server down or no internet connection."
            self.showAlert = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: timeoutWorkItem!)

        FirestoreManager().fetchFavourites(userID: userID) { [weak self] favouriteGenres, error in
            self?.isRestoring = false
            timeoutWorkItem?.cancel()

            if let error = error {
                self?.alertMessage = "Failed to restore genres: \(error.localizedDescription)"
                self?.showAlert = true
            } else if let favouriteGenres = favouriteGenres {
                
                self?.genreViewModel.loadGenres()
                
                // Update Core Data with restored genres (mark as favourited)
                self?.genreViewModel.updateCloudFavouritedGenres(restoredGenres: favouriteGenres)
                print("Fetched favourite genres from Firestore: \(favouriteGenres)")
                // IMPORTANT: Ensure 'allGenres' is populated here before updating
                if self?.genreViewModel.allGenres.isEmpty == true {
                    // Fetch from Core Data or API if not already loaded
                    self?.genreViewModel.loadGenres()
                }
                
                // Update Core Data with restored genres (mark as favourited)
                self?.genreViewModel.updateCloudFavouritedGenres(restoredGenres: favouriteGenres)
                self?.alertMessage = "Successfully restored genres from Cloud!"
                self?.showAlert = true
                
                
            }
            else {
                        self?.alertMessage = "No favorite genres found to restore."
                        self?.showAlert = true
                    }
        }
    }
}
