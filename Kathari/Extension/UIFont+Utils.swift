//
//  UIFont+Utils.swift
//  Boiler
//
//  Created by Oluwadamisi Pikuda on 12/11/19.
//  Copyright © 2019 Pikuda. All rights reserved.
//

import UIKit

extension UIFont {
    private enum FontName: String {
        case robotoRegular = "Roboto-Regular"
        case robotoBold = "Roboto-Bold"
        case spaceRegular = "SpaceGrotesk-Regular"
        case spaceMedium = "SpaceGrotesk-Medium"
        case spaceBold = "SpaceGrotesk-Bold"
    }

    private static func getFontWith(fontName: FontName, andSize size: CGFloat) -> UIFont {
        if let requestedFont = UIFont(name: fontName.rawValue, size: size) {
            return requestedFont
        }

        assertionFailure("Missing font: \(fontName.rawValue)")
        return UIFont.systemFont(ofSize: size)
    }

    static func robotoRegular(ofSize fontSize: CGFloat) -> UIFont {
        return getFontWith(fontName: .robotoRegular, andSize: fontSize)
    }

    static func robotoBold(ofSize fontSize: CGFloat) -> UIFont {
        return getFontWith(fontName: .robotoBold, andSize: fontSize)
    }

    static func spaceRegular(ofSize fontSize: CGFloat) -> UIFont {
        return getFontWith(fontName: .spaceRegular, andSize: fontSize)
    }

    static func spaceMedium(ofSize fontSize: CGFloat) -> UIFont {
        return getFontWith(fontName: .spaceMedium, andSize: fontSize)
    }

    static func spaceBold(ofSize fontSize: CGFloat) -> UIFont {
        return getFontWith(fontName: .spaceBold, andSize: fontSize)
    }
}
