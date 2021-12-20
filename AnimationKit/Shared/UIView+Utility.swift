//
//  UIView+Utility.swift
//  AnimationKit
//
//  Created by Ferdinand on 20/12/21.
//

import UIKit

extension UIView {

    func showAnimation(_ completionBlock: @escaping () -> Void) {
        isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.1,
            delay: 0,
            options: .curveLinear,
            animations: { [weak self] in
                self?.transform = CGAffineTransform.init(scaleX: 0.9, y: 0.9)
            }) { (done) in
            UIView.animate(withDuration: 0.1,
                delay: 0,
                options: .curveLinear,
                animations: { [weak self] in
                    self?.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                }) { [weak self] (_) in
                self?.isUserInteractionEnabled = true
                completionBlock()
            }
        }
    }

    func dropShadowCell() {
        layer.cornerRadius = 8
        layer.masksToBounds = true

        let bezierPath = UIBezierPath.init(roundedRect: bounds, cornerRadius: 8)
        layer.shadowPath = bezierPath.cgPath
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 3
        layer.shadowOffset = CGSize.init(width: 0, height: 3)
        layer.shadowOpacity = 0.3

        layer.backgroundColor = backgroundColor?.cgColor
    }
}
