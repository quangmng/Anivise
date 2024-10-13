//
//  Anime.swift
//  Anivise
//
//  Created by Quang Minh Nguyen on 7/10/2024.
//

// MARK: - Anime Items fetching
struct AnimeResponse: Codable {
    let data: [Anime]
}

struct Anime: Hashable, Codable, Identifiable {
    static func == (lhs: Anime, rhs: Anime) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id: Int
    let title: String
    let synopsis: String
    let images: AnimeImages
    let genreIds: [Int] // Capturing genre IDs for each anime
    let genres: [AnimeGenre]?
    

    enum CodingKeys: String, CodingKey {
        case id = "mal_id"
        case title
        case synopsis
        case images
        case genres
    }
    
    // Custom decoder to map genres to genreIds
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.synopsis = try container.decode(String.self, forKey: .synopsis)
        self.images = try container.decode(AnimeImages.self, forKey: .images)
        
        // Decode genres and map them to genreIds
        let genres = try container.decodeIfPresent([AnimeGenre].self, forKey: .genres)
        self.genres = genres
        self.genreIds = genres?.map { $0.id } ?? [] // Map genres to genreIds
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

// MARK: - Anime Genre fetching

struct AnimeGenreResponse: Codable {
    let data: [AnimeGenre]
}

struct AnimeGenre: Codable {
    let id: Int
    let name: String
    var isFavourited: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id = "mal_id"
        case name
    }
}
