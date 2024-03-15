//
//  UIStackView+RemoveFromParrent.swift
//  TMDB
//
//  Created by Pavlo on 27.01.2024.
//

import UIKit

extension UIStackView {
    
    func clear() {
        self.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
    }
}
