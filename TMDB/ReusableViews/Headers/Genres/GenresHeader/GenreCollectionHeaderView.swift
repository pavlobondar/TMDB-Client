//
//  GenreCollectionHeaderView.swift
//  TMDB
//
//  Created by Pavlo on 26.01.2024.
//

import UIKit

final class GenreCollectionHeaderView: UICollectionReusableView {
    @IBOutlet private weak var genreButton: UIButton!
    
    private var actionHandler: VoidClosure?
    
    var viewModel: HeaderViewModel? {
        didSet {
            guard let viewModel = viewModel as? GenreCollectionHeaderViewModel else {
                return
            }
            setupHeader(viewModel: viewModel)
        }
    }
    
    private func setupHeader(viewModel: GenreCollectionHeaderViewModel) {
        self.actionHandler = viewModel.actionHandler
        genreButton.setTitle(viewModel.title, for: .normal)
    }
    
    @IBAction private func genreButtonAction(_ sender: UIButton) {
        actionHandler?()
    }
}
