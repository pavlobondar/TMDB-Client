//
//  CastCellViewModel.swift
//  TMDB
//
//  Created by Pavlo on 08.03.2024.
//

import Foundation

final class CastCellViewModel: CellViewModel {
    private let cast: Cast
    
    var imageURL: URL? {
        return cast.imageURL
    }
    
    var name: String {
        return cast.name
    }
    
    var role: String? {
        if let character = cast.character {
            return character
        } else {
            return cast.job
        }
    }
    
    init(cast: Cast) {
        self.cast = cast
    }
}
