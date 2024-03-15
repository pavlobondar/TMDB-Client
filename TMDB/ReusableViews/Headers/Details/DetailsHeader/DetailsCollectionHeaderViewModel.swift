//
//  DetailsCollectionHeaderViewModel.swift
//  TMDB
//
//  Created by Pavlo on 06.02.2024.
//

import Foundation

final class DetailsCollectionHeaderViewModel: HeaderViewModel {
    private let section: DetailSectionType
    
    var actionHandler: VoidClosure?
    
    var title: String {
        return section.title
    }
    
    init(section: DetailSectionType) {
        self.section = section
    }
}
