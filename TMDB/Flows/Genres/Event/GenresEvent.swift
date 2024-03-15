//
//  GenresEvent.swift
//  TMDB
//
//  Created by Pavlo on 15.01.2024.
//

import Foundation

enum GenresEvent: FlowEvent {
    case showList(movieList: MovieSection)
    case showDetails(id: Int)
    case showLogoutWarning(acceptHandler: VoidClosure)
    case showError(error: Error)
    case finish
}
