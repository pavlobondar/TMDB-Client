//
//  PopularMovieCellViewModel.swift
//  TMDB
//
//  Created by Pavlo on 27.01.2024.
//

import Foundation

final class PopularMovieCellViewModel: CellViewModel {
    private let movie: Movie
    
    var posterURL: URL? {
        return movie.backdropImageURL
    }
    
    var title: String {
        return movie.title
    }
    
    var vote: String {
        return String(format: "%.1f", movie.voteAverage)
    }
    
    var subtitle: String {
        return movie.overview
    }
    
    init(movie: Movie) {
        self.movie = movie
    }
}
