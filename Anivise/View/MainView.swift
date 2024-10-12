//
//  MainView.swift
//  Anivise
//
//  Created by Quang Minh Nguyen on 8/10/2024.
//

import SwiftUI

struct MainView: View {
    @State private var isTabViewHidden = false

    var body: some View {
            if !isTabViewHidden {
                if #available(iOS 18.0, *) {
                    // iOS 18+ uses the new Tab code
                    TabView {
                        Tab("Home", systemImage: "house") {
                            NavigationStack {
                                HomeView()
                                    .navigationTitle("Home")
                            }
                            
                        }

                        Tab("Discover", systemImage: "film.stack") {
                            NavigationStack {
                                DiscoverView()
                                
                                    .navigationTitle("Discover")
                            }
                        }

                        Tab("Preferences", systemImage: "gear") {
                            NavigationStack {
                                PreferencesView()
                                    .navigationTitle("Preferences")
                            }
                        }
                    }
                    .tabViewStyle(.sidebarAdaptable)
                } else {
                    // Fallback for iOS 17 and earlier using .tabItem
                    TabView {
                        NavigationStack {
                            HomeView()
                                .navigationTitle("Home")
                        }
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }

                        NavigationStack {
                            DiscoverView()
                                .navigationTitle("Discover")
                        }
                        .tabItem {
                            Label("Discover", systemImage: "film.stack")
                        }

                        NavigationStack {
                            PreferencesView()
                                .navigationTitle("Preferences")
                        }
                        .tabItem {
                            Label("Preferences", systemImage: "gear")
                        }
                }
            }
        }
    }
}

#Preview {
    MainView()
}
