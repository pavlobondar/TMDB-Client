//
//  PageInfo.swift
//  TMDB
//
//  Created by Pavlo on 25.01.2024.
//

import Foundation

struct PageInfo: Decodable {
    let page: Int
    let totalPages: Int
    let totalResults: Int
    var movies: [Movie]
    
    init(movies: [Movie]) {
        self.page = 1
        self.totalPages = 1
        self.totalResults = 1
        self.movies = movies
    }
    
    enum CodingKeys: String, CodingKey {
        case page = "page"
        case totalPages = "total_pages"
        case totalResults = "total_results"
        case movies = "results"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        page = try container.decode(Int.self, forKey: .page)
        totalPages = try container.decode(Int.self, forKey: .totalPages)
        totalResults = try container.decode(Int.self, forKey: .totalResults)
        movies = try container.decode([Movie].self, forKey: .movies)
    }
}
