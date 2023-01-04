//
//  Companies.swift
//  Movies
//
//  Created by aytü on 26.07.2022.
//

import Foundation

struct Companies: Codable {
    let name: String?
    let id: Int?
    let logoPath: String?
    let originCountry: String?
    
    private enum CodingKeys: String, CodingKey{
        case name, id
        case logoPath = "logo_path"
        case originCountry = "origin_country"
    }
}
