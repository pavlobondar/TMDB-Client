//
//  DetailSection.swift
//  TMDB
//
//  Created by Pavlo on 01.02.2024.
//

import Foundation

enum DetailSectionType: Int {
    case overview
    case trailers
    case companies
    case posters
    case cast
    case languages
    case crew
    case similar
    
    var title: String {
        switch self {
        case .overview:
            return "Overview"
        case .posters:
            return "Posters"
        case .companies:
            return "Companies"
        case .trailers:
            return "Trailers"
        case .cast:
            return "Cast"
        case .languages:
            return "Languages"
        case .crew:
            return "Crew"
        case .similar:
            return "Similar"
        }
    }
}

struct DetailSection {
    let type: DetailSectionType
    let items: [CellViewModel]
}
