//
//  PaddingLabel.swift
//  TMDB
//
//  Created by Pavlo on 27.01.2024.
//

import UIKit

class PaddingLabel: UILabel {

    var paddingInsets: UIEdgeInsets = .init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)

    override var bounds: CGRect {
        didSet {
            preferredMaxLayoutWidth = bounds.width - (paddingInsets.left + paddingInsets.right)
        }
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: paddingInsets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + paddingInsets.left + paddingInsets.right, height: size.height + paddingInsets.top + paddingInsets.bottom)
    }
}
