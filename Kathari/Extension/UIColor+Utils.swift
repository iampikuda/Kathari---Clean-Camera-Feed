//
//  UIColor+Utils.swift
//  Boiler
//
//  Created by Oluwadamisi Pikuda on 12/12/19.
//  Copyright © 2019 Pikuda. All rights reserved.
//

import UIKit

extension UIColor {
    static var blackWhite: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (trait) -> UIColor in
                return trait.userInterfaceStyle == .dark ? .white : .black
            }
        } else {
            return .black
        }
    }

    static var whiteBlack: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (trait) -> UIColor in
                return trait.userInterfaceStyle == .dark ? .black : .white
            }
        } else {
            return .white
        }
    }

    static var primary: UIColor { return UIColor(hex: 0x2D2827) }
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
