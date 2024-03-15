//
//  RecentSearchTableViewModel.swift
//  TMDB
//
//  Created by Pavlo on 26.02.2024.
//

import Foundation

final class RecentSearchTableViewModel: CellViewModel {
    let suggestion: RecentSearch
    
    var imageName: String {
        return "clock.arrow.circlepath"
    }
    
    var title: String {
        return suggestion.query
    }
    
    var subtitle: String {
        let date = DateFormatterService.getDate(date: suggestion.date)
        return date
    }
    
    init(suggestion: RecentSearch) {
        self.suggestion = suggestion
    }
}
