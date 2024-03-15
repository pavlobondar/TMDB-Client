//
//  OverviewCollectionHeaderViewModel.swift
//  TMDB
//
//  Created by Pavlo on 06.02.2024.
//

import Foundation

final class OverviewCollectionHeaderViewModel: HeaderViewModel {
    private let movie: MovieDetails
    private let isFavorite: Bool
    
    var actionHandler: TypeClosure<OverviewCollectionHeaderAction>?
    
    var title: String {
        return movie.title
    }
    
    var site: String {
        return movie.homepage
    }
    
    var favoriteImageName: String {
        return isFavorite ? "bookmark.fill" : "bookmark"
    }
    
    init(movie: MovieDetails, isFavorite: Bool) {
        self.movie = movie
        self.isFavorite = isFavorite
    }
}
