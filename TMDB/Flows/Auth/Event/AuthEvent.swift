//
//  AuthEvent.swift
//  TMDB
//
//  Created by Pavlo on 15.01.2024.
//

import Foundation

enum AuthEvent: FlowEvent {
    case login
    case showError(error: Error)
}
