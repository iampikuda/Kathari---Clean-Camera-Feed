//
//  Double+Utils.swift
//  Boiler
//
//  Created by Oluwadamisi Pikuda on 12/11/19.
//  Copyright © 2019 Pikuda. All rights reserved.
//

import UIKit

extension Double {
    var asInt: Int {
        return Int(self)
    }

    var asCGFloat: CGFloat {
        return CGFloat(self)
    }

    var decimalString: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self)) ?? String(self)
    }

    var stringDigits: [String] {
        return String(describing: self).compactMap { String($0) }
    }
}
