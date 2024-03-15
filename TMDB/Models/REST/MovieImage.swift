//
//  MovieImage.swift
//  TMDB
//
//  Created by Pavlo on 29.01.2024.
//

import Foundation

struct MovieImage: Codable {
    let aspectRatio: Double
    let height: Int
    let width: Int
    let iso6391: String?
    let filePath: String
    let voteAverage: Double
    let voteCount: Int
    
    var imageURL: URL? {
        return URL(string: Constants.imageBaseURL + filePath)
    }
    
    enum CodingKeys: String, CodingKey {
        case aspectRatio = "aspect_ratio"
        case height = "height"
        case width = "width"
        case iso6391 = "iso_639_1"
        case filePath = "file_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        aspectRatio = try container.decode(Double.self, forKey: .aspectRatio)
        height = try container.decode(Int.self, forKey: .height)
        width = try container.decode(Int.self, forKey: .width)
        iso6391 = try container.decodeIfPresent(String.self, forKey: .iso6391)
        filePath = try container.decode(String.self, forKey: .filePath)
        voteAverage = try container.decode(Double.self, forKey: .voteAverage)
        voteCount = try container.decode(Int.self, forKey: .voteCount)
    }
}
