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
    
    // Generic function to fetch anime list, allowing flexibility for different endpoints
    func fetchAnimeList(endpoint: String = "/anime", completion: @escaping (Result<[Anime], Error>) -> Void) {
        // Construct the full URL
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            // Check for network error
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Check for missing data
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            // Decode JSON response
            do {
                let decodedResponse = try JSONDecoder().decode(AnimeResponse.self, from: data)
                completion(.success(decodedResponse.data))
            } catch {
                completion(.failure(NetworkError.decodingError(error)))
            }
        }.resume()
    }
}

