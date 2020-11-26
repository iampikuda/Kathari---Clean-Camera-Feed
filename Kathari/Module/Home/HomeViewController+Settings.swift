//
//  HomeViewController+Settings.swift
//  Kathari
//
//  Created by Oluwadamisi Pikuda on 15/08/2020.
//  Copyright © 2020 Damisi Pikuda. All rights reserved.
//

import UIKit
import SnapKit
import AVFoundation

extension HomeViewController {
    func setupSettingsView() {
        settingsContainerView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        settingsContainerView.layer.cornerRadius = 10
        settingsContainerView.isUserInteractionEnabled = true

        view.addSubview(settingsContainerView)
        settingsContainerView.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-2)
            make.centerX.equalTo(view)
            make.width.equalTo(self.screenPortraitWidth * 0.9)
            make.height.equalTo(50)
        }

        settingsContainerView.addSubview(settingsStackView)
        settingsStackView.snp.makeConstraints { (make) in
            make.centerY.left.right.equalTo(settingsContainerView)
            make.height.equalTo(settingsContainerView).multipliedBy(0.7)
        }

        settingsStackView.addArrangedSubviews([flashImageView, isoButtonView, rgbButtonView, helpImageView])
    }

    func setupButtonStackView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(buttonTapped(_:)))
        settingsStackView.isUserInteractionEnabled = true
        settingsStackView.addGestureRecognizer(tapGesture)
    }

    func setupLongPress() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(_:)))
        settingsStackView.addGestureRecognizer(longPress)
    }

    func toggleIso() {
        guard let device = activeCamera else {
            Helper.logError(KHError(message: "Couldn't find active cam"), errorMsg: "Active cam no found")
            return
        }

        autoIso.toggle()

        configureDevice(device) { (lockedDevice) in
            if self.autoIso, lockedDevice.isExposureModeSupported(.continuousAutoExposure) {
                lockedDevice.exposureMode = .continuousAutoExposure
                DispatchQueue.main.async {
                    self.isoButtonView.setIso(nil)
                    self.isoButtonView.setColor(.gold)
                }
            } else if lockedDevice.isExposureModeSupported(.locked) {
                lockedDevice.exposureMode = .locked

                DispatchQueue.main.async {
                    self.isoButtonView.setIso(device.iso)
                    self.isoButtonView.setColor(.white)
                }
            }
        }
    }

    func startHideTimer() {
//        NSLog("start hide timer")
        hideTimer = Timer.scheduledTimer(withTimeInterval: 4, repeats: false, block: { [weak self] _ in
            DispatchQueue.main.async { [weak self] in
                self?.settingsContainerView.isHidden = true
                print("---------")
            }
        })
    }
}

extension HomeViewController: SliderViewDelegate {
    func slider(_ slider: SliderView, changedTo value: Float) {
        if slider == torchSliderView {
            setTorchLevel(to: value)
        } else if slider == isoSliderView {
            guard let device = activeCamera else { return }
            configureDevice(device) { (device) in
                device.setExposureModeCustom(
                    duration: device.exposureDuration,
                    iso: value,
                    completionHandler: nil
                )
            }

            DispatchQueue.main.async {
                self.isoButtonView.setIso(device.iso)
                if self.autoIso {
                    self.autoIso.toggle()
                    self.isoButtonView.setColor(.white)
                }
            }
        }
    }
}
