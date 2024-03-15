//
//  GenreCollectionHeaderViewModel.swift
//  TMDB
//
//  Created by Pavlo on 26.01.2024.
//

import Foundation

final class GenreCollectionHeaderViewModel: HeaderViewModel {
    private let genre: Genre
    
    var actionHandler: VoidClosure?
    
    var title: String {
        return genre.title
    }
    
    init(genre: Genre) {
        self.genre = genre
    }
}
