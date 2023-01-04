//
//  MovieModel.swift
//  Movies
//
//  Created by aytü on 26.07.2022.
//

import Foundation

//MARK: - Movie Details

struct MovieDetails: Codable {
    let adult: Bool?
    let backdropPath: String?
    let budget: Int?
    let genres: [Genres?]?
    let homepage: String?
    let id: Int?
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let popularity: Double?
    let posterPath: String?
    let productionCompanies: [Companies?]?
    let releaseDate: String?
    let revenue: Int?
    let runtime: Int?
    let tagline: String?
    let title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    
    private enum CodingKeys: String, CodingKey {
        case title, genres, tagline, overview, budget, revenue, homepage, popularity, adult, id, video, runtime
        case originalTitle = "original_title"
        case originalLanguage = "original_language"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case productionCompanies = "production_companies"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case voteCount = "vote_count"
    }
}
//MARK: - Recommendations - Popular Movies - Searched Movies

struct MovieDetailsTwo: Codable {
    let posterPath: String?
    let adult: Bool?
    let overview: String?
    let releaseDate: String?
    let genreIDs: [Int]?
    let id: Int?
    let originalTitle: String? 
    let originalLanguage: String?
    let title: String?
    let backdropPath: String?
    let popularity: Double?
    let voteCount: Int?
    let video: Bool?
    let voteAverage: Double?
    
    private enum CodingKeys: String, CodingKey {
        case title, overview, popularity, adult, id, video
        case originalTitle = "original_title"
        case originalLanguage = "original_language"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case voteCount = "vote_count"
        case genreIDs = "genre_ids"
    }
}
