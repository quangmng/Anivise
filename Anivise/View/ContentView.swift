//
//  ContentView.swift
//  Anivise
//
//  Created by Quang Minh Nguyen on 5/10/2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State private var isTabViewHidden = false
    var body: some View {
        NavigationStack {
            if !isTabViewHidden {
                TabView{
                    Tab("Home", systemImage: "house") {
                        HomeView()
                        
                    }
//                    .badge("new")
                    Tab("Discover", systemImage: "film.stack"){
                        
                    }
                    Tab("Profile", systemImage: "person"){
                        ProfileView()
                    }
                }
                .navigationTitle("Anivise")
            }
        }
        
        
    }
}
#Preview {
    ContentView()
}
