//
//  OverviewCellViewModel.swift
//  TMDB
//
//  Created by Pavlo on 05.03.2024.
//

import Foundation

final class OverviewCellViewModel: CellViewModel {
    private let movie: MovieDetails
    
    var actionHandler: TypeClosure<OverviewCollectionHeaderAction>?
    
    var poppopularity: String {
        return String(format: "%.0f", movie.popularity)
    }
    
    var tagline: String? {
        return movie.tagline
    }
    
    var releaseDate: String? {
        guard let releaseDate = movie.releaseDate else {
            return nil
        }
        
        return DateFormatterService.getDayMonthYearFormat(releaseDate)
    }
    
    var status: String {
        return movie.status
    }
    
    var genres: String {
        let movieGenres = movie.genres.map { $0.name }.joined(separator: ", ")
        return "Genres: \(movieGenres)"
    }
    
    var overview: String {
        return movie.overview
    }
    
    var rating: String {
        return String(format: "%.1f", movie.voteAverage)
    }
    
    var isAdult: Bool {
        return movie.adult
    }
    
    var site: String {
        return movie.homepage
    }
    
    init(movie: MovieDetails) {
        self.movie = movie
    }
}
