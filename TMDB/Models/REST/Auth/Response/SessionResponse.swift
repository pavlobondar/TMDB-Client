//
//  SessionResponse.swift
//  TMDB
//
//  Created by Pavlo on 12.02.2024.
//

import Foundation

struct SessionResponse: Codable {
    let success: Bool
    let sessionId: String
    
    enum CodingKeys: String, CodingKey {
        case success = "success"
        case sessionId = "session_id"
    }
}
