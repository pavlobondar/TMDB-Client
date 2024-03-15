//
//  UIView+LoadXib.swift
//  TMDB
//
//  Created by Pavlo on 15.01.2024.
//

import UIKit

protocol NibLoadable {
    func setupFromNib()
}

extension NibLoadable where Self: UIView {
    
    func setupFromNib() {
        let bundle: Bundle = Bundle(for: Self.self)
        let nib: UINib = UINib(nibName: String(describing: Self.self), bundle: bundle)
        guard let contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            fatalError("Error loading \(self) from nib")
        }
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}

extension UIView: NibLoadable { }
