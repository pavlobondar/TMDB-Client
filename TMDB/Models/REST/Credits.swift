//
//  Credits.swift
//  TMDB
//
//  Created by Pavlo on 07.03.2024.
//

import Foundation

enum Gender: Int, Decodable {
    case none = 0
    case female = 1
    case male = 2
    
    var title: String {
        switch self {
        case .none:
            return "Not specified"
        case .female:
            return "Female"
        case .male:
            return "Male"
        }
    }
}

struct Credits: Decodable {
    let cast: [Cast]
    let crew: [Cast]
    
    enum CodingKeys: String, CodingKey {
        case cast = "cast"
        case crew = "crew"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        cast = try container.decode([Cast].self, forKey: .cast)
        crew = try container.decode([Cast].self, forKey: .crew)
    }
}
