//
//  MovieCellViewModel.swift
//  TMDB
//
//  Created by Pavlo on 26.01.2024.
//

import Foundation

final class MovieCellViewModel: CellViewModel {
    private let movie: Movie

    var posterURL: URL? {
        return movie.posterURL
    }
    
    var title: String {
        return movie.title
    }
    
    var subtitle: String {
        return movie.geners.map { $0.name }.joined(separator: ", ")
    }
    
    init(movie: Movie) {
        self.movie = movie
    }
}
