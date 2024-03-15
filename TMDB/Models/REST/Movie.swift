//
//  Movie.swift
//  TMDB
//
//  Created by Pavlo on 25.01.2024.
//

import Foundation

struct Movie: Decodable {
    let id: Int
    let language: String
    let title: String
    let overview: String
    let posterPath: String?
    let releaseDate: Date?
    let adult: Bool
    let backdropPath: String?
    let genreIds: [Int]
    let popularity: Double
    let voteAverage: Double
    let voteCount: Double
    
    var geners: [MovieGenre] {
        let geners = Genre.allCases.filter({ genreIds.contains($0.rawValue) })
        return geners.compactMap { .init(id: $0.rawValue, name: $0.title) }
    }
    
    var posterURL: URL? {
        guard let posterPath = posterPath else {
            return nil
        }
        
        return URL(string: Constants.imageBaseURL + posterPath)
    }
    
    var backdropImageURL: URL? {
        guard let backdropPath = backdropPath else {
            return nil
        }
        
        return URL(string: Constants.imageBaseURL + backdropPath)
    }
    
    init(movieDB: MovieDB) {
        self.id = movieDB.id
        self.language = movieDB.language
        self.title = movieDB.title
        self.overview = movieDB.overview
        self.posterPath = movieDB.posterPath
        self.releaseDate = movieDB.releaseDate
        self.adult = movieDB.adult
        self.backdropPath = movieDB.backdropPath
        self.genreIds = movieDB.genreIds.map { $0 }
        self.popularity = movieDB.popularity
        self.voteAverage = movieDB.voteAverage
        self.voteCount = movieDB.voteCount
    }
    
    init(movieDetails: MovieDetails) {
        self.id = movieDetails.id
        self.language = movieDetails.originalLanguage
        self.title = movieDetails.title
        self.overview = movieDetails.overview
        self.posterPath = movieDetails.posterPath
        self.releaseDate = movieDetails.releaseDate
        self.adult = movieDetails.adult
        self.backdropPath = movieDetails.backdropPath
        self.genreIds = movieDetails.genres.map { $0.id }
        self.popularity = movieDetails.popularity
        self.voteAverage = movieDetails.voteAverage
        self.voteCount = movieDetails.voteCount
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case language = "original_language"
        case title = "original_title"
        case overview = "overview"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case adult = "adult"
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case popularity = "popularity"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        language = try container.decode(String.self, forKey: .language)
        title = try container.decode(String.self, forKey: .title)
        overview = try container.decode(String.self, forKey: .overview)
        posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        let releaseDateString = try container.decodeIfPresent(String.self, forKey: .releaseDate)
        releaseDate = DateFormatterService.getReleaseDateFrom(string: releaseDateString)
        adult = try container.decode(Bool.self, forKey: .adult)
        backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
        genreIds = try container.decode([Int].self, forKey: .genreIds)
        popularity = try container.decode(Double.self, forKey: .popularity)
        voteAverage = try container.decode(Double.self, forKey: .voteAverage)
        voteCount = try container.decode(Double.self, forKey: .voteCount)
    }
}
