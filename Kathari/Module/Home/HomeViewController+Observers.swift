//
//  HomeViewController+Observers.swift
//  Kathari
//
//  Created by Oluwadamisi Pikuda on 05/09/2020.
//  Copyright © 2020 Damisi Pikuda. All rights reserved.
//

import UIKit

extension HomeViewController {
    func setupObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(transformOrientation),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )

        addObserver(self, forKeyPath: "activeCamera.ISO", options: [.initial, .new], context: nil)
        addObserver(self, forKeyPath: "activeCamera.deviceWhiteBalanceGains", options: [.initial, .new], context: nil)
    }

    @objc func transformOrientation() {
        switch UIApplication.visibleWindow()?.windowScene?.interfaceOrientation {
        case .landscapeRight:
            self.helpView.transformOrientation(interfaceOrientation: .landscapeRight)
            self.torchSliderView.transformOrientation(interfaceOrientation: .landscapeRight)
            self.isoSliderView.transformOrientation(interfaceOrientation: .landscapeRight)
            self.rgbSliderView.transformOrientation(interfaceOrientation: .landscapeRight)
            self.previewLayer.connection?.videoOrientation = .landscapeRight
        case .portraitUpsideDown:
            break
        case .landscapeLeft:
            self.helpView.transformOrientation(interfaceOrientation: .landscapeLeft)
            self.torchSliderView.transformOrientation(interfaceOrientation: .landscapeRight)
            self.isoSliderView.transformOrientation(interfaceOrientation: .landscapeRight)
            self.rgbSliderView.transformOrientation(interfaceOrientation: .landscapeRight)
            self.previewLayer.connection?.videoOrientation = .landscapeLeft
        default:
            self.helpView.transformOrientation(interfaceOrientation: .portrait)
            self.torchSliderView.transformOrientation(interfaceOrientation: .portrait)
            self.isoSliderView.transformOrientation(interfaceOrientation: .portrait)
            self.rgbSliderView.transformOrientation(interfaceOrientation: .portrait)
            self.previewLayer.connection?.videoOrientation = .portrait
        }
    }

    // swiftlint:disable:next block_based_kvo
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey: Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath == "activeCamera.ISO" {
            guard let device = activeCamera, autoIso, sessionSetupSucceeds else { return }

            DispatchQueue.main.async {
                if self.isoSliderView.isShowing {
                    self.isoSliderView.setValue(device.iso)
                }
            }
        } else if keyPath == "activeCamera.deviceWhiteBalanceGains" {
            guard let device = activeCamera, autoRGB, sessionSetupSucceeds else { return }

            DispatchQueue.main.async {
                if self.rgbSliderView.isShowing {
                    let gains = device.deviceWhiteBalanceGains
                    self.rgbSliderView.setSlider(.red, value: gains.redGain)
                    self.rgbSliderView.setSlider(.green, value: gains.greenGain)
                    self.rgbSliderView.setSlider(.blue, value: gains.blueGain)
                }
            }
        }
    }
}
