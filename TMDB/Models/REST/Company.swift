//
//  Company.swift
//  TMDB
//
//  Created by Pavlo on 28.01.2024.
//

import Foundation

struct Company: Codable {
    let id: Int
    let logoPath: String?
    let name: String
    let originCountry: String
    
    var logoURL: URL? {
        guard let logoPath = logoPath else {
            return nil
        }
        return URL(string: Constants.imageBaseURL + logoPath)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case logoPath = "logo_path"
        case name = "name"
        case originCountry = "origin_country"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        logoPath = try container.decodeIfPresent(String.self, forKey: .logoPath)
        name = try container.decode(String.self, forKey: .name)
        originCountry = try container.decode(String.self, forKey: .originCountry)
    }
}
