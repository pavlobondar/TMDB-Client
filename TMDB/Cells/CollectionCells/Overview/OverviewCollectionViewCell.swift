//
//  OverviewCollectionViewCell.swift
//  TMDB
//
//  Created by Pavlo on 05.03.2024.
//

import UIKit

final class OverviewCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var taglineLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    
    @IBOutlet private weak var genresLabel: UILabel!
    @IBOutlet private weak var overviewLabel: UILabel!
    @IBOutlet private weak var linkLabel: UILabel!
    
    @IBOutlet private weak var ratingLabel: TagLabel!
    @IBOutlet private weak var popularityLabel: TagLabel!
    @IBOutlet private weak var adultLabel: TagLabel!

    private var actionHandler: TypeClosure<OverviewCollectionHeaderAction>?
    
    var viewModel: CellViewModel? {
        didSet {
            guard let viewModel = viewModel as? OverviewCellViewModel else {
                return
            }
            setupCell(viewModel: viewModel)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let linkTapGesture = UITapGestureRecognizer(target: self, action: #selector(linkLabelAction))
        linkLabel.addGestureRecognizer(linkTapGesture)
        linkLabel.isUserInteractionEnabled = true
    }
    
    private func setupCell(viewModel: OverviewCellViewModel) {
        self.actionHandler = viewModel.actionHandler
        
        popularityLabel.text = viewModel.poppopularity
        
        taglineLabel.text = viewModel.tagline
        taglineLabel.isHidden = viewModel.tagline == nil
        dateLabel.text = viewModel.releaseDate
        dateLabel.isHidden = viewModel.releaseDate == nil
        statusLabel.text = viewModel.status
        
        genresLabel.text = viewModel.genres
        overviewLabel.text = viewModel.overview
        
        ratingLabel.text = viewModel.rating
        adultLabel.isHidden = !viewModel.isAdult

        linkLabel.text = viewModel.site
        linkLabel.isHidden = viewModel.site.isEmpty
    }
    
    @objc
    private func linkLabelAction() {
        actionHandler?(.openLink)
    }
}
