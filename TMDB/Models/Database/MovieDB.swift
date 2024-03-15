//
//  MovieDB.swift
//  TMDB
//
//  Created by Pavlo on 25.01.2024.
//

import Foundation
import RealmSwift

class MovieDB: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var language: String = ""
    @Persisted var title: String = ""
    @Persisted var overview: String = ""
    @Persisted var posterPath: String? = nil
    @Persisted var releaseDate: Date? = nil
    @Persisted var adult: Bool = true
    @Persisted var backdropPath: String? = nil
    @Persisted var genreIds: List<Int> = List<Int>()
    @Persisted var popularity: Double = 0.0
    @Persisted var voteAverage: Double = 0.0
    @Persisted var voteCount: Double = 0.0
    
    convenience init(movie: Movie) {
        self.init()
        self.id = movie.id
        self.language = movie.language
        self.title = movie.title
        self.overview = movie.overview
        self.posterPath = movie.posterPath
        self.releaseDate = movie.releaseDate
        self.adult = movie.adult
        self.backdropPath = movie.backdropPath
        self.genreIds.append(objectsIn: movie.genreIds)
        self.popularity = movie.popularity
        self.voteAverage = movie.voteAverage
        self.voteCount = movie.voteCount
    }
}
