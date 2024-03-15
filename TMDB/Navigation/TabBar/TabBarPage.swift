//
//  TabBarPage.swift
//  TMDB
//
//  Created by Pavlo on 15.01.2024.
//

import Foundation

enum TabBarPage: CaseIterable {
    case genres
    case search
    case favorites
    
    init?(index: Int) {
        switch index {
        case 0:
            self = .genres
        case 1:
            self = .search
        case 2:
            self = .favorites
        default:
            return nil
        }
    }
    
    var title: String {
        switch self {
        case .genres:
            return "Genres"
        case .search:
            return "Search"
        case .favorites:
            return "Favorites"
        }
    }
    
    var image: String {
        switch self {
        case .genres:
            return "theatermasks.fill"
        case .search:
            return "magnifyingglass.circle.fill"
        case .favorites:
            return "bookmark.fill"
        }
    }
    
    var orderNumber: Int {
        switch self {
        case .genres:
            return 0
        case .search:
            return 1
        case .favorites:
            return 2
        }
    }
}
