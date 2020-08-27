//
//  CGFloat+Utils.swift
//  Boiler
//
//  Created by Oluwadamisi Pikuda on 12/11/19.
//  Copyright © 2019 Pikuda. All rights reserved.
//

import UIKit

extension CGFloat {
    var asInt: Int {
        return Int(self)
    }

    var asDouble: Double {
        return Double(self)
    }

    static func random() -> CGFloat {
        return CGFloat(Float.random(in: 0..<1))
    }

    func toRadians() -> CGFloat {
        return self * .pi / 180
    }
}
