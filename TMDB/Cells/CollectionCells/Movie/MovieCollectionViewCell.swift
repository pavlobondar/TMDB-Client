//
//  MovieCollectionViewCell.swift
//  TMDB
//
//  Created by Pavlo on 26.01.2024.
//

import UIKit

final class MovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var posterImageView: UIImageView!
    
    @IBOutlet private weak var movieTitleLabel: UILabel!
    @IBOutlet private weak var movieSubtitleLabel: UILabel!
    
    var viewModel: CellViewModel? {
        didSet {
            guard let viewModel = viewModel as? MovieCellViewModel else {
                return
            }
            setupCell(viewModel: viewModel)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        posterImageView.setCornerRadius(10)
    }

    private func setupCell(viewModel: MovieCellViewModel) {
        posterImageView.load(url: viewModel.posterURL)
        movieTitleLabel.text = viewModel.title
        movieSubtitleLabel.text = viewModel.subtitle
    }
}
