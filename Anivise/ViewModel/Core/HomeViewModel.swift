//
//  HomeViewModel.swift
//  Anivise
//
//  Created by Quang Minh Nguyen on 13/10/2024.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var animeOfTheDay: Anime? // Stores daily recommendation
    @Published var likedAnime: [Anime] = [] // User's liked anime list
    @Published var allAvailableAnime: [Anime] = [] // All available anime (from API or Core Data)
    @Published var isAniviseViewActive: Bool = false // Tracks AniviseView activation
    @Published var errorMessage = ""
    @Published var loading: Bool = false
    private var genreViewModel = GenreViewModel() // To access user-selected genres

    init() {
        loadLikedAnime()
        fetchRandomAnimeOfTheDay()
    }
    
    
    func loadHomeData() {
        loading = true
        // Fetch user's liked genres
        genreViewModel.loadUserGenres()

        // Fetch anime based on user's liked genres
        let likedGenres = genreViewModel.favouritedGenres
        fetchAnimeByGenres(likedGenres: likedGenres) { [weak self] animeList in
            DispatchQueue.main.async {
                if animeList.isEmpty {
                    self?.errorMessage = "No anime matches the user's favourite genres."
                    return
                }
                
                self?.likedAnime = animeList
                // Random Anime of the Day
                self?.animeOfTheDay = animeList.randomElement()
                self?.loading = false

                print("Loaded \(animeList.count) anime matching user's genres")
            }
        }
    }

    // Fetch Anime from API or local storage
    private func fetchAnimeByGenres(likedGenres: [String], completion: @escaping ([Anime]) -> Void) {
        NetworkManager.shared.fetchAllAnime { result in
            switch result {
            case .success(let allAnime):
                let filteredAnime = allAnime.filter { anime in
                    // Checking if the anime matches user's favourited genres
                    let animeGenres = anime.genres?.map { $0.name } ?? []
                    return !Set(likedGenres).isDisjoint(with: Set(animeGenres))
                }
                completion(filteredAnime)
            case .failure(let error):
                print("Failed to fetch anime: \(error.localizedDescription)")
                completion([])
            }
        }
    }

    // Fetch a random anime based on the user's liked genres
    func fetchRandomAnimeOfTheDay() {
        let likedGenres = genreViewModel.favouritedGenres

        // Filter anime that contains any of the user's liked genres
        let filteredAnime = allAvailableAnime.filter { anime in
            // Check if the anime's genres contain any of the user's liked genres by name
            let genreNames = anime.genres?.map { $0.name } ?? []
            return likedGenres.contains(where: genreNames.contains)
        }

        if let randomAnime = filteredAnime.randomElement() {
            self.animeOfTheDay = randomAnime
        } else {
            print("No anime matches the user's favourite genres.")
        }
    }

    // Load liked anime (from CoreData or API)
    func loadLikedAnime() {
        // Placeholder: Load the liked anime from CoreData
        self.likedAnime = loadFromCoreDataOrAPI()
    }

    // Add anime to the liked list and save it
    func addLikedAnime(_ anime: Anime) {
        likedAnime.append(anime)
        saveToStorage(anime)
    }

    // Remove anime from the liked list
    func removeLikedAnime(_ anime: Anime) {
        likedAnime.removeAll { $0.id == anime.id }
        deleteFromStorage(anime)
    }

    // Open the AniviseView (card-swiping view)
    func openAniviseView() {
        isAniviseViewActive = true
    }

    // Save the updated liked anime list to CoreData
    private func saveToStorage(_ anime: Anime) {
        // Placeholder: Implement saving logic to CoreData
    }

    // Load from CoreData or API
    private func loadFromCoreDataOrAPI() -> [Anime] {
        // Placeholder: Fetch from CoreData or API
        return []
    }

    // Delete anime from storage
    private func deleteFromStorage(_ anime: Anime) {
        // Placeholder: Implement delete logic from CoreData
    }
}
