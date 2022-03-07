//
//  BottomSheet.swift
//  AnimationKit
//
//  Created by Ferdinand on 26/01/22.
//

import UIKit

protocol BottomSheet {
    var containerView: UIView { get }
    var sheetView: UIView { get set }
    func show(animated: Bool, completion: (() -> Void)?)
    func dismiss(animated: Bool, completion: (() -> Void)?)
}
extension BottomSheet where Self: UIView {

    func show(animated: Bool, completion: (() -> Void)?) {
        self.containerView.alpha = 0

        sheetView.transform = CGAffineTransform(translationX: 0, y: 500)
        UIApplication.shared.keyWindowPresentedController?.view.addSubview(self)
        if animated {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, animations: { [weak self] in
                guard let ws = self else { return }
                ws.containerView.alpha = 0.6
                ws.sheetView.transform = CGAffineTransform.identity
            }) { _ in
                completion?()
            }
        } else {
            self.containerView.alpha = 0.6
        }
    }


    func dismiss(animated: Bool, completion: (() -> Void)?) {
        if animated {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, animations: { [weak self] in
                guard let ws = self else { return }
                ws.sheetView.transform = CGAffineTransform(translationX: 0, y: 500)
            }) { [weak self] _ in
                guard let ws = self else { return }
                UIView.animate(withDuration: 0.3) {
                    ws.containerView.alpha = 0
                } completion: { _ in
                    ws.removeFromSuperview()
                    completion?()
                }
            }
        } else {
            self.removeFromSuperview()
        }
    }
}
