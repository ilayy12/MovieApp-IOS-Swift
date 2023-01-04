//
//  CastDetails.swift
//  Movies
//
//  Created by aytü on 26.07.2022.
//

import Foundation

struct CastDetails: Codable {
    let id: Int?
    let knownForDepartment: String?
    let gender: Int?
    let name: String?
    let profilePath: String?
    let character: String?
    let order: Int?
    
    private enum CodingKeys: String, CodingKey {
        case id, name, character, order, gender
        case knownForDepartment = "known_for_department"
        case profilePath = "profile_path"
    }
}

struct PersonDetails: Codable {
    let birthday: String?
    let deathday: String?
    let id: Int?
    let name: String?
    let biography: String?
    let placeOfBirth: String?
    let gender: Int?
    let profilePath: String?
    
    private enum CodingKeys: String, CodingKey {
        case birthday, deathday, id, name, biography, gender
        case placeOfBirth = "place_of_birth"
        case profilePath = "profile_path"
    }
}
