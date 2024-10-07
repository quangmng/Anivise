//
//  ContentView.swift
//  Anivise
//
//  Created by Quang Minh Nguyen on 5/10/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var isTabViewHidden = false

    var body: some View {
        NavigationStack {
            if !isTabViewHidden {
                if #available(iOS 18.0, *) {
                    // iOS 18+ uses the new Tab code
                    TabView {
                        Tab("Home", systemImage: "house") {
                            HomeView()
                        }

                        Tab("Discover", systemImage: "film.stack") {
                            Text("Discover View")
                        }

                        Tab("Profile", systemImage: "person") {
                            ProfileView()
                        }
                    }
                    .navigationTitle("Anivise")
                } else {
                    // Fallback for iOS 17 and earlier using .tabItem
                    TabView {
                        HomeView()
                            .tabItem {
                                Label("Home", systemImage: "house")
                            }

                        Text("Discover View")
                            .tabItem {
                                Label("Discover", systemImage: "film.stack")
                            }

                        ProfileView()
                            .tabItem {
                                Label("Profile", systemImage: "person")
                            }
                    }
                    .navigationTitle("Anivise")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
