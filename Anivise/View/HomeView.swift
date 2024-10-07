//
//  HomeView.swift
//  Anivise
//
//  Created by Quang Minh Nguyen on 6/10/2024.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack{
            ZStack {
                VStack{
                    Text("For you:")
                }
            }
            .navigationTitle("Anivise")
        }
    }
}

#Preview {
    HomeView()
}
