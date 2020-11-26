//
//  HomeViewController+Camera.swift
//  Kathari
//
//  Created by Oluwadamisi Pikuda on 15/08/2020.
//  Copyright © 2020 Damisi Pikuda. All rights reserved.
//

import UIKit
import SnapKit
import AVFoundation

extension HomeViewController {
    func checkCameraStatus() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupSession(newSession: false)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [unowned self] granted in
                if granted {
                    self.setupSession(newSession: true)
                } else {
                    DispatchQueue.main.async {
                        self.showAlertWithOkAction(
                            title: "Not good!",
                            message: "You can't use this app without giving us permission to use your camera."
                        )
                    }
                }
            }
        default:
            DispatchQueue.main.async {
                self.showAlertWithOkAction(
                    title: "Hmmmm!",
                    message: "We don't have permission to use your camera. Please check your settings."
                )
            }
        }
        self.transformOrientation()
    }

    private func setupSession(newSession: Bool) {
        self.sessionQueue.async { [unowned self] in
            do {
                try self.setCamera(self.getCameraForPosition(.back))
                self.sessionSetupSucceeds = true

                if newSession {
                    DispatchQueue.main.async {
                        self.session.startRunning()
                        print("🙌🙌🙌SESSION RUNNING🙌🙌🙌")
                    }
                }
            } catch {
                Helper.logError(error, errorMsg: "Unable to set camera")
                DispatchQueue.main.async {
                    self.showAlertWithOkAction(
                        title: "Hmmmm!",
                        message: "We ran into an issue. Please reload the app."
                    )
                }
                return
            }
        }
    }

    func setupPreviewLayer() {
        previewLayer.videoGravity = .resizeAspectFill
        view.addSubview(previewView)
        previewView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }

        previewView.layer.insertSublayer(previewLayer, at: 0)
        previewLayer.frame = previewView.bounds
    }

    func showFlipError() {
        DispatchQueue.main.async {
            self.showAlertWithOkAction(title: "So...", message: "We couldn't change the camera. Try reloading the app")
        }
    }

    func setCamera(_ device: AVCaptureDevice?) throws {
        guard let device = device else {
            showFlipError()
            throw KHError(message: "Device is nil")
        }

        guard device != activeCamera else { return }

        session.beginConfiguration()
        if let currentInput = session.inputs.first { session.removeInput(currentInput) }

        self.setSessionPresetFor(device)

        guard let newVideoInput = try? AVCaptureDeviceInput(device: device) else {
            showFlipError()
            throw KHError(message: "Couldn't create new input")
        }

        guard session.canAddInput(newVideoInput) else {
            showFlipError()
            throw KHError(message: "Couldn't add input to session")
        }

        device.hasTorch ? enableTorch() : disableTorch()

        self.setDefaultModeFor(device)

        activeCamera = device
        session.addInput(newVideoInput)
        session.commitConfiguration()
    }

    private func setSessionPresetFor(_ device: AVCaptureDevice) {
        if device.supportsSessionPreset(.hd4K3840x2160), session.canSetSessionPreset(.hd4K3840x2160) {
            session.sessionPreset = .hd4K3840x2160
        } else {
            session.sessionPreset = .high
        }
    }

    private func setDefaultModeFor(_ device: AVCaptureDevice) {
        configureDevice(device) { (lockedDevice) in
            if lockedDevice.isFocusModeSupported(.continuousAutoFocus) {
                lockedDevice.focusMode = .continuousAutoFocus
            }

            if lockedDevice.isExposureModeSupported(.continuousAutoExposure) {
                lockedDevice.exposureMode = .continuousAutoExposure

                DispatchQueue.main.async {
                    if !self.autoIso {
                        self.isoButtonView.setIso(nil)
                        self.isoButtonView.setColor(.gold)
                        self.autoIso = true
                    }
                }
            }

            if lockedDevice.isWhiteBalanceModeSupported(.continuousAutoWhiteBalance) {
                lockedDevice.whiteBalanceMode = .continuousAutoWhiteBalance

                DispatchQueue.main.async {
                    if !self.autoRGB {
                        self.rgbButtonView.setAuto(true)
                        self.autoRGB = true
                    }
                }
            }
        }
    }

    func configureDevice(_ device: AVCaptureDevice, config: @escaping (AVCaptureDevice) -> Void) {
        sessionQueue.async {
            do {
                try device.lockForConfiguration()
                config(device)
                device.unlockForConfiguration()
            } catch {
                Helper.logError(error, errorMsg: "Unable to configure device")
            }
        }
    }

    func getNextCamera() -> AVCaptureDevice? {
        let nextIndex = activeCamIndex + 1
        var nextCam = activeCamera

        if nextIndex < numberOfCams {
            nextCam = allCameras[nextIndex]
            self.nextCamIndex = nextIndex
        } else {
            self.nextCamIndex = 0
        }

        return nextCam
    }

    func showCamLabel() {
        guard let cameraName = activeCamera?.localizedName else { return }

        DispatchQueue.main.async {
            self.cameraNameLabel.text = cameraName
            UIView.animate(
                withDuration: 0.7,
                animations: {
                    self.cameraNameLabel.alpha = 0.8
                    self.cameraNameLabel.transform = CGAffineTransform(scaleX: 2, y: 2)
                }, completion: { _ in
                    UIView.animate(
                        withDuration: 0.3,
                        animations: {
                            self.cameraNameLabel.alpha = 0
                        }, completion: { _ in
                            self.cameraNameLabel.transform = .identity
                        }
                    )
                }
            )
        }
    }

    func getCameraForPosition(_ position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let allCams = AVCaptureDevice.DiscoverySession(
            deviceTypes: [
                .builtInWideAngleCamera,
                .builtInTripleCamera,
                .builtInUltraWideCamera,
                .builtInDualCamera,
                .builtInTelephotoCamera
            ],
            mediaType: .video,
            position: position
        ).devices

        allCameras = allCams
        activeCamIndex = 0
        print(allCams)
        print(allCams.map({ $0.localizedName }))

        guard let firstCam = allCams.first else {
            Helper.logError(
                KHError(message: "No camera found at position: \(String(describing: position))"),
                errorMsg: "No camera found"
            )
            return nil
        }

        return firstCam
    }
}
