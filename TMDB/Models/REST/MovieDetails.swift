//
//  MovieDetails.swift
//  TMDB
//
//  Created by Pavlo on 25.01.2024.
//

import Foundation

struct MovieDetails: Decodable {
    enum ImageType {
        case logo
        case poster
        case backdrops
    }
    
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let releaseDate: Date?
    let adult: Bool
    let backdropPath: String?
    let budget: Int
    let homepage: String
    let popularity: Double
    let status: String
    let videos: MovieVideos
    let genres: [MovieGenre]
    let voteAverage: Double
    let voteCount: Double
    let productionCompanies: [Company]
    let tagline: String?
    let backdrops: [MovieImage]
    let logos: [MovieImage]
    let posters: [MovieImage]
    let originalLanguage: String
    let spokenLanguages: [SpokenLanguage]
    let credits: Credits
    let similar: PageInfo
    
    private func getOriginalImages(images: [MovieImage]) -> [MovieImage] {
        return images.filter { $0.iso6391 == originalLanguage || $0.iso6391 == nil  }
    }
    
    func getImages(type: ImageType) -> [MovieImage] {
        switch type {
        case .logo:
            return getOriginalImages(images: logos)
        case .poster:
            return getOriginalImages(images: posters)
        case .backdrops:
            return getOriginalImages(images: backdrops)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "original_title"
        case overview = "overview"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case adult = "adult"
        case backdropPath = "backdrop_path"
        case budget = "budget"
        case homepage = "homepage"
        case popularity = "popularity"
        case status = "status"
        case videos = "videos"
        case genres = "genres"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case productionCompanies = "production_companies"
        case originalLanguage = "original_language"
        case tagline = "tagline"
        case images = "images"
        case spokenLanguages = "spoken_languages"
        case credits = "credits"
        case similar = "similar"
    }
    
    enum ImagesCodingKeys: String, CodingKey {
        case backdrops = "backdrops"
        case logos = "logos"
        case posters = "posters"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        overview = try container.decode(String.self, forKey: .overview)
        posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        let releaseDateString = try container.decodeIfPresent(String.self, forKey: .releaseDate)
        releaseDate = DateFormatterService.getReleaseDateFrom(string: releaseDateString)
        adult = try container.decode(Bool.self, forKey: .adult)
        backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
        budget = try container.decode(Int.self, forKey: .budget)
        homepage = try container.decode(String.self, forKey: .homepage)
        popularity = try container.decode(Double.self, forKey: .popularity)
        status = try container.decode(String.self, forKey: .status)
        videos = try container.decode(MovieVideos.self, forKey: .videos)
        genres = try container.decode([MovieGenre].self, forKey: .genres)
        voteAverage = try container.decode(Double.self, forKey: .voteAverage)
        voteCount = try container.decode(Double.self, forKey: .voteCount)
        productionCompanies = try container.decode([Company].self, forKey: .productionCompanies)
        tagline = try container.decodeIfPresent(String.self, forKey: .tagline)
        originalLanguage = try container.decodeIfPresent(String.self, forKey: .originalLanguage) ?? ""
        
        let imageContainer = try container.nestedContainer(keyedBy: ImagesCodingKeys.self, forKey: .images)
        backdrops = try imageContainer.decodeIfPresent([MovieImage].self, forKey: .backdrops) ?? []
        logos = try imageContainer.decodeIfPresent([MovieImage].self, forKey: .logos) ?? []
        posters = try imageContainer.decodeIfPresent([MovieImage].self, forKey: .posters) ?? []
        
        spokenLanguages = try container.decode([SpokenLanguage].self, forKey: .spokenLanguages)
        credits = try container.decode(Credits.self, forKey: .credits)
        similar = try container.decode(PageInfo.self, forKey: .similar)
    }
}
