//
//  UIWindow+Utility.swift
//  AnimationKit
//
//  Created by Ferdinand on 31/12/21.
//

import UIKit

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 15, *) {
            return UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
