//
//  UIStackView+Utils.swift
//  Boiler
//
//  Created by Oluwadamisi Pikuda on 12/12/19.
//  Copyright © 2019 Pikuda. All rights reserved.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        for view in views {
            addArrangedSubview(view)
        }
    }
}
