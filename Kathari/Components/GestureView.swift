//
//  GestureView.swift
//  Kathari
//
//  Created by Oluwadamisi Pikuda on 31/08/2020.
//  Copyright © 2020 Damisi Pikuda. All rights reserved.
//

import UIKit
import SnapKit

class GestureView: DashedView {
    fileprivate let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.tintColor = .white
        return imageView
    }()

    fileprivate let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()

    fileprivate let subTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.text = "Text"
        return label
    }()

    init(imageName: ImageName, title: String, subTitle: String) {
        super.init(frame: .zero)
        imageView.image = UIImage(imageName: imageName)?.withRenderingMode(.alwaysTemplate)
        titleLabel.text = "(\(title))"
        subTitleLabel.text = subTitle
        setupView()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        snp.makeConstraints { (make) in
            make.width.equalTo(snp.height).multipliedBy(0.9)
        }

        setupImageView()
        setupLabels()
    }

    func setupImageView() {
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(2)
            make.centerX.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.4)
        }
    }

    func setupLabels() {
        addSubviews([titleLabel, subTitleLabel])
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.8)
            make.top.equalTo(imageView.snp.bottom)
            make.height.equalTo(self).multipliedBy(0.1)
        }

        subTitleLabel.snp.makeConstraints { (make) in
            make.bottom.centerX.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.8)
            make.top.equalTo(titleLabel.snp.bottom)
            make.height.equalTo(self).multipliedBy(0.4)
        }
    }
}

final class DoubleGestureView: GestureView {
    private let imageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.tintColor = .white
        return imageView
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 11
        return stackView
    }()

    init(imageName: ImageName, imageName2: ImageName, title: String, subTitle: String) {
        super.init(imageName: imageName, title: title, subTitle: subTitle)
        imageView2.image = UIImage(imageName: imageName2)?.withRenderingMode(.alwaysTemplate)
    }

    override func setupImageView() {
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(2)
            make.centerX.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.55)
        }

        stackView.addArrangedSubviews([imageView, imageView2])
    }
}
