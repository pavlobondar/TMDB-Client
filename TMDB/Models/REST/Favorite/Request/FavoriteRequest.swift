//
//  FavoriteRequest.swift
//  TMDB
//
//  Created by Pavlo on 06.03.2024.
//

import Foundation

enum MediaType: String {
    case movie = "movie"
    case tvShow = "tv"
}

struct FavoriteRequest {
    let mediaType: MediaType
    let mediaId: Int
    let favorite: Bool
    
    enum CodingKeys: String, CodingKey {
        case mediaType = "media_type"
        case mediaId = "media_id"
        case favorite = "favorite"
    }
    
    func toJSON() -> [String: Any] {
        var result: [String: Any] = [:]
        result[CodingKeys.mediaType.rawValue] = mediaType.rawValue
        result[CodingKeys.mediaId.rawValue] = mediaId
        result[CodingKeys.favorite.rawValue] = favorite
        
        return result
    }
}
