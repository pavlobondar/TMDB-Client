//
//  MovieSection.swift
//  TMDB
//
//  Created by Pavlo on 25.01.2024.
//

import Foundation

enum MovieSectionType: Int {
    case popular = 0
    case regular = 1
}

struct MovieSection {
    let type: MovieSectionType
    let genre: Genre?
    var page: PageInfo
}
