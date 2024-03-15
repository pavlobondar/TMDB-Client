//
//  CastCollectionViewCell.swift
//  TMDB
//
//  Created by Pavlo on 08.03.2024.
//

import UIKit

final class CastCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var castImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    var viewModel: CellViewModel? {
        didSet {
            guard let viewModel = viewModel as? CastCellViewModel else {
                return
            }
            setupCell(viewModel: viewModel)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let radius = castImageView.frame.height / 2
        castImageView.setCornerRadius(radius)
    }
    
    private func setupCell(viewModel: CastCellViewModel) {
        castImageView.load(url: viewModel.imageURL)
        titleLabel.text = viewModel.name
        subtitleLabel.text = viewModel.role
    }
}
