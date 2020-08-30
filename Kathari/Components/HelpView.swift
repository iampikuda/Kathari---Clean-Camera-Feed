//
//  HelpView.swift
//  Kathari
//
//  Created by Oluwadamisi Pikuda on 29/08/2020.
//  Copyright © 2020 Damisi Pikuda. All rights reserved.
//

import UIKit
import SnapKit

final class HelpView: UIView {

    private let helpLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.9
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "Help"
        return label
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 11
        return stackView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        setupView()
    }

    private func setupView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.8)

        let doubleTapLabel = getLabelWith(title: "Double Tap:", text: "Camera Change")
        let swipeLabel = getLabelWith(title: "Swipe up and down:", text: "Show Settings")
        let pinchLabel = getLabelWith(title: "Pinch in and out:", text: "Digital Zoom")
        let longPressLabel = getLabelWith(title: "Long Press:", text: "Change Level")
    }

    private func getLabelWith(title: String, text: String) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.font = UIFont.systemFont(ofSize: 14)

        let attText = NSMutableAttributedString().withAttributes(
            text: title,
            textColor: .white,
            font: UIFont.boldSystemFont(ofSize: 14)
        ).appendStringWithAttributes(
            text: text,
            textColor: .white,
            font: UIFont.systemFont(ofSize: 14)
        )

        label.attributedText = attText
        return label
    }
}
