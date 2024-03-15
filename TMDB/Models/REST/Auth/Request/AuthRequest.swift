//
//  AuthRequest.swift
//  TMDB
//
//  Created by Pavlo on 12.02.2024.
//

import Foundation

struct AuthRequest: Encodable {
    let username: String
    let password: String
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case username = "username"
        case password = "password"
        case token = "request_token"
    }
    
    func toJSON() -> [String: Any] {
        var result: [String: Any] = [:]
        result[CodingKeys.username.rawValue] = username
        result[CodingKeys.password.rawValue] = password
        result[CodingKeys.token.rawValue] = token
        
        return result
    }
}
