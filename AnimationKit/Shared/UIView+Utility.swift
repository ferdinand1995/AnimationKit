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

    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1

        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
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

    func addShadow(shadowColor: UIColor, offSet: CGSize, opacity: Float, shadowRadius: CGFloat, cornerRadius: CGFloat, corners: UIRectCorner, fillColor: UIColor = .white) {

        let shadowLayer = CAShapeLayer()
        let size = CGSize(width: cornerRadius, height: cornerRadius)
        let cgPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: size).cgPath //1
        shadowLayer.path = cgPath //2
        shadowLayer.fillColor = fillColor.cgColor //3
        shadowLayer.shadowColor = shadowColor.cgColor //4
        shadowLayer.shadowPath = cgPath
        shadowLayer.shadowOffset = offSet //5
        shadowLayer.shadowOpacity = opacity
        shadowLayer.shadowRadius = shadowRadius
        self.layer.addSublayer(shadowLayer)
    }
}
