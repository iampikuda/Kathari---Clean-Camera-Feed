//
//  UIImage+Utils.swift
//  Boiler
//
//  Created by Oluwadamisi Pikuda on 26/01/2020.
//  Copyright © 2020 Pikuda. All rights reserved.
//

import UIKit

extension UIImage {
    convenience init?(imageName: ImageName) {
        self.init(named: imageName.rawValue)
    }
}
