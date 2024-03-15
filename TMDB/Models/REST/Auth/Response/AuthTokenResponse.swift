//
//  AuthTokenResponse.swift
//  TMDB
//
//  Created by Pavlo on 12.02.2024.
//

import Foundation

struct AuthTokenResponse: Codable {
    let success: Bool
    let expiresAt: String
    let requestToken: String
    
    enum CodingKeys: String, CodingKey {
        case success = "success"
        case expiresAt = "expires_at"
        case requestToken = "request_token"
    }
}
