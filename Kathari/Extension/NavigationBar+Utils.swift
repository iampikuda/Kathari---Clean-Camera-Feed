//
//  NavigationBar+Utils.swift
//  Boiler
//
//  Created by Oluwadamisi Pikuda on 12/11/19.
//  Copyright © 2019 Pikuda. All rights reserved.
//

import UIKit

extension UINavigationBar {
    func setTransparent(to flag: Bool) {
        if flag == true {
            setBackgroundImage(UIImage(), for: .default)
            shadowImage = UIImage()
            backgroundColor = .clear
            isTranslucent = true
        } else {
            setBackgroundImage(nil, for: .default)
            shadowImage = UIImage()
            isTranslucent = false
        }
    }
}
