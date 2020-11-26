//
//  HeaderView.swift
//  Kathari
//
//  Created by Oluwadamisi Pikuda on 01/09/2020.
//  Copyright © 2020 Damisi Pikuda. All rights reserved.
//

import UIKit
import SnapKit

final class HeaderView: UIView {
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Settings"
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
        layer.cornerRadius = 2
        backgroundColor = .white
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(self)
            make.height.equalTo(self).multipliedBy(0.99)
        }
    }
}
