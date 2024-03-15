//
//  Genre.swift
//  TMDB
//
//  Created by Pavlo on 25.01.2024.
//

import Foundation

enum Genre: Int, CaseIterable, Codable {
    case action = 28
    case abenteuer = 12
    case animation = 16
    case komödie = 35
    case krimi = 80
    case dokumentarfilm = 99
    case drama = 18
    case familie = 10751
    case fantasy = 14
    case historie = 36
    case horror = 27
    case musik = 10402
    case mystery = 9648
    case liebesfilm = 10749
    case scienceFiction = 878
    case tvFilm = 10770
    case thriller = 53
    case kriegsfilm = 10752
    case western = 37
    
    var title: String {
        switch self {
        case .action:
            return "Action"
        case .abenteuer:
            return "Abenteuer"
        case .animation:
            return "Animation"
        case .komödie:
            return "Komödie"
        case .krimi:
            return "Krimi"
        case .dokumentarfilm:
            return "Dokumentarfilm"
        case .drama:
            return "Drama"
        case .familie:
            return "Familie"
        case .fantasy:
            return "Fantasy"
        case .historie:
            return "Historie"
        case .horror:
            return "Horror"
        case .musik:
            return "Musik"
        case .mystery:
            return "Mystery"
        case .liebesfilm:
            return "Liebesfilm"
        case .scienceFiction:
            return "Science Fictio"
        case .tvFilm:
            return "TV-Film"
        case .thriller:
            return "Thriller"
        case .kriegsfilm:
            return "Kriegsfilm"
        case .western:
            return "Western"
        }
    }
}
