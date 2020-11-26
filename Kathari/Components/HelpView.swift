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
    weak var delegate: WindowViewDelegate?

    private let mainLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.9
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.text = "Guide"
        return label
    }()

    private let airplaneLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "We recommend turning on AirPlane Mode"
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()

    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        return stackView
    }()

    private let topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 11
        return stackView
    }()

    private let bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 11
        return stackView
    }()

    private let closeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(imageName: .close)?.withRenderingMode(.alwaysTemplate)
        imageView.clipsToBounds = true
        imageView.tintColor = .white
        return imageView
    }()

    let contentView = UIView()
    let backgroundView = UIView()

    let double = GestureView(imageName: .doubleTap, title: "Double Tap", subTitle: "Flip Camera")
    let pinch = GestureView(imageName: .pinch, title: "Pinch In & Out", subTitle: "Digital Zoom")
    let settings = DoubleGestureView(
        imageName: .swipeUp,
        imageName2: .swipeDown,
        title: "Swipe Up & Down",
        subTitle: "Show Settings"
    )

    let skewed = SkewedGestureView()
    let settingsHelpView = SettingsHelpView()

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

    func transformOrientation(interfaceOrientation: UIInterfaceOrientation) {
        guard contentAdded else { return }
        switch interfaceOrientation {
        case .landscapeRight, .landscapeLeft:
            contentView.snp.remakeConstraints { (make) in
                make.centerX.equalTo(self)
                make.centerY.equalTo(self)
                make.width.lessThanOrEqualTo(self)
                make.height.equalTo(self).multipliedBy(0.99)
            }
        default:
            contentView.snp.remakeConstraints { (make) in
                make.centerX.centerY.equalTo(self)
                make.width.equalTo(self).multipliedBy(0.94)
                make.height.lessThanOrEqualTo(self)
            }
        }
    }

    private func setupView() {
        self.backgroundColor = .red
        contentView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        contentView.layer.cornerRadius = 10

        addSubviews([backgroundView, contentView])
        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }

        setupContentView()
        setupCloseImage()
    }

    private var contentAdded = false

    private func setupContentView() {
        contentAdded = true
        contentView.backgroundColor = UIColor.black.withAlphaComponent(0.8)

        contentView.addSubviews([
            mainLabel,
            closeImageView,
            airplaneLabel,
            topStackView,
            bottomStackView
        ])

        setupLabels()
        setupImageViews()
        setupStackViews()
    }

    private func setupLabels() {
        mainLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.width.equalTo(contentView).multipliedBy(0.3)
            make.top.equalTo(contentView).offset(8)
            make.height.equalTo(contentView).multipliedBy(0.08)
        }

        airplaneLabel.snp.makeConstraints { (make) in
            make.top.equalTo(mainLabel.snp.bottom).offset(5)
            make.centerX.equalTo(contentView)
            make.width.lessThanOrEqualTo(topStackView)
            make.height.equalTo(18)
        }
    }

    private func setupImageViews() {
        closeImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(mainLabel)
            make.right.equalTo(contentView).offset(-10)
            make.width.height.equalTo(28)
        }
    }

    private func setupStackViews() {
        topStackView.snp.makeConstraints { (make) in
            make.top.equalTo(airplaneLabel.snp.bottom).offset(5)
            make.centerX.equalTo(contentView)
            make.width.lessThanOrEqualTo(contentView).multipliedBy(0.9)
            make.height.equalTo(topStackView.snp.width).multipliedBy(0.4)
        }

        bottomStackView.snp.makeConstraints { (make) in
            make.top.equalTo(topStackView.snp.bottom)
            make.centerX.equalTo(contentView)
            make.width.equalTo(topStackView)
            make.height.equalTo(bottomStackView.snp.width).multipliedBy(0.4)
            make.bottom.lessThanOrEqualTo(contentView).offset(-10)
        }

        topStackView.addArrangedSubviews([double, settings, pinch])
        bottomStackView.addArrangedSubviews([skewed, settingsHelpView])

        settingsHelpView.snp.makeConstraints { (make) in
            make.width.equalTo(bottomStackView).multipliedBy(0.656)
        }
    }

    private func setAirplaneLabelText() {
        let attString = NSMutableAttributedString().withAttributes(
            text: "Advice: ", textColor: .white, font: UIFont.boldSystemFont(ofSize: 16)
        ).appendStringWithAttributes(
            text: "Turn on Airplane mode",
            textColor: .white,
            font: UIFont.systemFont(ofSize: 15)
        )

        airplaneLabel.attributedText = attString
        airplaneLabel.adjustsFontSizeToFitWidth = true
        airplaneLabel.minimumScaleFactor = 0.8
    }

    private func setupCloseImage() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeView))
        closeImageView.isUserInteractionEnabled = true
        closeImageView.addGestureRecognizer(tapGesture)

        let backgroundGesture = UITapGestureRecognizer(target: self, action: #selector(closeView))
        backgroundView.isUserInteractionEnabled = true
        backgroundView.addGestureRecognizer(backgroundGesture)
    }

    @objc private func closeView() {
        self.isHidden = true
        self.delegate?.windowDismissed()
    }
}
