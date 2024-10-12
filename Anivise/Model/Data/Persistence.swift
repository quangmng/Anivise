//
//  Persistence.swift
//  Anivise
//
//  Created by Quang Minh Nguyen on 5/10/2024.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Anivise")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    // MARK: - Save Anime Item to Core Data
    func saveAnimeItem(anime: Anime, genres: [String]) {
        let context = container.viewContext
        let animeItem = AnimeItem(context: context)
        
        // Set AnimeItem attributes
        animeItem.id = Int64(anime.id)
        animeItem.title = anime.title
        animeItem.imageURL = anime.images.jpg.imageUrl
        animeItem.synopsis = anime.synopsis
        animeItem.isFavourite = true
        animeItem.isSwipedRight = false
        
        // Add genres
        for genreName in genres {
            let genreFetchRequest: NSFetchRequest<Genre> = Genre.fetchRequest()
            genreFetchRequest.predicate = NSPredicate(format: "name == %@", genreName)
            
            if let existingGenre = try? context.fetch(genreFetchRequest).first {
                // Use existing genre if found
                animeItem.addToGenres(existingGenre)
            } else {
                // Create new genre if not found
                let newGenre = Genre(context: context)
                newGenre.name = genreName
                animeItem.addToGenres(newGenre)
            }
        }
        
        // Save context
        do {
            try context.save()
        } catch {
            print("Failed to save anime to Library: \(error.localizedDescription)")
        }
    }
    
    func saveUserPreferences(genres: String) {
            let context = container.viewContext
            let userPreference = UserPreference(context: context)
            userPreference.favouriteGenres = genres
            userPreference.isOnboarded = true

            do {
                try context.save()
            } catch {
                print("Failed to save user preferences: \(error.localizedDescription)")
            }
        }
    
    // MARK: - Fetch All Anime Items
    func fetchAllAnimeItems() -> [AnimeItem] {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<AnimeItem> = AnimeItem.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch anime items: \(error.localizedDescription)")
            return []
        }
    }
}
