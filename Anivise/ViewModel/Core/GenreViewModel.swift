//
//  GenreViewModel.swift
//  Anivise
//
//  Created by Quang Minh Nguyen on 8/10/2024.
//

import SwiftUI
import CoreData

class GenreViewModel: ObservableObject {
    @Published var favouritedGenres: [String] = []
    @Published var allGenres: [AnimeGenre] = []
    
    private var context: NSManagedObjectContext {
        PersistenceController.shared.container.viewContext
    }
    
    // Load genres from Core Data when the view appears
    func loadGenres() {
        let storedGenres = loadGenresFromCoreData()

        // If there are no saved genres, fetch from the API
        if storedGenres.isEmpty {
            fetchSfwGenres()
        } else {
            self.allGenres = storedGenres
        }
    }
    
    // Load user favourited genres from Core Data
    func loadUserGenres() {
        let request: NSFetchRequest<UserPreference> = UserPreference.fetchRequest()
        
        do {
            if let userPreference = try context.fetch(request).first {
                self.favouritedGenres = userPreference.favouriteGenres?.components(separatedBy: ",") ?? []
                print("Locally fetched Favourite genres: \(favouritedGenres)")
            }
        } catch {
            print("Failed to fetch genres: \(error)")
        }
    }

    // Save favourited genres to Core Data
    func saveUserGenres() {
        let request: NSFetchRequest<UserPreference> = UserPreference.fetchRequest()

        do {
            // Fetch existing preferences or create a new one
            let userPreference = try context.fetch(request).first ?? UserPreference(context: context)
            userPreference.favouriteGenres = favouritedGenres.joined(separator: ",")

            try context.save()
            PreferencesHelper.saveOnboardingStatus(true) // Mark onboarding as complete
        } catch {
            print("Failed to save preferences: \(error)")
        }
        
        print("Locally updated Favourite genres: \(favouritedGenres)")
    }

    // Function to toggle genre favourite selection
    func toggleFavourite(genre: AnimeGenre) {
        if let index = allGenres.firstIndex(where: { $0.id == genre.id }) {
            allGenres[index].isFavourited.toggle()
            let genreName = allGenres[index].name
            
            // Update the favouritedGenres list based on the toggle action
            if allGenres[index].isFavourited == true {
                favouritedGenres.append(genreName)
            } else {
                favouritedGenres.removeAll { $0 == genreName }
            }
        }
    }
    
    
    // Update the isFavourited flag for genres that are in the restored list
    func updateIsFavouritedStatus(restoredGenres: [String]) {
        for i in 0..<allGenres.count {
            // Update only the isFavourited property if the genre is found in restoredGenres
            allGenres[i].isFavourited = restoredGenres.contains(allGenres[i].name)
        }
        print("Favourite genres: \(favouritedGenres)")
    }
    
    // Fetch list of genres from API through NetworkManager
    func fetchGenres() {
        NetworkManager.shared.fetchGenres { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let genres):
                        self?.allGenres = genres // Populate all genres
                        self?.saveGenresToCoreData(genres: genres) // Save fetched genres for offline use
                case .failure(let error):
                    print("Failed to fetch genres: \(error.localizedDescription)")
                }
            }
        }
    }

    // Fetch SFW (Safe For Work) genres from API, then save to Core Data
    func fetchSfwGenres() {
        NetworkManager.shared.fetchGenresExcludingExplicit { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let genres):
                    // Update the view model's allGenres with the filtered genres
                    self?.allGenres = genres
                    // Save SFW genres to Core Data for offline use
                    self?.saveGenresToCoreData(genres: genres)
                    print("Genres excluding explicit ones: \(genres)")
                case .failure(let error):
                    print("Failed to fetch genres: \(error.localizedDescription)")
                    // Fallback to Core Data if the API fails
                    self?.allGenres = self?.loadGenresFromCoreData() ?? []
                }
            }
        }
    }
    
    // Load saved genres from Core Data
    func loadGenresFromCoreData() -> [AnimeGenre] {
        let request: NSFetchRequest<Genre> = Genre.fetchRequest()
        do {
            let results = try context.fetch(request)
            return results.map { AnimeGenre(id: Int($0.malId), name: $0.name ?? "") }
        } catch {
            print("Failed to fetch genres from Core Data: \(error)")
            return []
        }
    }

    // Save genres to Core Data
    func saveGenresToCoreData(genres: [AnimeGenre]) {
        // First, clear the old/last updated genres
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Genre.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
        } catch {
            print("Failed to clear old genres: \(error)")
        }

        // Saving the new genres
        genres.forEach { genre in
            let newGenre = Genre(context: context)
            newGenre.malId = Int16(genre.id)
            newGenre.name = genre.name
        }

        do {
            try context.save()
        } catch {
            print("Failed to save genres to Core Data: \(error)")
        }
    }
    
    // Load favourited local genres from Core Data
        func loadFavouritedGenres() {
            let request: NSFetchRequest<UserPreference> = UserPreference.fetchRequest()
            do {
                if let userPreference = try context.fetch(request).first {
                    self.favouritedGenres = userPreference.favouriteGenres?.components(separatedBy: ",") ?? []
                }
            } catch {
                print("Failed to fetch favourited genres: \(error)")
            }
        }

        // Save favourited local genres to Core Data
        func saveFavouritedGenres() {
            let request: NSFetchRequest<UserPreference> = UserPreference.fetchRequest()
            do {
                let userPreference = try context.fetch(request).first ?? UserPreference(context: context)
                userPreference.favouriteGenres = favouritedGenres.joined(separator: ",")
                try context.save()
            } catch {
                print("Failed to save favourited genres: \(error)")
            }
        }
    
    // Update the `isFavourited` status of genres based on restored data
    func updateCloudFavouritedGenres(restoredGenres: [String]) {
        print("Fetched favourite genres from Firestore: \(restoredGenres)")
        
        // Check if allGenres is empty
        if allGenres.isEmpty {
            print("Error: allGenres is empty. Ensure genres are loaded before updating.")
            return
        }

        for i in 0..<allGenres.count {
            let normalizedName = allGenres[i].name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            let shouldBeFavourited = restoredGenres.contains { restored in
                restored.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == normalizedName
            }
            allGenres[i].isFavourited = shouldBeFavourited
        }

        favouritedGenres = allGenres.filter { $0.isFavourited }.map { $0.name }
        
        print("Updated allGenres: \(allGenres)")
        print("Updated favouritedGenres: \(favouritedGenres)")
        
        saveGenresToCoreData(genres: allGenres)
    }
}
