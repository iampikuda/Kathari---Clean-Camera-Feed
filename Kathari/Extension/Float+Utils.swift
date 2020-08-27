//
//  Float+Utils.swift
//  Kathari
//
//  Created by Oluwadamisi Pikuda on 26/08/2020.
//  Copyright © 2020 Damisi Pikuda. All rights reserved.
//

import Foundation

extension Float {
    func roundTo(_ decimalPlaces: Int) -> Float {
        let multiplier = pow(10.0, Float(decimalPlaces))
        let temp = self
        return Darwin.round(temp * multiplier) / multiplier
    }
}
