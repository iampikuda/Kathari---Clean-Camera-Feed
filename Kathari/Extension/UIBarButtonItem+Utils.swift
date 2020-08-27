//
//  UIBarButtonItem+Utils.swift
//  Boiler
//
//  Created by Oluwadamisi Pikuda on 12/11/19.
//  Copyright © 2019 Pikuda. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    static func makeButton(
        _ target: Any?,
        action: Selector,
        imageName: ImageName,
        imageColor: UIColor = UIColor.black,
        width: CGFloat = 44,
        height: CGFloat = 44
    ) -> UIBarButtonItem {

        let button = UIButton(type: .custom)
        button.setImage(UIImage(imageName: imageName)?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .right
        button.addTarget(target, action: action, for: .touchUpInside)
        button.tintColor = imageColor

        let barButton = UIBarButtonItem.init(customView: button)
        barButton.customView?.widthAnchor.constraint(equalToConstant: width).isActive = true
        barButton.customView?.heightAnchor.constraint(equalToConstant: height).isActive = true

        return barButton
    }

    static func makeButtonWithTitle(
        _ target: Any?,
        action: Selector,
        title: String = "",
        imageName: ImageName,
        imageColor: UIColor = UIColor.black,
        width: CGFloat = 44,
        height: CGFloat = 24
    ) -> UIBarButtonItem {

        let button = UIButton(type: .custom)
        button.setImage(UIImage(imageName: imageName)?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .left
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -(height / 2), bottom: 0, right: 0)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -height, bottom: 0, right: 0)
        button.addTarget(target, action: action, for: .touchUpInside)
        button.tintColor = imageColor

        let barButton = UIBarButtonItem.init(customView: button)
        barButton.customView?.widthAnchor.constraint(equalToConstant: width).isActive = true
        barButton.customView?.heightAnchor.constraint(equalToConstant: height).isActive = true

        return barButton
    }
}
