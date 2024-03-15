//
//  DetailsBackgroundView.swift
//  TMDB
//
//  Created by Pavlo on 30.01.2024.
//

import UIKit

final class DetailsBackgroundView: UIView, BackgroundViewProtocol {
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var messageImageView: UIImageView!
    
    @IBOutlet private weak var messageLabel: UILabel!
    
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        return blurEffectView
    }()
        
    private let gradient = CAGradientLayer()
    
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
        setupGradient()
        setupBlueEffect()
    }
    
    private func setupGradient() {
        let gradientColors = [UIColor.clear, UIColor(named: "AppBacgroundColor")].compactMap { $0 }
        gradient.frame = posterImageView.bounds
        gradient.colors = gradientColors.map { $0.cgColor }
        posterImageView.layer.insertSublayer(gradient, at: 0)
    }
    
    private func setupBlueEffect() {
        blurEffectView.frame = posterImageView.bounds
        posterImageView.addSubview(blurEffectView)
    }
    
    func updateStyle(style: BackgroundStyle) {
        if let imageName = style.imageName {
            messageImageView.image = .init(systemName: imageName)
        } else {
            messageImageView.image = nil
        }
        messageLabel.text = style.message
    }
    
    func updateImages(_ images: [Data]) {
        let bgImages = images.compactMap { UIImage(data: $0) }
        posterImageView.stopAnimating()
        posterImageView.animationImages = bgImages
        posterImageView.animationDuration = 250.0
        posterImageView.startAnimating()
    }
    
    func updateAlpha(_ alpha: CGFloat) {
        blurEffectView.alpha = alpha
        posterImageView.alpha = 1 - alpha
    }
}
