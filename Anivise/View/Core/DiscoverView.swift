//
//  DiscoverView.swift
//  Anivise
//
//  Created by Quang Minh Nguyen on 7/10/2024.
//

import SwiftUI

struct DiscoverView: View {
    @StateObject private var viewModel = DiscoverViewModel()
    
    var body: some View {
        NavigationStack {
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
            } else {
                List(viewModel.filteredAnimeList) { anime in
                    HStack {
                        AsyncImage(url: URL(string: anime.images.jpg.imageUrl)) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 100, height: 150)
                        .cornerRadius(8)

                        VStack(alignment: .leading) {
                            Text(anime.title)
                                .font(.headline)
                                //.padding(.bottom)
                            
                            Button() {
                                saveToFavorites(anime: anime)
                            } label: {
                                Image(systemName: "heart")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                            }
                        }
                        .padding()
                    }
                    
                    .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Looking for an anime?")
                    .onSubmit (of: .search){
                        viewModel.filterAnimeList() // Activate search when user taps "return" on keyboard
                    }
                    .searchDictationBehavior(.inline(activation: .onLook))
                    
                }
            }
        }
        .onAppear {
            viewModel.fetchAnimeList()
        }
    }

    func saveToFavorites(anime: Anime) {
        let genreNames = anime.genres?.map { $0.name } ?? [] // Safely unwrap genres
        PersistenceController.shared.saveAnimeItem(anime: anime, genres: genreNames)
    }
}

#Preview {
    DiscoverView()
}
