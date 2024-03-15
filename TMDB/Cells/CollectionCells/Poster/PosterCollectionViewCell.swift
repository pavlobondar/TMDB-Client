//
//  PosterCollectionViewCell.swift
//  TMDB
//
//  Created by Pavlo on 02.02.2024.
//

import UIKit

final class PosterCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var posterImageView: UIImageView!
    
    var viewModel: CellViewModel? {
        didSet {
            guard let viewModel = viewModel as? PosterCellViewModel else {
                return
            }
            setupCell(viewModel: viewModel)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        posterImageView.setCornerRadius(8.0)
    }
    
    private func setupCell(viewModel: PosterCellViewModel) {
        posterImageView.load(url: viewModel.posterURL)
    }
}
