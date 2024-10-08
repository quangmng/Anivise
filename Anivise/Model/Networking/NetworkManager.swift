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

    func fetchAnimeList(completion: @escaping (Result<[Anime], Error>) -> Void) {
        guard let url = URL(string: "https://api.jikan.moe/v4/anime") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(AnimeResponse.self, from: data)
                completion(.success(decodedResponse.data))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

