//
//  SessionRequest.swift
//  TMDB
//
//  Created by Pavlo on 12.02.2024.
//

import Foundation

struct SessionRequest: Encodable {
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case token = "request_token"
    }
    
    func toJSON() -> [String: Any] {
        var result: [String: Any] = [:]
        result[CodingKeys.token.rawValue] = token
        
        return result
    }
}
