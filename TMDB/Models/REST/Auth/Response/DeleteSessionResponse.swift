//
//  DeleteSessionResponse.swift
//  TMDB
//
//  Created by Pavlo on 13.02.2024.
//

import Foundation

struct DeleteSessionResponse: Decodable {
    let success: Bool
    
    enum CodingKeys: String, CodingKey {
        case success = "success"
    }
}
