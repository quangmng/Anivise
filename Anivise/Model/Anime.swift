//
//  Anime.swift
//  Anivise
//
//  Created by Quang Minh Nguyen on 7/10/2024.
//

struct AnimeResponse: Codable {
    let data: [Anime]
}

struct Anime: Codable, Identifiable {
    let id: Int
    let title: String
    let synopsis: String
    let images: AnimeImages
    let genres: [AnimeGenre]? // Capturing genres

    enum CodingKeys: String, CodingKey {
        case id = "mal_id"
        case title
        case synopsis
        case images
        case genres
    }
}

struct AnimeImages: Codable {
    let jpg: AnimeImageDetails
}

struct AnimeImageDetails: Codable {
    let imageUrl: String

    enum CodingKeys: String, CodingKey {
        case imageUrl = "image_url"
    }
}

struct AnimeGenre: Codable {
    let name: String
}
