//
//  HomeViewController+RGB.swift
//  Kathari
//
//  Created by Oluwadamisi Pikuda on 08/09/2020.
//  Copyright © 2020 Damisi Pikuda. All rights reserved.
//

import AVFoundation

extension HomeViewController {
    func toggleRGB() {
        guard let device = activeCamera else {
            Helper.logError(KHError(message: "Couldn't find active cam"), errorMsg: "Active cam no found")
            return
        }

        autoRGB.toggle()

        configureDevice(device) { (lockedDevice) in
            if self.autoRGB, lockedDevice.isWhiteBalanceModeSupported(.continuousAutoWhiteBalance) {
                lockedDevice.whiteBalanceMode = .continuousAutoWhiteBalance

                DispatchQueue.main.async {
                    self.rgbButtonView.setAuto(true)
                }
            } else if lockedDevice.isWhiteBalanceModeSupported(.locked) {
                lockedDevice.whiteBalanceMode = .locked

                DispatchQueue.main.async {
                    self.rgbButtonView.setAuto(false)
                }
            }
        }
    }

    private func nomalizeGains(
        rgb: RGB,
        value: Float,
        currentGains: AVCaptureDevice.WhiteBalanceGains
    ) -> AVCaptureDevice.WhiteBalanceGains {
        var gains = currentGains

        switch rgb {
        case .red:
            gains.redGain = value
        case .green:
            gains.greenGain = value
        case .blue:
            gains.blueGain = value
        }

        return gains
    }

    func startRGBTimer() {
//        NSLog("start RGB timer")
        rgbTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [weak self] _ in
            guard let device = self?.activeCamera else { return }
            DispatchQueue.main.async { [weak self] in
                self?.rgbSliderView.setSlider(.red, value: device.deviceWhiteBalanceGains.redGain)
                self?.rgbSliderView.setSlider(.green, value: device.deviceWhiteBalanceGains.greenGain)
                self?.rgbSliderView.setSlider(.blue, value: device.deviceWhiteBalanceGains.blueGain)
            }

//            NSLog("red level \(device.deviceWhiteBalanceGains.redGain)")
//            NSLog("green level \(device.deviceWhiteBalanceGains.greenGain)")
//            NSLog("blue level \(device.deviceWhiteBalanceGains.blueGain)")
        })
    }
}

extension HomeViewController: RGBDelegate {
    func slider(_ rgb: RGB, changedTo value: Float) {
        guard let device = activeCamera else { return }

        let gains = self.nomalizeGains(rgb: rgb, value: value, currentGains: device.deviceWhiteBalanceGains)

        configureDevice(device) { (device) in
            device.setWhiteBalanceModeLocked(
                with: gains,
                completionHandler: nil
            )
        }

        DispatchQueue.main.async { [weak self] in
            if self?.autoRGB == true {
                self?.autoRGB.toggle()
                self?.rgbButtonView.setAuto(false)
            }

            self?.startRGBTimer()
        }
    }
}

extension HomeViewController: WindowViewDelegate {
    func windowDismissed() {
        DispatchQueue.main.async {
            self.startHideTimer()
        }
    }
}
