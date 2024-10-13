//
//  GenreSelectView.swift
//  Anivise
//
//  Created by Quang Minh Nguyen on 8/10/2024.
//

import SwiftUI

struct GenreSelectView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = GenreViewModel()

    @State private var animationCount = 0
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Select Your Favourite Genres")
                    .font(.headline)
                    .padding()

                // Genres List
                List(viewModel.allGenres, id: \.name) { genre in
                    HStack {
                        // Toggle between filled and unfilled star based on selection
                        Image(systemName: viewModel.favouritedGenres.contains(genre.name) ? "star.fill" : "star")
                            //.symbolEffect(.bounce.wholeSymbol, value: animationCount)
                            .foregroundStyle(.yellow)
                        
                        Text(genre.name)
                            .font(.body)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.toggleFavourite(genre: genre)
                    }
                }

                // Save Preferences Button
                Button(action: {
                    viewModel.saveUserGenres()  // Save user's selected genres
                    self.presentationMode.wrappedValue.dismiss() // Dismiss the sheet
                }) {
                    Text("Save Preferences")
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                }
                .buttonStyle(.borderedProminent)
                .padding()

                // Skip Button
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss() // Dismiss without saving
                }) {
                    Text("Skip for Now")
                        .fontWeight(.light)
                        .font(.system(size: 16))
                        .foregroundColor(.red)
                }
                .buttonStyle(.bordered)
                .padding(10)
            }
            .onAppear {
                viewModel.loadUserGenres()  // Load user-selected genres
                viewModel.loadGenres()      // Load all available genres
            }
        }
    }


    private func toggleSelection(for genre: AnimeGenre) {
        if let index = viewModel.favouritedGenres.firstIndex(of: genre.name) {
            viewModel.favouritedGenres.remove(at: index)  // Remove from selection if already selected
        } else {
            viewModel.favouritedGenres.append(genre.name)  // Add to selection if not selected
        }
    }
}

struct GenreSelectView_Previews: PreviewProvider {
    static var previews: some View {
        GenreSelectView()
    }
}
