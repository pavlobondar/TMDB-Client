//
//  RoundedButton.swift
//  TMDB
//
//  Created by Pavlo on 15.01.2024.
//

import UIKit

final class RoundedButton: ActionButton {
    
    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : 0.65
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setCornerRadius(frame.height / 2)
    }
}
