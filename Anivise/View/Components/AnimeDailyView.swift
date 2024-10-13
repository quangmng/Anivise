//
//  AnimeDailyView.swift
//  Anivise
//
//  Created by Quang Minh Nguyen on 13/10/2024.
//

import SwiftUI

struct AnimeOfTheDayBanner: View {
    let anime: Anime

    var body: some View {
        ZStack(alignment: .bottomLeading) { // Align to bottom left
            // AsyncImage for loading
            AsyncImage(url: URL(string: anime.images.jpg.imageUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 250)
                    .clipped()
            } placeholder: {
                Color.gray.frame(height: 250)
            }
            

            // Text and gradient overlay
            VStack(alignment: .leading) {
                Text("ANIME OF THE DAY")
                    .font(.system(size: 12))
                    .bold()
                    .foregroundColor(.white)
                Text(anime.title)
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                    .shadow(radius: 10)

                if let genres = anime.genres?.map(\.name).joined(separator: ", ") {
                    Text(genres)
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .bottomLeading)
            .background(LinearGradient(gradient: Gradient(colors: [Color.black.opacity(1.25), Color.clear]), startPoint: .bottom, endPoint: .top))
        }
        .clipShape(.rect(cornerRadius: 10))
        .padding(.horizontal)
    }
}
