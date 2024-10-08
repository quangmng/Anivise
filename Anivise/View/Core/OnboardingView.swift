//
//  OnboardingView.swift
//  Anivise
//
//  Created by Quang Minh Nguyen on 8/10/2024.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = OnboardingViewModel()

    let allGenres = ["Action", "Romance", "Comedy", "Fantasy", "Drama"]

    var body: some View {
        NavigationView {
            VStack {
                Text("Select Your Favourite Genres")
                    .font(.headline)
                    .padding()

                // Genres List
                List(allGenres, id: \.self) { genre in
                    HStack {
                        Text(genre)
                        Spacer()
                        if viewModel.selectedGenres.contains(genre) {
                            Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if let index = viewModel.selectedGenres.firstIndex(of: genre) {
                            viewModel.selectedGenres.remove(at: index)
                        } else {
                            viewModel.selectedGenres.append(genre)
                        }
                    }
                }

                // Save Preferences Button
                Button(action: {
                    viewModel.savePreferences()
                    self.presentationMode.wrappedValue.dismiss() // Dismiss the sheet
                }) {
                    Text("Save Preferences").bold().padding().background(Color.blue).foregroundColor(.white).cornerRadius(10)
                }.padding()

                // Skip Button
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Skip for Now").foregroundColor(.red)
                }.padding(.top, 20)
            }
            .onAppear {
                viewModel.loadPreferences() // Load the saved preferences on view appear
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
