//
//  DeleteSessionRequest.swift
//  TMDB
//
//  Created by Pavlo on 13.02.2024.
//

import Foundation

struct DeleteSessionRequest: Encodable {
    let sessionId: String
    
    enum CodingKeys: String, CodingKey {
        case sessionId = "session_id"
    }
    
    func toJSON() -> [String: Any] {
        var result: [String: Any] = [:]
        result[CodingKeys.sessionId.rawValue] = sessionId
        
        return result
    }
}
