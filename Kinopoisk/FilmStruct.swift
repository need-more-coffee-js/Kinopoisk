//
//  Film.swift
//  Kinopoisk
//
//  Created by Денис Ефименков on 17.01.2025.
//

import Foundation

// MARK: - Film
struct Film: Codable {
    let keyword: String?
    let pagesCount: Int?
    let films: [FilmElement]?
    let searchFilmsCountResult: Int?
}

// MARK: - FilmElement
struct FilmElement: Codable {
    let filmID: Int?
    let nameRu, nameEn, type, year: String?
    let description, filmLength: String?
    let countries: [Country]?
    let genres: [Genre]?
    let rating: String?
    let ratingVoteCount: Int?
    let posterURL, posterURLPreview: String?

    enum CodingKeys: String, CodingKey {
        case filmID = "filmId"
        case nameRu, nameEn, type, year, description, filmLength, countries, genres, rating, ratingVoteCount
        case posterURL = "posterUrl"
        case posterURLPreview = "posterUrlPreview"
    }
}

// MARK: - Country
struct Country: Codable {
    let country: String?
}

// MARK: - Genre
struct Genre: Codable {
    let genre: String?
}
