//
//  PopularMovies.swift
//  Movies
//
//  Created by aytü on 26.07.2022.
//

import Foundation

struct PopularMovies: Codable {
    let page: Int?
    let results : [MovieDetailsTwo?]?
    let totalResults: Int?
    let totalPages: Int?
    
    private enum CodingKeys: String, CodingKey {
        case page, results
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }
}

struct SearchedMovies: Codable {
    let page: Int?
    let results : [MovieDetailsTwo?]?
    let totalResults: Int?
    let totalPages: Int?
    
    private enum CodingKeys: String, CodingKey {
        case page, results
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }
}
