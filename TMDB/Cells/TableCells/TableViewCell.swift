//
//  TableViewCell.swift
//  TMDB
//
//  Created by Pavlo on 28.01.2024.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    var viewModel: CellViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        commonInit()
    }
    
    private func commonInit() {
        textLabel?.font = .systemFont(ofSize: 17)
        detailTextLabel?.font = .systemFont(ofSize: 17)
        textLabel?.numberOfLines = 2
        detailTextLabel?.numberOfLines = 2
        detailTextLabel?.lineBreakMode = .byWordWrapping
        selectionStyle = .none
    }
}
