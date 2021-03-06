//
//  NSMutableAttributedString+Utils.swift
//  Boiler
//
//  Created by Oluwadamisi Pikuda on 1/6/20.
//  Copyright © 2020 Pikuda. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
    /// Creates an attributed string with color, font, and (optional) - letter spacing
    ///
    /// - warning: The returned string is not localized.
    /// - returns: NSMutableAttributedString with color, font, and spacing
    @discardableResult
    func withAttributes(
        text: String,
        textColor: UIColor,
        font: UIFont,
        letterSpacing: CGFloat = 1.0,
        underlined: Bool = false
    ) -> NSMutableAttributedString {

        let normal = NSMutableAttributedString(string: text)

        var attributes: [NSAttributedString.Key: Any] =
            [NSAttributedString.Key.foregroundColor: textColor,
             NSAttributedString.Key.font: font,
             NSAttributedString.Key.kern: letterSpacing]

        if underlined {
            attributes[NSAttributedString.Key.underlineStyle] = NSUnderlineStyle.single.rawValue
        }

        normal.addAttributes(attributes, range: NSRange(location: 0, length: normal.length))

        return NSMutableAttributedString(string: text, attributes: attributes)
    }

    /// Appends an attributed string with attributes
    ///
    /// - warning: The returned string is not localized.
    /// - returns: NSMutableAttributedString with attended attributed string
    @discardableResult
    func appendStringWithAttributes(
        text: String,
        textColor: UIColor,
        font: UIFont,
        letterSpacing: CGFloat = 1.0,
        underlined: Bool = false
    ) -> NSMutableAttributedString {

        let attribStr = NSMutableAttributedString().withAttributes(
            text: text,
            textColor: textColor,
            font: font,
            letterSpacing: letterSpacing,
            underlined: underlined
        )

        append(attribStr)
        return self
    }
}
