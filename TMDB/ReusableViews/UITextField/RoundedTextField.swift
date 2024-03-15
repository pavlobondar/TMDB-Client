//
//  RoundedTextField.swift
//  TMDB
//
//  Created by Pavlo on 13.02.2024.
//

import UIKit

final class RoundedTextField: PaddingTextField {
    
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
        setCornerRadius(frame.height / 2)
    }
    
    private func commonInit() {
        padding = .init(top: 4, left: 25, bottom: 4, right: 25)
    }
}
