//
//  BackgroundStyle.swift
//  TMDB
//
//  Created by Pavlo on 06.03.2024.
//

import Foundation

enum BackgroundStyle {
    case none
    case noSearches
    case noFavorites
    case error
    case networkError
    
    var imageName: String? {
        switch self {
        case .none:
            return nil
        case .noSearches:
            return "externaldrive.badge.icloud"
        case .noFavorites:
            return "list.and.film"
        case .error:
            return "exclamationmark.triangle"
        case .networkError:
            return "wifi.slash"
        }
    }
    
    var message: String? {
        switch self {
        case .none:
            return nil
        case .noSearches:
            return "No Recent Searches"
        case .noFavorites:
            return "No Favorites"
        case .error:
            return "Error"
        case .networkError:
            return "No internet connection"
        }
    }
}
