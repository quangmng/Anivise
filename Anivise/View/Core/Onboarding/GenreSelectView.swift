//
//  GenreSelectView.swift
//  Anivise
//
//  Created by Quang Minh Nguyen on 8/10/2024.
//

import SwiftUI

struct GenreSelectView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = OnboardingViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                Text("Select Your Favourite Genres")
                    .font(.headline)
                    .padding()

                // Genres List
                List(viewModel.allGenres, id: \.name) { genre in
                    HStack {
                        Text(genre.name)
                        Spacer()
                        if viewModel.selectedGenres.contains(genre.name) {
                            Image(systemName: "checkmark.circle.fill")
                            
                            // make it toggle from blank circle to checkmark
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if let index = viewModel.selectedGenres.firstIndex(of: genre.name) {
                            viewModel.selectedGenres.remove(at: index)
                        } else {
                            viewModel.selectedGenres.append(genre.name)
                        }
                    }
                }

                // Save Preferences Button
                Button(action: {
                    viewModel.savePreferences()
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
                    self.presentationMode.wrappedValue.dismiss()
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
                viewModel.loadPreferences()
                viewModel.fetchSfwGenres()
            }
        }
    }
}

struct GenreSelectView_Previews: PreviewProvider {
    static var previews: some View {
        GenreSelectView()
    }
}
