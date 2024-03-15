//
//  TrailerCellViewModel.swift
//  TMDB
//
//  Created by Pavlo on 02.02.2024.
//

import Foundation

final class TrailerCellViewModel: CellViewModel {
    private let video: Video
    
    var videoId: String {
        return video.key
    }
    
    var title: String {
        return video.name
    }
    
    init(video: Video) {
        self.video = video
    }
}
