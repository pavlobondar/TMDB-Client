//
//  RecentSearchTableViewCell.swift
//  TMDB
//
//  Created by Pavlo on 26.02.2024.
//

import UIKit 

final class RecentSearchTableViewCell: TableViewCell {
    override var viewModel: CellViewModel? {
        didSet {
            guard let viewModel = viewModel as? RecentSearchTableViewModel else {
                return
            }
            setupCell(viewModel: viewModel)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textLabel?.numberOfLines = 0
        tintColor = .systemGray
    }
    
    private func setupCell(viewModel: RecentSearchTableViewModel) {
        imageView?.image = UIImage(systemName: viewModel.imageName)
        textLabel?.text = viewModel.title
        detailTextLabel?.text = viewModel.subtitle
    }
}
