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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sessionQueue.async { [unowned self] in
            if self.sessionSetupSucceeds == true {
                self.session.startRunning()
                print("🙌🙌🙌SESSION RUNNING🙌🙌🙌")
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if sessionSetupSucceeds {
            self.session.stopRunning()
            print("😭😭😭😭😭SESSION STOPPED")
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.previewLayer.frame = self.view.layer.bounds
    }

    func setupCameraView() {
        setupPreviewLayer()
        setupSession()
        setupTapGestures()
        setupPinchGesture()
        setupObservers()
    }

    private func setupSession() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            sessionQueue.async { [unowned self] in
                do {
                    try self.setCamera(.back)
                    self.sessionSetupSucceeds = true
                } catch {
                    Helper.logError(error)
                    return
                }
            }
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [unowned self] granted in
                if granted {
                    self.sessionQueue.async { [unowned self] in
                        do {
                            try self.setCamera(.back)
                            self.sessionSetupSucceeds = true
                        } catch {
                            Helper.logError(error)
                            return
                        }
                    }
                }
            }
        default:
            break
        }
    }

    private func setupPreviewLayer() {
        view.layer.insertSublayer(previewLayer, at: 0)
        previewLayer.frame.size = view.frame.size
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        transformOrientation()
    }

    private func setupTapGestures() {
        let switchRecognizer = UITapGestureRecognizer(target: self, action: #selector(switchCameraSide))
        switchRecognizer.numberOfTapsRequired = 2
        switchRecognizer.delegate = self
        view.addGestureRecognizer(switchRecognizer)
        view.isUserInteractionEnabled = true
    }

    private func setupPinchGesture() {
        let gestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinchCamera(_:)))
        view.addGestureRecognizer(gestureRecognizer)
    }

    private func setupObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(transformOrientation),
                                               name: UIDevice.orientationDidChangeNotification,
                                               object: nil)
    }

    @objc private func transformOrientation() {
        switch UIDevice.current.orientation {
        case .portrait:
            self.previewLayer.connection?.videoOrientation = .portrait
        case .landscapeRight:
            self.previewLayer.connection?.videoOrientation = .landscapeLeft
        case .portraitUpsideDown:
            self.previewLayer.connection?.videoOrientation = .portraitUpsideDown
        case .landscapeLeft:
            self.previewLayer.connection?.videoOrientation = .landscapeRight
        default:
            break
        }

    }

    private func setCamera(_ position: AVCaptureDevice.Position) throws {
        session.beginConfiguration()
        if let currentInput = session.inputs.first { session.removeInput(currentInput) }

        guard let device = getCameraForPosition(position),
            let newVideoInput = try? AVCaptureDeviceInput(device: device),
            session.canAddInput(newVideoInput) else {
                showAlertWithOkAction(title: "Arrgh!", message: "We couldn't flip the camera.")
                throw KHError(message: "Couldn't find camera at new position \(String(describing: position))")
        }

        device.hasTorch ? enableTorch() : disableTorch()

        configureDevice(device) { (lockedDevice) in
            if lockedDevice.isFocusModeSupported(.continuousAutoFocus) {
                lockedDevice.focusMode = .continuousAutoFocus
            }
        }

        activeCamera = device
        session.addInput(newVideoInput)
        session.commitConfiguration()
    }

    @objc private func switchCameraSide() {
        guard sessionSetupSucceeds, let newPostion = activeCamera?.position.flipped else {
            return
        }

        sessionQueue.async { [unowned self] in
            do {
                self.session.beginConfiguration()
                try self.setCamera(newPostion)
                self.session.commitConfiguration()
            } catch {
                Helper.logError(error)
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
                Helper.logError(error)
            }
        }
    }

    @objc private func pinchCamera(_ pinch: UIPinchGestureRecognizer) {
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

    private func disableTorch() {
        DispatchQueue.main.async {
            self.torchCanBeTapped = false
            self.torchOff()
        }
    }

    private func enableTorch() {
        DispatchQueue.main.async {
            self.flashImageView.tintColor = .white
            self.torchCanBeTapped = true
        }
    }

    private func getCameraForPosition(_ position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        return AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInDualCamera, .builtInWideAngleCamera, .builtInTelephotoCamera ],
            mediaType: .video,
            position: position
        ).devices.first
    }
}
