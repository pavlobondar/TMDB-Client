//
//  UIView+Border.swift
//  TMDB
//
//  Created by Pavlo on 15.01.2024.
//

import UIKit

extension UIView {

    func addBorder(_ color: UIColor, width: CGFloat) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
}
