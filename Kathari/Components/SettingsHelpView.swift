//
//  SettingsHelpView.swift
//  Kathari
//
//  Created by Oluwadamisi Pikuda on 26/11/2020.
//  Copyright © 2020 Damisi Pikuda. All rights reserved.
//

import UIKit
import SnapKit

final class SettingsHelpView: UIStackView {
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 11
        return stackView
    }()

    private let header = HeaderView()
    private let tap = GestureView(imageName: .tap, title: "Tap", subTitle: "Toggle On & Off")
    private let longPress = GestureView(imageName: .longPress, title: "Long Press", subTitle: "Change Level")

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
        spacing = 1

        addArrangedSubviews([header, stackView])
        stackView.addArrangedSubviews([tap, longPress])

        stackView.snp.makeConstraints { (make) in
            make.height.equalTo(self).multipliedBy(0.87)
        }
    }
}
