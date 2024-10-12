//
//  NetworkError.swift
//  Anivise
//
//  Created by Quang Minh Nguyen on 9/10/2024.
//

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError(Error)
    case apiError(String)
    case unknown
}
