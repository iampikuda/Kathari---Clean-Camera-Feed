//
//  HomeViewController+Torch.swift
//  Kathari
//
//  Created by Oluwadamisi Pikuda on 05/09/2020.
//  Copyright © 2020 Damisi Pikuda. All rights reserved.
//

import AVFoundation

extension HomeViewController {
    func setTorchLevel(to level: Float) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }

        if device.hasTorch, level != 0 {
            torchOn(level: level)
        } else {
            torchOff()
        }
    }

    func torchOn(level: Float? = nil) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }

        if device.hasTorch {
            configureDevice(device) { [weak self] (device) in
                guard let sself = self else { return }
                if let level = level {
                    try? device.setTorchModeOn(level: level)
                    self?.previousTorchLevel = level
                } else {
                    try? device.setTorchModeOn(level: sself.previousTorchLevel)
                }

                DispatchQueue.main.async {
                    self?.flashImageView.tintColor = .gold
                    self?.torchSliderView.setValue(sself.previousTorchLevel)
                }
            }
        } else {
            self.flashImageView.tintColor = .lightGray
            Helper.logError(KHError(message: "Torch is not available"), errorMsg: "Device doesn't have torch")
        }
    }

    func torchOff() {
        guard let device = AVCaptureDevice.default(for: .video) else { return }

        if device.hasTorch {
            configureDevice(device) { [weak self] (device) in
                device.torchMode = .off

                DispatchQueue.main.async { [weak self] in
                    self?.torchSliderView.setValue(0)

                    if self?.torchCanBeTapped == false {
                        self?.flashImageView.tintColor = .lightGray
                    } else {
                        self?.flashImageView.tintColor = .white
                    }
                }
            }
        } else {
            self.flashImageView.tintColor = .lightGray
            Helper.logError(KHError(message: "Torch is not available"), errorMsg: "Device doesn't have torch")
        }
    }

    func disableTorch() {
        DispatchQueue.main.async {
            self.torchCanBeTapped = false
            self.torchOff()
        }
    }

    func enableTorch() {
        DispatchQueue.main.async {
            self.flashImageView.tintColor = .white
            self.torchCanBeTapped = true
        }
    }
}
