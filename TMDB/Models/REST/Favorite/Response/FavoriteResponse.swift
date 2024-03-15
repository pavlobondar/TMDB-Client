//
//  FavoriteResponse.swift
//  TMDB
//
//  Created by Pavlo on 06.03.2024.
//

import Foundation

struct FavoriteResponse: Decodable {
    let success: Bool
    let statusCode: Int
    let statusMessage: String
    
    enum CodingKeys: String, CodingKey {
        case success = "success"
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}
