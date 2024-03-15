//
//  TextCollectionViewCell.swift
//  TMDB
//
//  Created by Pavlo on 08.03.2024.
//

import UIKit

final class TextCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    var viewModel: CellViewModel? {
        didSet {
            guard let viewModel = viewModel as? TextCellViewModel else {
                return
            }
            setupCell(viewModel: viewModel)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        [titleLabel, subtitleLabel].forEach { $0?.text = nil }
    }
    
    private func setupCell(viewModel: TextCellViewModel) {
        titleLabel.text = viewModel.title
        titleLabel.isHidden = viewModel.title == nil
        subtitleLabel.text = viewModel.subtitle
        subtitleLabel.isHidden = viewModel.subtitle == nil
    }
}
