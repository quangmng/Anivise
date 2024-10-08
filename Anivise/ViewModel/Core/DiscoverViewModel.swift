//
//  DiscoverViewModel.swift
//  Anivise
//
//  Created by Quang Minh Nguyen on 7/10/2024.
//

import Foundation
import Combine

class DiscoverViewModel: ObservableObject {
    @Published var animeList: [Anime] = []
    @Published var searchText: String = ""
    @Published var filteredAnimeList: [Anime] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    func fetchAnimeList() {
        isLoading = true
        NetworkManager.shared.fetchAnimeList { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let fetchedAnime):
                    self?.animeList = fetchedAnime
                    self?.filteredAnimeList = fetchedAnime // Set initial filtered list
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func filterAnimeList() {
        if searchText.isEmpty {
            filteredAnimeList = animeList
        } else {
            filteredAnimeList = animeList.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
}
