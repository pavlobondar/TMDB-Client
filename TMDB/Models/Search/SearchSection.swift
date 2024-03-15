//
//  SearchSection.swift
//  TMDB
//
//  Created by Pavlo on 26.02.2024.
//

import Foundation

enum SearchSectionType {
    case recentSearches
    case movies(query: String)
}

struct SearchSection {
    var type: SearchSectionType
    var items: [CellViewModel]
}
