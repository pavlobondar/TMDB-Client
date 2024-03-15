//
//  CompanyCollectionViewCell.swift
//  TMDB
//
//  Created by Pavlo on 01.02.2024.
//

import UIKit

final class CompanyCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var stackView: UIStackView!
    
    @IBOutlet private weak var logoImageView: UIImageView!
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    var viewModel: CellViewModel? {
        didSet {
            guard let viewModel = viewModel as? CompanyCellViewModel else {
                return
            }
            setupCell(viewModel: viewModel)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let imageHeight = logoImageView.frame.height
        logoImageView.setCornerRadius(imageHeight / 2)
        
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 3, left: 6, bottom: 3, right: 6)
        
        addBorder(.systemGray, width: 1.0)
        setCornerRadius(8)
    }
    
    private func setupCell(viewModel: CompanyCellViewModel) {
        logoImageView.load(url: viewModel.companyLogoURL)
        logoImageView.isHidden = viewModel.companyLogoURL == nil
        titleLabel.text = viewModel.title
    }
}
