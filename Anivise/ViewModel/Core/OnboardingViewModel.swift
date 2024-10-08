//
//  OnboardingViewModel.swift
//  Anivise
//
//  Created by Quang Minh Nguyen on 8/10/2024.
//

import SwiftUI
import CoreData

class OnboardingViewModel: ObservableObject {
    @Published var selectedGenres: [String] = []

    // Load saved genres from Core Data
    func loadPreferences() {
        let context = PersistenceController.shared.container.viewContext
        let request: NSFetchRequest<UserPreference> = UserPreference.fetchRequest()

        do {
            if let userPreference = try context.fetch(request).first {
                self.selectedGenres = userPreference.favouriteGenres?.components(separatedBy: ",") ?? []
            }
        } catch {
            print("Failed to fetch preferences: \(error)")
        }
    }

    // Save selected genres to Core Data
    func savePreferences() {
        let context = PersistenceController.shared.container.viewContext
        let request: NSFetchRequest<UserPreference> = UserPreference.fetchRequest()

        do {
            // Fetch existing preferences or create a new one
            let userPreference = try context.fetch(request).first ?? UserPreference(context: context)
            userPreference.favouriteGenres = selectedGenres.joined(separator: ",")

            try context.save()
            PreferencesHelper.saveOnboardingStatus(true) // Mark onboarding as complete
        } catch {
            print("Failed to save preferences: \(error)")
        }
    }
    
    // Saving local User favourite gernres to Firestore
    func savePreferencesToCloud(userID: String) {
        FirestoreManager().saveFavourites(userID: userID, favouriteGenres: selectedGenres) { error in
            if let error = error {
                print("Failed to save to Firestore: \(error)")
            } else {
                print("Successfully saved to Firestore!")
            }
        }
    }
}
