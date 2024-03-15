//
//  BackgroundView.swift
//  TMDB
//
//  Created by Pavlo on 16.02.2024.
//

import UIKit

final class BackgroundView: UIView, BackgroundViewProtocol {
    @IBOutlet private weak var messageImageView: UIImageView!
    @IBOutlet private weak var messageLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        setupFromNib()
    }
    
    func updateStyle(style: BackgroundStyle) {
        if let imageName = style.imageName {
            messageImageView.image = .init(systemName: imageName)
        } else {
            messageImageView.image = nil
        }
        messageLabel.text = style.message
    }
}
