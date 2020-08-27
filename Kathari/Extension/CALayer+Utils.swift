//
//  CALayer+Utils.swift
//  Boiler
//
//  Created by Oluwadamisi Pikuda on 26/02/2020.
//  Copyright © 2020 Pikuda. All rights reserved.
//

import UIKit

extension CALayer {
    func applyShadow(_ shadowInfo: ShadowInfo) {
        masksToBounds = false
        shadowColor = shadowInfo.color.cgColor
        shadowOpacity = shadowInfo.alpha
        shadowOffset = CGSize(width: shadowInfo.x, height: shadowInfo.y)
        shadowRadius = shadowInfo.blur / 2.0

        if shadowInfo.spread == 0 {
            shadowPath = nil
        } else {
            let dx = -shadowInfo.spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }

        shouldRasterize = true
        rasterizationScale = UIScreen.main.scale
    }
}

struct ShadowInfo: Equatable {
    static var defaultDropShadow: ShadowInfo {
        return ShadowInfo(
            color: .black,
            alpha: 1.0,
            x: 0,
            y: 1.7,
            blur: 32,
            spread: 8
        )
    }

    /// Shadow color
    let color: UIColor
    /// Shadow opacity
    let alpha: Float
    /// Horizontal offset
    let x: CGFloat
    /// Vertical offset
    let y: CGFloat
    /// Shadow blue
    let blur: CGFloat
    /// Padding on X & Y
    let spread: CGFloat
}

class ShadowView: UIView {
    public var shadowInfo: ShadowInfo = ShadowInfo.defaultDropShadow {
        didSet {
            DispatchQueue.main.async {
                guard oldValue != self.shadowInfo else { return }
                self.layer.applyShadow(self.shadowInfo)
            }
        }
    }

    override var bounds: CGRect {
        didSet {
            guard oldValue != bounds else { return }
            self.layer.applyShadow(self.shadowInfo)
        }
    }
}
