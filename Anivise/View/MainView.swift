//
//  MainView.swift
//  Anivise
//
//  Created by Quang Minh Nguyen on 8/10/2024.
//

import SwiftUI

struct MainView: View {
    @State private var isTabViewHidden = false
    @State private var selectedAnime: Anime? = nil
    
    var body: some View {
            if !isTabViewHidden {
                if #available(iOS 18.0, *) {
                    // iOS 18+ uses the new Tab code
                    TabView {
                        Tab("Home", systemImage: "house") {
                            NavigationStack {
                                HomeView()
                                    .navigationBarTitle("Home")
                            }
                            
                        }

                        Tab("Discover", systemImage: "film.stack") {
                            NavigationStack {
                                DiscoverView()
                                    .navigationBarTitle("Discover")
                                    .toolbarBackground(.visible, for: .navigationBar)
                            }
                        }

                        Tab("Preferences", systemImage: "gear") {
                            NavigationStack {
                                PreferencesView()
                                    .navigationBarTitle("Preferences")
                            }
                        }
                    }
                    .tabViewStyle(.sidebarAdaptable)
                    .fullScreenCover(item: $selectedAnime) {
                        anime in AnimeDetailView(anime: anime)
                            .onDisappear{
                                isTabViewHidden = false
                            }
                    }
                } else {
                    // Fallback for iOS 17 and earlier using .tabItem
                    TabView {
                        NavigationStack {
                            HomeView()
                                .navigationBarTitle("Home")
                                .toolbarBackground(.visible, for: .navigationBar)
                        }
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }

                        NavigationStack {
                            DiscoverView()
                                .navigationBarTitle("Discover")
                        }
                        .tabItem {
                            Label("Discover", systemImage: "film.stack")
                        }

                        NavigationStack {
                            PreferencesView()
                                .navigationBarTitle("Preferences")
                        }
                        .tabItem {
                            Label("Preferences", systemImage: "gear")
                        }
                }
                    .fullScreenCover(item: $selectedAnime) {
                        anime in AnimeDetailView(anime: anime)
                            .onDisappear{
                                isTabViewHidden = false
                            }
                    }
            }
        }
    }
}

#Preview {
    MainView()
}
