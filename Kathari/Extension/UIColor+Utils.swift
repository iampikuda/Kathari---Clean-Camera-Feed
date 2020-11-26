//
//  UIColor+Utils.swift
//  Boiler
//
//  Created by Oluwadamisi Pikuda on 12/12/19.
//  Copyright © 2019 Pikuda. All rights reserved.
//

import UIKit

extension UIColor {
    static var gold: UIColor { return UIColor(hex: 0xffd700) }
}

extension UIColor {
    convenience init(hex: UInt32) {
        var (a, r, g, b) = (hex >> 24 & 0xFF, hex >> 16 & 0xFF, hex >> 8 & 0xFF, hex & 0xFF)
        if a == 0 {
            a = 0xFF
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
