//
//  StorageError.swift
//  TMDB
//
//  Created by Pavlo on 25.01.2024.
//

import Foundation

enum StorageError: Error {
    case noObject
    
    var errorDescription: String {
        switch self {
        case .noObject:
            return NSLocalizedString("No object found in the storage.", comment: "Storage error")
        }
    }
}

