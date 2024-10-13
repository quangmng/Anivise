//
//  NetworkManager.swift
//  Anivise
//
//  Created by Quang Minh Nguyen on 7/10/2024.
//

import Foundation

class NetworkManager {
    // Singleton instance
    static let shared = NetworkManager()

    private init() {} // Prevent others from creating instances

    private let baseURL = "https://api.jikan.moe/v4"
    
    // SSOT Genre Store (Single Source of Truth)
    var genreStore: [Int: AnimeGenre] = [:] // Store genres by their mal_id

    
    func fetchGenres(completion: @escaping (Result<[AnimeGenre], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/genres/anime") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        print("Fetching from URL: \(url.absoluteString)")

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Network request failed: \(error.localizedDescription)")
                completion(.failure(NetworkError.unknown))
                return
            }

            guard let data = data else {
                print("No data returned from Server. Is it down?")
                completion(.failure(NetworkError.noData))
                return
            }

            do {
                // Decode genres from the response
                let response = try JSONDecoder().decode(AnimeGenreResponse.self, from: data)
                
                // Store genres in the centralized genreStore
                for genre in response.data {
                    self.genreStore[genre.id] = genre
                }
                
                completion(.success(response.data))
            } catch {
                print("Decoding error: \(error)")
                completion(.failure(NetworkError.decodingError(error)))
            }
        }.resume()
    }
    
    func fetchExplicitGenres(completion: @escaping (Result<[AnimeGenre], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/genres/anime?filter=explicit_genres") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        print("Fetching explicit genres from URL: \(url.absoluteString)")

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Network request failed: \(error.localizedDescription)")
                completion(.failure(NetworkError.unknown))
                return
            }

            guard let data = data else {
                print("No data returned from Server. Is it down?")
                completion(.failure(NetworkError.noData))
                return
            }

            do {
                // Decode genres from the response
                let response = try JSONDecoder().decode(AnimeGenreResponse.self, from: data)
                
                // Store genres in the centralized genreStore
                for genre in response.data {
                    self.genreStore[genre.id] = genre
                }
                
                completion(.success(response.data))
            } catch {
                print("Decoding error: \(error)")
                completion(.failure(NetworkError.decodingError(error)))
            }
        }.resume()
    }
    
    // func to Filter NSFW genres from genre selection
    func fetchGenresExcludingExplicit(completion: @escaping (Result<[AnimeGenre], Error>) -> Void) {
        let group = DispatchGroup()
        var allGenres: [AnimeGenre] = []
        var explicitGenres: [AnimeGenre] = []
        var errorOccurred: Error?
        
        // Fetch all genres
        group.enter()
        fetchGenres { result in
            switch result {
            case .success(let genres):
                allGenres = genres
            case .failure(let error):
                errorOccurred = error
            }
            group.leave()
        }
        
        // Fetch explicit genres
        group.enter()
        fetchExplicitGenres { result in
            switch result {
            case .success(let genres):
                explicitGenres = genres
            case .failure(let error):
                errorOccurred = error
            }
            group.leave()
        }
        
        // After both fetches are complete, filter out the explicit genres
        group.notify(queue: .main) {
            if let error = errorOccurred {
                completion(.failure(error))
                return
            }
            
            // Create a set of explicit genre IDs for fast filtering
            let explicitGenreIds = Set(explicitGenres.map { $0.id })
            
            // Filter out any genres whose IDs are in the explicitGenreIds set
            let filteredGenres = allGenres.filter { !explicitGenreIds.contains($0.id) }
            
            completion(.success(filteredGenres))
        }
    }

    
    // Function to fetch top 25 anime list
    func fetchDiscoverAnimeList(endpoint: String = "/top/anime", completion: @escaping (Result<[Anime], Error>) -> Void) {
        // Construct the full URL
        guard let url = URL(string: "\(baseURL)\(endpoint)?sfw=true") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        print("Fetching from URL: \(url.absoluteString)")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Network request failed: \(error.localizedDescription)")
                completion(.failure(NetworkError.unknown))
                return
            }
            
            // Check for missing data
            guard let data = data else {
                print("No data returned from Server. Is it down?")
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                // Decode the response directly into AnimeResponse
                let decodedResponse = try JSONDecoder().decode(AnimeResponse.self, from: data)
                
                // Custom initialiser handles genreIds from Anime model
                let animeWithGenreIds = decodedResponse.data

                completion(.success(animeWithGenreIds))
            } catch {
                print("Decoding error: \(error)")
                completion(.failure(NetworkError.decodingError(error)))
            }
        }.resume()
    }
    
    // Function to fetch all anime list
    func fetchAllAnime(endpoint: String = "/anime", completion: @escaping (Result<[Anime], Error>) -> Void) {
        // Construct the full URL
        guard let url = URL(string: "\(baseURL)\(endpoint)?sfw=true") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        print("Fetching from URL: \(url.absoluteString)")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Network request failed: \(error.localizedDescription)")
                completion(.failure(NetworkError.unknown))
                return
            }
            
            // Check for missing data
            guard let data = data else {
                print("No data returned from Server. Is it down?")
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                // Decode the response directly into AnimeResponse
                let decodedResponse = try JSONDecoder().decode(AnimeResponse.self, from: data)
                
                // Custom initialiser handles genreIds from Anime model
                let animeWithGenreIds = decodedResponse.data

                completion(.success(animeWithGenreIds))
            } catch {
                print("Decoding error: \(error)")
                completion(.failure(NetworkError.decodingError(error)))
            }
        }.resume()
    }
}

