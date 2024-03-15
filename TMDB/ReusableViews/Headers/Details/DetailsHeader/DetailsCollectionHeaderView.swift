//
//  DetailsCollectionHeaderView.swift
//  TMDB
//
//  Created by Pavlo on 06.02.2024.
//

import UIKit

final class DetailsCollectionHeaderView: UICollectionReusableView {
    @IBOutlet private weak var titleLabel: UILabel!
    
    var viewModel: HeaderViewModel? {
        didSet {
            guard let viewModel = viewModel as? DetailsCollectionHeaderViewModel else {
                return
            }
            setupHeader(viewModel: viewModel)
        }
    }
    
    private func setupHeader(viewModel: DetailsCollectionHeaderViewModel) {
        titleLabel.text = viewModel.title
    }
}
