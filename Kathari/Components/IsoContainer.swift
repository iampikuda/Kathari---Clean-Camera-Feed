//
//  IsoContainer.swift
//  Kathari
//
//  Created by Oluwadamisi Pikuda on 28/08/2020.
//  Copyright © 2020 Damisi Pikuda. All rights reserved.
//

import UIKit
import SnapKit

final class IsoContainer: UIView {

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()

    private let mainView = UIView()

    private let isoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(imageName: .iso)?.withRenderingMode(.alwaysTemplate)
        imageView.clipsToBounds = true
        imageView.tintColor = .gold
        return imageView
    }()

    private let bottomLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .gold
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "AUTO"
        return label
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
        addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.height.equalTo(self)
            make.width.equalTo(mainView.snp.height).multipliedBy(1.1)
            make.centerX.centerY.equalTo(self)
        }

        mainView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(mainView)
            make.bottom.equalTo(mainView).offset(-3)
        }

        mainView.layer.cornerRadius = 3
        mainView.layer.borderWidth = 1
        mainView.layer.borderColor = UIColor.gold.cgColor

        stackView.addArrangedSubviews([isoImageView, bottomLabel])
        isoImageView.snp.makeConstraints { (make) in
            make.height.equalTo(stackView).multipliedBy(0.7)
        }
    }

    func setColor(_ color: UIColor) {
        isoImageView.tintColor = color
        bottomLabel.textColor = color
        mainView.layer.borderColor = color.cgColor
    }

    func setIso(_ iso: Float?) {
        if let iso = iso {
            bottomLabel.text = "\(Int(iso))"
        } else {
            bottomLabel.text = "AUTO"
        }
    }
}
