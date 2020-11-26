//
//  UIApplication+Utils.swift
//  Boiler
//
//  Created by Oluwadamisi Pikuda on 06/06/2020.
//  Copyright © 2020 Pikuda. All rights reserved.
//

import UIKit

extension UIApplication {
    class func visibleWindow() -> UIWindow? {
        guard let currentWindow = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else {
            let allWindowsReversed = Array(UIApplication.shared.windows.reversed())

            for window in allWindowsReversed where window.windowLevel == .normal {
                return window
            }

            return nil
        }

        return currentWindow
    }

    class func safeLayoutRect() -> CGRect {
        guard let window = visibleWindow() else { return CGRect() }

        return CGRect(
            x: 0.0,
            y: window.safeAreaInsets.top,
            width: window.frame.width,
            height: window.frame.height - window.safeAreaInsets.bottom - window.safeAreaInsets.top
        )
    }
}
