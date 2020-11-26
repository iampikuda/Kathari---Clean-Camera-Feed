//
//  HomeViewController+Gestures.swift
//  Kathari
//
//  Created by Oluwadamisi Pikuda on 05/09/2020.
//  Copyright © 2020 Damisi Pikuda. All rights reserved.
//

import UIKit

extension HomeViewController {
    func setupTapGestures() {
        let switchRecognizer = UITapGestureRecognizer(target: self, action: #selector(switchCameraSide))
        switchRecognizer.numberOfTapsRequired = 2
        switchRecognizer.delegate = self
        previewView.addGestureRecognizer(switchRecognizer)
        previewView.isUserInteractionEnabled = true
    }

    func setupSwipeGesture() {
        let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture(_:)))
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture(_:)))
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture(_:)))

        swipeUpGesture.direction = .up
        swipeDownGesture.direction = .down
        swipeRightGesture.direction = .right

        view.addGestureRecognizer(swipeUpGesture)
        view.addGestureRecognizer(swipeDownGesture)
        view.addGestureRecognizer(swipeRightGesture)
    }

    func setupPinchGesture() {
        let gestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinchCamera(_:)))
        previewView.addGestureRecognizer(gestureRecognizer)
    }

    @objc func longPressed(_ sender: UILongPressGestureRecognizer) {
        let tapLocation = sender.location(in: settingsStackView)
        self.helpView.isHidden = true
        self.hideTimer = nil

        if flashImageView.frame.contains(tapLocation) && torchCanBeTapped {
            showTorchSlider()

        } else if isoButtonView.frame.contains(tapLocation) {
            showISOSlider()

        } else if rgbButtonView.frame.contains(tapLocation) {
            showRGBSlider()
        }
    }

    @objc func swipeGesture(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .up {
            settingsContainerView.isHidden = false
            startHideTimer()
        } else if sender.direction == .down {
            settingsContainerView.isHidden = true
            helpView.isHidden = true
            hideTimer = nil
        } else if sender.direction == .right {
            do {
                try setCamera(getNextCamera())
                activeCamIndex = nextCamIndex
                showCamLabel()
            } catch {
                Helper.logError(error, errorMsg: "Unable to CHANGE camera on swipe gesture")
            }
        }
    }

    @objc func buttonTapped(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: settingsStackView)

        if flashImageView.frame.contains(tapLocation) && torchCanBeTapped, let device = activeCamera {
            if device.torchMode == .off {
                torchOn()
            } else {
                torchOff()
            }
        } else if isoButtonView.frame.contains(tapLocation) {
            self.toggleIso()

        } else if helpImageView.frame.contains(tapLocation) {
            self.helpView.isHidden.toggle()

            if torchSliderView.isShowing { torchSliderView.hide() }
            if isoSliderView.isShowing { isoSliderView.hide() }
            if rgbSliderView.isShowing { rgbSliderView.hide() }
        } else if rgbButtonView.frame.contains(tapLocation) {
            self.toggleRGB()
        }

        if torchSliderView.isShowing || isoSliderView.isShowing
            || rgbSliderView.isShowing || !helpView.isHidden {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.hideTimer = nil
            }
        } else {
            self.startHideTimer()
        }
    }

    @objc func pinchCamera(_ pinch: UIPinchGestureRecognizer) {
        guard sessionSetupSucceeds, let device = activeCamera else { return }

        switch pinch.state {
        case .began:
            lastZoomFactor = device.videoZoomFactor
            fallthrough
        case .changed:
            let minAvailableZoomScale = device.minAvailableVideoZoomFactor
            let maxAvailableZoomScale = device.maxAvailableVideoZoomFactor
            let availableZoomScaleRange = minAvailableZoomScale...maxAvailableZoomScale
            let resolvedZoomScaleRange = zoomScaleRange.clamped(to: availableZoomScaleRange)

            let resolvedScale = max(
                resolvedZoomScaleRange.lowerBound,
                min(pinch.scale * lastZoomFactor, resolvedZoomScaleRange.upperBound)
            )

            configureDevice(device) { lockedDevice in
                lockedDevice.videoZoomFactor = resolvedScale
            }
        default:
            return
        }
    }

    @objc func switchCameraSide() {
        guard sessionSetupSucceeds, let newPostion = activeCamera?.position.flipped else {
            return
        }

        sessionQueue.async { [unowned self] in
            do {
                try self.setCamera(self.getCameraForPosition(newPostion))
            } catch {
                Helper.logError(error, errorMsg: "Unable to FLIP camera on double tap")
            }
        }
    }

    private func showTorchSlider() {
        if !torchSliderView.isShowing {
            setTorchLevel(to: previousTorchLevel)
            torchSliderView.initialLevel = previousTorchLevel
            torchSliderView.show()
        }

        if isoSliderView.isShowing { isoSliderView.hide() }
        if rgbSliderView.isShowing {rgbSliderView.hide() }
    }

    private func showISOSlider() {
        if !isoSliderView.isShowing {
            if let device = activeCamera {
                isoSliderView.initialLevel = device.iso
                isoSliderView.setMinMax(min: device.activeFormat.minISO, max: device.activeFormat.maxISO)
            }
            isoSliderView.show()
        }

        if torchSliderView.isShowing { torchSliderView.hide() }
        if rgbSliderView.isShowing { rgbSliderView.hide() }
    }

    private func showRGBSlider() {
        if !rgbSliderView.isShowing {
            if let device = activeCamera {
                let gains = device.deviceWhiteBalanceGains
                rgbSliderView.rLevel = gains.redGain
                rgbSliderView.gLevel = gains.greenGain
                rgbSliderView.bLevel = gains.blueGain
                rgbSliderView.setMinMax(min: 1, max: device.maxWhiteBalanceGain)
            }
            rgbSliderView.show()
        }

        if torchSliderView.isShowing { torchSliderView.hide() }
        if isoSliderView.isShowing { isoSliderView.hide() }
    }
}

extension HomeViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
}
