//
//  TrailerCollectionViewCell.swift
//  TMDB
//
//  Created by Pavlo on 02.02.2024.
//

import UIKit
import youtube_ios_player_helper

final class TrailerCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var playerView: YTPlayerView!
    
    @IBOutlet private weak var trailerTitleLabel: UILabel!
    
    var viewModel: CellViewModel? {
        didSet {
            guard let viewModel = viewModel as? TrailerCellViewModel else {
                return
            }
            setupCell(viewModel: viewModel)
        }
    }

    private func setupCell(viewModel: TrailerCellViewModel) {
        playerView.load(withVideoId: viewModel.videoId)
        trailerTitleLabel.text = viewModel.title
    }
}
