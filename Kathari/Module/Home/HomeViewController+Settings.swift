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
        setupButtonStackView()
        setupSwipeGesture()
        setupLongPress()
    }

    private func setupButtonStackView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(buttonTapped(_:)))
        buttonStackView.isUserInteractionEnabled = true
        buttonStackView.addGestureRecognizer(tapGesture)
    }

    private func setupSwipeGesture() {
        let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture(_:)))
        swipeUpGesture.direction = .up
        view.addGestureRecognizer(swipeUpGesture)
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture(_:)))
        swipeDownGesture.direction = .down
        view.addGestureRecognizer(swipeDownGesture)
    }

    private func setupLongPress() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(_:)))
        buttonStackView.addGestureRecognizer(longPress)
    }

    @objc func longPressed(_ sender: UILongPressGestureRecognizer) {
        let tapLocation = sender.location(in: buttonStackView)

        if flashImageView.frame.contains(tapLocation) && torchCanBeTapped {
            if !torchView.isShowing {
                setTorchLevel(to: previousTorchLevel)
                torchView.initialLevel = previousTorchLevel
                torchView.show()
            }

            if exposureView.isShowing {
                exposureView.hide()
            }
        } else if isoView.frame.contains(tapLocation) {
            if !exposureView.isShowing {
                if let device = activeCamera {
                    exposureView.initialLevel = device.iso
                    exposureView.setMinMax(min: device.activeFormat.minISO, max: device.activeFormat.maxISO)
                }
                exposureView.show()
            }

            if torchView.isShowing {
                torchView.hide()
            }
        }
    }

    @objc func swipeGesture(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .up {
            overlayView.isHidden = false
        } else if sender.direction == .down {
            overlayView.isHidden = true
        }
    }

    @objc func buttonTapped(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: buttonStackView)

        if flashImageView.frame.contains(tapLocation) && torchCanBeTapped, let device = activeCamera {
            if device.torchMode == .off {
                torchOn()
            } else {
                torchOff()
            }
        } else if isoView.frame.contains(tapLocation) {
            self.toggleIso()
        }
    }

    func toggleIso() {
        guard let device = activeCamera else {
            Helper.logError(KHError(message: "Couldn't find active cam"))
            return
        }

        configureDevice(device) { (lockedDevice) in
            if self.autoIso, lockedDevice.isExposureModeSupported(.continuousAutoExposure) {
                lockedDevice.exposureMode = .continuousAutoExposure

                DispatchQueue.main.async {
                    self.isoView.setIso(nil)
                    self.isoView.setColor(.gold)
                }
            } else if lockedDevice.isExposureModeSupported(.locked) {
                lockedDevice.exposureMode = .locked

                DispatchQueue.main.async {
                    self.isoView.setIso(device.iso)
                    self.isoView.setColor(.white)
                }
            }
        }

        autoIso.toggle()
    }

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
                    sself.previousTorchLevel = level
                } else {
                    try? device.setTorchModeOn(level: sself.previousTorchLevel)
                }

                DispatchQueue.main.async {
                    sself.flashImageView.tintColor = .gold
                }
            }
        } else {
            self.flashImageView.tintColor = .lightGray
            Helper.logError(KHError(message: "Torch is not available"))
        }
    }

    func torchOff() {
        guard let device = AVCaptureDevice.default(for: .video) else { return }

        if device.hasTorch {
            configureDevice(device) { [weak self] (device) in
                device.torchMode = .off

                DispatchQueue.main.async {
                    if self?.torchCanBeTapped == false {
                        self?.flashImageView.tintColor = .lightGray
                    } else {
                        self?.flashImageView.tintColor = .white
                    }
                }
            }
        } else {
            self.flashImageView.tintColor = .lightGray
            Helper.logError(KHError(message: "Torch is not available"))
        }
    }

    func setupIsoObserver() {
        addObserver(self, forKeyPath: "activeCamera.ISO", options: [.initial, .new], context: nil)
    }

    // swiftlint:disable:next block_based_kvo
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey: Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath == "activeCamera.ISO" {
            if let device = activeCamera, autoIso, sessionSetupSucceeds {
                DispatchQueue.main.async {
                    if self.exposureView.isShowing {
                        self.exposureView.setValue(device.iso)
                    }
                }
            }
        }
    }
}

extension HomeViewController: SliderViewDelegate {
    func slider(_ slider: SliderView, changedTo value: Float) {
        if slider == torchView {
            setTorchLevel(to: value)
        } else {
            if let device = activeCamera {
                configureDevice(device) { (device) in
                    device.setExposureModeCustom(
                        duration: device.exposureDuration,
                        iso: value,
                        completionHandler: nil
                    )
                }

                DispatchQueue.main.async {
                    self.isoView.setIso(device.iso)
                    if self.autoIso {
                        self.autoIso.toggle()
                        self.isoView.setColor(.white)
                    }
                }
            }
        }
    }
}
