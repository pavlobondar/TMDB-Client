//
//  PosterCellViewModel.swift
//  TMDB
//
//  Created by Pavlo on 02.02.2024.
//

import Foundation

final class PosterCellViewModel: CellViewModel {
    private let movieImage: MovieImage
    
    var posterURL: URL? {
        return movieImage.imageURL
    }
    
    init(movieImage: MovieImage) {
        self.movieImage = movieImage
    }
}
