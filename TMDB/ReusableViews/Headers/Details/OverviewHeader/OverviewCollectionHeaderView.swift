//
//  OverviewCollectionHeaderView.swift
//  TMDB
//
//  Created by Pavlo on 06.02.2024.
//

import UIKit

enum OverviewCollectionHeaderAction {
    case updateFavoriteStatus
    case share
    case openLink
}

final class OverviewCollectionHeaderView: UICollectionReusableView {
    @IBOutlet private weak var titleLabel: UILabel!
    
    @IBOutlet private weak var updateFavoriteStatusButton: RoundedButton!
    @IBOutlet private weak var shareButton: RoundedButton!
    
    private var actionHandler: TypeClosure<OverviewCollectionHeaderAction>?
    
    var viewModel: HeaderViewModel? {
        didSet {
            guard let viewModel = viewModel as? OverviewCollectionHeaderViewModel else {
                return
            }
            setupHeader(viewModel: viewModel)
        }
    }
    
    private func setupHeader(viewModel: OverviewCollectionHeaderViewModel) {
        self.actionHandler = viewModel.actionHandler
                
        titleLabel.text = viewModel.title
        
        updateFavoriteStatusButton.setImage(.init(systemName: viewModel.favoriteImageName), for: .normal)
        shareButton.isHidden = viewModel.site.isEmpty
    }
    
    @IBAction private func updateFavoriteStatusButtonAction(_ sender: RoundedButton) {
        actionHandler?(.updateFavoriteStatus)
    }
    
    @IBAction private func shareButtonAction(_ sender: RoundedButton) {
        actionHandler?(.share)
    }
}
