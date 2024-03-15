//
//  UIImageView+SDWebImage.swift
//  TMDB
//
//  Created by Pavlo on 26.01.2024.
//

import UIKit
import SDWebImage

extension UIImageView {
    
    func load(url: URL?, completion: TypeClosure<Bool>? = nil) {
        self.sd_setImage(with: url) { _, error, _, _ in
            completion?(error == nil)
        }
    }
    
    func load(url: URL?, systemPlaceholderImage: String, completion: TypeClosure<Bool>? = nil) {
        let placeholderImage = UIImage(systemName: systemPlaceholderImage)
        self.sd_setImage(with: url, placeholderImage: placeholderImage) { _, error, _, _ in
            completion?(error == nil)
        }
    }
    
    func load(url: URL?, placeholderImage: UIImage, completion: TypeClosure<Bool>? = nil) {
        self.sd_setImage(with: url, placeholderImage: placeholderImage) { _, error, _, _ in
            completion?(error == nil)
        }
    }
}
