//
//  SearchEvent.swift
//  TMDB
//
//  Created by Pavlo on 15.01.2024.
//

import Foundation

enum SearchEvent: FlowEvent {
    case showDetails(id: Int)
    case showError(error: Error)
}
