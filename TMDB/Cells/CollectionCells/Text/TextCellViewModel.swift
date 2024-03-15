//
//  TextCellViewModel.swift
//  TMDB
//
//  Created by Pavlo on 08.03.2024.
//

import Foundation

final class TextCellViewModel: CellViewModel {
    private let info: TextInfo
    
    var title: String? {
        return info.title
    }
    
    var subtitle: String? {
        return info.subtitle
    }
    
    init(info: TextInfo) {
        self.info = info
    }
}
