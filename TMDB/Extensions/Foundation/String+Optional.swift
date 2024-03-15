//
//  String+Optional.swift
//  TMDB
//
//  Created by Pavlo on 08.03.2024.
//

import Foundation


extension Optional where Wrapped == String {
    
    var isNilOrEmpty: Bool {
        switch self {
        case .none:
            return true
        case .some(let value):
            return value.isEmpty
        }
    }
}
