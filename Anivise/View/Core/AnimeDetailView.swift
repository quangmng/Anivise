//
//  AnimeDetailView.swift
//  Anivise
//
//  Created by Quang Minh Nguyen on 13/10/2024.
//

import SwiftUI

struct AnimeDetailView: View {
    let anime: Anime
    
    var body: some View {
        ScrollView {
            VStack {
                // Hero Image section with overlay
                ZStack(alignment: .bottomLeading) {
                    // Anime cover image with reduced brightness
                    AsyncImage(url: URL(string: anime.images.jpg.imageUrl)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: UIScreen.main.bounds.height * 0.4)
                            .clipped()
                    } placeholder: {
                        Color.gray.frame(height: UIScreen.main.bounds.height * 0.4)
                    }
                    
                    // Dark overlay for readability
                    Rectangle()
                        .foregroundColor(Color.black.opacity(0.4))
                        .frame(height: UIScreen.main.bounds.height * 0.4)
                    
                    // Anime Title and Genre overlay
                    VStack(alignment: .leading) {
                        Text(anime.title)
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                        
                        if let genres = anime.genres?.map(\.name).joined(separator: ", ") {
                            Text(genres)
                                .font(.subheadline)
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                }
                
                // Synopsis and Save Button
                VStack(alignment: .leading, spacing: 20) {
                    Text("Synopsis")
                        .font(.title2)
                        .bold()
                        .padding(.bottom, 5)
                    
                    Text(anime.synopsis)
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    // Save button
                    Button(action: {
                        // Handle save action here
                    }) {
                        Text("Save to Library")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
}

