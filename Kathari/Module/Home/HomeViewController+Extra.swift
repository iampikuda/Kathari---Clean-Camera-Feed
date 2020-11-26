//
//  HomeViewController+Extra.swift
//  Kathari
//
//  Created by Oluwadamisi Pikuda on 05/09/2020.
//  Copyright © 2020 Damisi Pikuda. All rights reserved.
//

import UIKit
import SnapKit

extension HomeViewController {
    func setupHelpView() {
        view.addSubview(helpView)
        helpView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(view)
            make.bottom.equalTo(settingsContainerView.snp.top)
        }

        helpView.delegate = self
    }

    func setupNameLabel() {
        view.addSubview(cameraNameLabel)
        cameraNameLabel.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(view)
        }
    }
}
