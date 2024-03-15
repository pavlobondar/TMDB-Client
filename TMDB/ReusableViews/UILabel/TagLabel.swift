//
//  TagLabel.swift
//  TMDB
//
//  Created by Pavlo on 27.01.2024.
//

import UIKit

final class TagLabel: PaddingLabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadius(radius: 4)
    }
    
    func updateCornerRadius(radius: CGFloat) {
        setCornerRadius(radius)
    }
    
    private func commonInit() {
        paddingInsets = .init(top: 4, left: 8, bottom: 4, right: 8)
    }
}
