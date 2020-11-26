//
//  RGBContainer.swift
//  Kathari
//
//  Created by Oluwadamisi Pikuda on 05/09/2020.
//  Copyright © 2020 Damisi Pikuda. All rights reserved.
//

import UIKit
import SnapKit

final class WBContainer: UIView {
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()

    private let mainView = UIView()

    private let rgbImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(imageName: .whiteBalance)?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .gold
        imageView.clipsToBounds = true
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

    private(set) var isAuto: Bool = true

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

        stackView.addArrangedSubviews([rgbImageView, bottomLabel])
        bottomLabel.snp.makeConstraints { (make) in
            make.height.equalTo(mainView).multipliedBy(0.28).priority(.medium)
        }
    }

    func setAuto(_ auto: Bool) {
        if auto {
            bottomLabel.isHidden = false
            mainView.layer.borderWidth = 1
            rgbImageView.tintColor = .gold
        } else {
            bottomLabel.isHidden = true
            mainView.layer.borderWidth = 0
            rgbImageView.tintColor = .white
        }

        self.isAuto = auto
    }
}
