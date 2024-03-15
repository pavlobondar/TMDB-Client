//
//  Video.swift
//  TMDB
//
//  Created by Pavlo on 25.01.2024.
//

import Foundation

struct MovieVideos: Codable {
    let videos: [Video]
    
    enum CodingKeys: String, CodingKey {
        case videos = "results"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        videos = try container.decode([Video].self, forKey: .videos)
    }
}

struct Video: Codable {
    let id: String
    let name: String
    let key: String
    let site: String
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case key = "key"
        case site = "site"
        case type = "type"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        key = try container.decode(String.self, forKey: .key)
        site = try container.decode(String.self, forKey: .site)
        type = try container.decode(String.self, forKey: .type)
    }
}
