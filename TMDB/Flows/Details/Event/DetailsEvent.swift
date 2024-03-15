//
//  DetailsEvent.swift
//  TMDB
//
//  Created by Pavlo on 15.01.2024.
//

import Foundation

enum DetailsEvent: FlowEvent {
    case back
    case openPage(url: String)
    case share(url: String)
    case showError(error: Error)
}
