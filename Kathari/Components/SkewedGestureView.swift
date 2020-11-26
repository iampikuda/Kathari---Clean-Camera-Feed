//
//  SkewedGestureView.swift
//  Kathari
//
//  Created by Oluwadamisi Pikuda on 26/11/2020.
//  Copyright © 2020 Damisi Pikuda. All rights reserved.
//

import UIKit
import SnapKit

final class SkewedGestureView: UIStackView {
    let camera = GestureView(imageName: .swipeRight, title: "Swipe Right", subTitle: "Cycle Cameras")

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        axis = .vertical
        alignment = .fill
        distribution = .fill
        spacing = 0

        addArrangedSubviews([UIView(), camera])
        camera.snp.makeConstraints { (make) in
            make.height.equalTo(self).multipliedBy(0.87)
        }
    }
}
