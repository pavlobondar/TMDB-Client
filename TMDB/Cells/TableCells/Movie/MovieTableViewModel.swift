//
//  MovieTableViewModel.swift
//  TMDB
//
//  Created by Pavlo on 28.01.2024.
//

import Foundation

final class MovieTableViewModel: CellViewModel {
    let movie: Movie
    
    var posterURL: URL? {
        guard let backdropImageURL = movie.backdropImageURL else {
            return movie.posterURL
        }
        return backdropImageURL
    }
    
    var title: String {
        return movie.title
    }
    
    var subtitle: String {
        return movie.overview
    }
    
    var vote: String {
        return String(format: "%.1f", movie.voteAverage)
    }
    
    var releaseDate: String? {
        guard let date = movie.releaseDate else {
            return nil
        }
        return DateFormatterService.getDayMonthYearFormat(date)
    }
    
    init(movie: Movie) {
        self.movie = movie
    }
}
