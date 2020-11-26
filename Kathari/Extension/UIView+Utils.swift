//
//  UIView+Utils.swift
//  Boiler
//
//  Created by Oluwadamisi Pikuda on 12/12/19.
//  Copyright © 2019 Pikuda. All rights reserved.
//

import UIKit

extension UIView {
    #if DEBUG
    func addDebugBorderIn(color: UIColor) {
        layer.borderColor = color.cgColor
        layer.borderWidth = 2.0
    }
    #endif

    func addSubviews(_ views: [UIView]) {
        for view in views {
            addSubview(view)
        }
    }
}
