//
//  DashedView.swift
//  Kathari
//
//  Created by Oluwadamisi Pikuda on 03/09/2020.
//  Copyright © 2020 Damisi Pikuda. All rights reserved.
//

import UIKit

class DashedView: UIView {
    var dashedLayer: CAShapeLayer?

    override var bounds: CGRect {
        didSet {
            guard oldValue != bounds else { return }
            if dashedLayer != nil {
                dashedLayer?.removeFromSuperlayer()
            }

            let dashBorder = CAShapeLayer()
            dashBorder.strokeColor = UIColor.white.cgColor
            dashBorder.lineDashPattern = [11, 7]
            dashBorder.frame = bounds
            dashBorder.lineWidth = 0.5
            dashBorder.fillColor = nil
            dashBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
            dashedLayer = dashBorder
            layer.addSublayer(dashBorder)
        }
    }
}
