//
//  SpokenLanguage.swift
//  TMDB
//
//  Created by Pavlo on 07.03.2024.
//

import Foundation

struct SpokenLanguage: Decodable {
    let englishName: String
    let iso6391: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso6391 = "iso_639_1"
        case name = "name"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        englishName = try container.decode(String.self, forKey: .englishName)
        iso6391 = try container.decode(String.self, forKey: .iso6391)
        name = try container.decode(String.self, forKey: .name)
    }
}
