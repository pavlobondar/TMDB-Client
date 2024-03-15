//
//  MovieTableViewCell.swift
//  TMDB
//
//  Created by Pavlo on 28.01.2024.
//

import UIKit

final class MovieTableViewCell: TableViewCell {
    @IBOutlet private weak var contantStackView: UIStackView!
    
    @IBOutlet private weak var posterImageView: UIImageView!
    
    @IBOutlet private weak var movieTitleLabel: UILabel!
    @IBOutlet private weak var voteLabel: TagLabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var movieSubtitleLabel: UILabel!
    
    override var viewModel: CellViewModel? {
        didSet {
            guard let viewModel = viewModel as? MovieTableViewModel else {
                return
            }
            setupCell(viewModel: viewModel)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contantStackView.isLayoutMarginsRelativeArrangement = true
        contantStackView.layoutMargins = .init(top: 8, left: 4, bottom: 8, right: 4)
        
        posterImageView.setCornerRadius(8)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        [movieTitleLabel, voteLabel, dateLabel, movieSubtitleLabel].forEach { $0?.text = nil }
    }
    
    private func setupCell(viewModel: MovieTableViewModel) {
        posterImageView.load(url: viewModel.posterURL)
        movieTitleLabel.text = viewModel.title
        voteLabel.text = viewModel.vote
        dateLabel.text = viewModel.releaseDate
        movieSubtitleLabel.text = viewModel.subtitle
    }
}
