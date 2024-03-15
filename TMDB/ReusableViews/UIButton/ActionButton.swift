//
//  ActionButton.swift
//  TMDB
//
//  Created by Pavlo on 15.01.2024.
//

import UIKit

class ActionButton: UIButton {
    
    var hideAfterTouchEnd: Bool = false
    var touchAreaPadding: UIEdgeInsets?
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let insets = touchAreaPadding else {
            return super.point(inside: point, with: event)
        }
        
        let rect = CGRect(x: bounds.minX - insets.left, y: bounds.minY - insets.top, width: bounds.width + insets.left + insets.right, height: bounds.height + insets.top + insets.bottom)
        return rect.contains(point)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: { [weak self] in
            guard let self = self else { return }
            if self.isEnabled {
                self.alpha = 0.94
            }
            self.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
        })
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: { [weak self] in
            guard let self = self else { return }
            if self.isEnabled {
                self.alpha = 1
            }
            if let point = touches.first?.location(in: self), self.point(inside: point, with: event) && self.hideAfterTouchEnd == true {
                self.alpha = 0
            } else {
                if self.isEnabled {
                    self.alpha = 1
                }
            }
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
        
        isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
            self?.isUserInteractionEnabled = true
        }
    }
    
    func animateIn() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: { [weak self] in
            guard let self = self else { return }
            self.isHidden = false
            UIView.animate(
                withDuration: 0.2,
                delay: 0,
                options: .curveEaseOut,
                animations: { [weak self] in
                    guard let self = self else { return }
                    self.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
            )
        })
    }
    
    func animateOut() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            UIView.animate(
                withDuration: 0.2,
                delay: 0,
                options: .curveEaseOut,
                animations: { [weak self] in
                    guard let self = self else { return }
                    self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                }, completion: { [weak self] _ in
                    guard let self = self else { return }
                    self.isHidden = true
                })
        })
    }
}
