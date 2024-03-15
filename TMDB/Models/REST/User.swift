//
//  User.swift
//  TMDB
//
//  Created by Pavlo on 07.03.2024.
//

import Foundation

struct Avatar: Decodable {
    let gravatar: String?
    let avatarPath: String?
    
    enum CodingKeys: String, CodingKey {
        case gravatar = "gravatar"
        case avatarPath = "tmdb"
    }
    
    enum GravatarCodingKeys: String, CodingKey {
        case hash = "hash"
    }
    
    enum AvatarPathCodingKeys: String, CodingKey {
         case avatarPath = "avatar_path"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let gravatarContainer = try container.nestedContainer(keyedBy: GravatarCodingKeys.self, forKey: .gravatar)
        gravatar = try gravatarContainer.decodeIfPresent(String.self, forKey: .hash)        
        let avatarContainer = try container.nestedContainer(keyedBy: AvatarPathCodingKeys.self, forKey: .avatarPath)
        avatarPath = try avatarContainer.decodeIfPresent(String.self, forKey: .avatarPath)
    }
}

struct User: Decodable {
    let avatar: Avatar
    let id: Int
    let languageCode: String?
    let name: String
    let includeAdult: Bool
    let username: String
    
    enum CodingKeys: String, CodingKey {
        case avatar = "avatar"
        case id = "id"
        case languageCode = "iso_639_1"
        case name = "name"
        case includeAdult = "include_adult"
        case username = "username"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        avatar = try container.decode(Avatar.self, forKey: .avatar)
        id = try container.decode(Int.self, forKey: .id)
        languageCode = try container.decodeIfPresent(String.self, forKey: .languageCode)
        name = try container.decode(String.self, forKey: .name)
        includeAdult = try container.decode(Bool.self, forKey: .includeAdult)
        username = try container.decode(String.self, forKey: .username)
    }
}
