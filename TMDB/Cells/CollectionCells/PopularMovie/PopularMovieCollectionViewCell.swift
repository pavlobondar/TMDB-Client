//
//  PopularMovieCollectionViewCell.swift
//  TMDB
//
//  Created by Pavlo on 27.01.2024.
//

import UIKit

final class PopularMovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var posterImageView: UIImageView!
    
    @IBOutlet private weak var infoStackView: UIStackView!
    
    @IBOutlet private weak var movieTitleLabel: UILabel!
    @IBOutlet private weak var voteLabel: TagLabel!
    @IBOutlet private weak var movieSubtitleLabel: UILabel!
    
    var viewModel: CellViewModel? {
        didSet {
            guard let viewModel = viewModel as? PopularMovieCellViewModel else {
                return
            }
            updateCell(viewModel: viewModel)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        infoStackView.isLayoutMarginsRelativeArrangement = true
        infoStackView.layoutMargins = .init(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
    }

    private func updateCell(viewModel: PopularMovieCellViewModel) {
        posterImageView.load(url: viewModel.posterURL)
        movieTitleLabel.text = viewModel.title
        voteLabel.text = viewModel.vote
        movieSubtitleLabel.text = viewModel.subtitle
    }
}
