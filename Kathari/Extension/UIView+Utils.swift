//
//  UIView+Utils.swift
//  Boiler
//
//  Created by Oluwadamisi Pikuda on 12/12/19.
//  Copyright © 2019 Pikuda. All rights reserved.
//

import UIKit

extension UIView {
    func removeAllSubViews() {
        guard !self.subviews.isEmpty else { return }

        for view in self.subviews {
            view.removeFromSuperview()
        }
    }

    #if DEBUG
    func addDebugBorderIn(color: UIColor) {
        layer.borderColor = color.cgColor
        layer.borderWidth = 2.0
    }
    #endif

    func dropShadow(
        opacity: Float = 0.3,
        radius: CGFloat = 3.0,
        verticalOffset: CGFloat = 0.0,
        horizontalOffset: CGFloat = 3.0
    ) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowOffset = CGSize(width: horizontalOffset, height: verticalOffset)

        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }

    /// Insert view.fadeTransition right before changing content
    /// EX: label.fadeTransition(0.4); label.text = "text"
    func fadeTransition(_ duration: CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }

    /// Returns an optional view that is the current first responder
    var firstResponder: UIView? {
        guard !isFirstResponder else { return self }

        for subview in subviews {
            if let firstResponder = subview.firstResponder {
                return firstResponder
            }
        }
        return nil
    }

    func addSubviews(_ views: [UIView]) {
        for view in views {
            addSubview(view)
        }
    }

    func performUIUpdate(using closure: @escaping () -> Void) {
        // If we are already on the main thread, execute the closure directly
        if Thread.isMainThread {
            closure()
        } else {
            DispatchQueue.main.async(execute: closure)
        }
    }

    func addTopBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: borderWidth)
        addSubview(border)
    }

    func addBottomBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        border.frame = CGRect(x: 0, y: frame.size.height - borderWidth, width: frame.size.width, height: borderWidth)
        addSubview(border)
    }

    func addLeftBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.frame = CGRect(x: 0, y: 0, width: borderWidth, height: frame.size.height)
        border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
        addSubview(border)
    }

    func addRightBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
        border.frame = CGRect(x: frame.size.width - borderWidth, y: 0, width: borderWidth, height: frame.size.height)
        addSubview(border)
    }

    func addCorners(
        radius: CGFloat,
        lowerRight: Bool = false,
        lowerLeft: Bool = false,
        topRight: Bool = false,
        topLeft: Bool = false
    ) {
        layer.cornerRadius = radius
        layer.maskedCorners = []

        if lowerRight { layer.maskedCorners.insert(.layerMaxXMaxYCorner) }
        if lowerLeft { layer.maskedCorners.insert(.layerMinXMaxYCorner) }
        if topRight { layer.maskedCorners.insert(.layerMaxXMinYCorner) }
        if topLeft { layer.maskedCorners.insert(.layerMinXMinYCorner) }
    }
}
