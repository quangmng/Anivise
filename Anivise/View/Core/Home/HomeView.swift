//
//  HomeView.swift
//  Anivise
//
//  Created by Quang Minh Nguyen on 6/10/2024.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var hasLoadedOnce = false
    @Namespace private var heroTransition
    
    var body: some View {
        NavigationStack {
            if viewModel.loading {
                // Show a progress view while loading
                VStack {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                }
            } else {
                ScrollView {
                    
                    VStack(alignment: .leading, spacing: 20) {
                        // Banner View: Anime of the Day
                        if let animeOfTheDay = viewModel.animeOfTheDay {
                            NavigationLink {
                                if #available(iOS 18.0, *) {
                                    AnimeDetailView(anime: animeOfTheDay)
                                        .navigationTransition(.zoom(sourceID: animeOfTheDay, in: heroTransition))
                                        .matchedTransitionSource(id: animeOfTheDay, in: heroTransition)
                                } else {
                                    // Fallback on earlier versions
                                    AnimeDetailView(anime: animeOfTheDay)
                                }
                                
                            } label: {
                                AnimeOfTheDayBanner(anime: animeOfTheDay)
                                    .padding(.top)
                            }
                            
                        }
                        else {
                            // Placeholder if no anime of the day
                            Text("No Anime of the Day available")
                                .font(.headline)
                                .padding()
                        }
                        
                        VStack {
                            StartSwipingButton()
                        }
                        
                        
                        
                        // Liked Anime Section (LazyHStack)
                        VStack(alignment: .leading) {
                            Text("You Might like...")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: 20) {
                                    ForEach(viewModel.likedAnime) { anime in
                                        NavigationLink {
                                            if #available(iOS 18.0, *) {
                                                AnimeDetailView(anime: anime)
                                                    .navigationTransition(.zoom(sourceID: anime, in: heroTransition))
                                                    .matchedTransitionSource(id: anime, in: heroTransition)
                                            } else {
                                                // Fallback on earlier versions
                                                AnimeDetailView(anime: anime)
                                            }
                                        } label: {
                                            VStack {
                                                // Anime cover using AsyncImage
                                                AsyncImage(url: URL(string: anime.images.jpg.imageUrl))
                                                { image in
                                                    image
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(width: 150, height: 200)
                                                    
                                                }
                                                placeholder: {
                                                    // Placeholder while the image loads
                                                    ProgressView()
                                                        .frame(width: 150, height: 200)
                                                }
                                                .clipShape(.rect(cornerRadius: 10))
                                                
                                                // Anime title
                                                Text(anime.title)
                                                    .font(.subheadline)
                                                    .frame(width: 150)
                                                    .lineLimit(1)
                                            }
                                        }
                                    }
                                    
                                }
                                
                                .padding(.horizontal)
                            }
                            
                        }
                    }
                    
                }
            }
        }
        .onAppear {
            if !hasLoadedOnce {
                viewModel.loadHomeData() // Load data on view appearance
                hasLoadedOnce = true
                }
            }
        }
    }

#Preview {
    HomeView()
}
