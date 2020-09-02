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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupIsoObserver()
        DispatchQueue.main.async {
            self.transformOrientation()
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
        DispatchQueue.main.async {
            self.previewLayer.frame = self.previewView.bounds
        }
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
        self.transformOrientation()
    }

    private func setupPreviewLayer() {
        previewLayer.videoGravity = .resizeAspectFill
        view.addSubview(previewView)
        previewView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }

        previewView.layer.insertSublayer(previewLayer, at: 0)
        previewLayer.frame = previewView.bounds
    }

    private func setupTapGestures() {
        let switchRecognizer = UITapGestureRecognizer(target: self, action: #selector(switchCameraSide))
        switchRecognizer.numberOfTapsRequired = 2
        switchRecognizer.delegate = self
        previewView.addGestureRecognizer(switchRecognizer)

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(cameraTapped))
        tapRecognizer.numberOfTapsRequired = 1
//        tapRecognizer.delegate = self
        previewView.addGestureRecognizer(tapRecognizer)

        tapRecognizer.require(toFail: switchRecognizer)

        previewView.isUserInteractionEnabled = true
    }

    private func setupPinchGesture() {
        let gestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinchCamera(_:)))
        previewView.addGestureRecognizer(gestureRecognizer)
    }

    private func setupObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(transformOrientation),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
    }

    @objc private func transformOrientation() {
        switch UIApplication.visibleWindow()?.windowScene?.interfaceOrientation {
        case .landscapeRight:
            print("LandRIGHT")
            self.helpView.transformOrientation(interfaceOrientation: .landscapeRight)
            self.previewLayer.connection?.videoOrientation = .landscapeRight
        case .portraitUpsideDown:
            print("UPsideDown")
            self.helpView.transformOrientation(interfaceOrientation: .portraitUpsideDown)
            self.previewLayer.connection?.videoOrientation = .portraitUpsideDown
        case .landscapeLeft:
            print("LandLEFT")
            self.helpView.transformOrientation(interfaceOrientation: .landscapeLeft)
            self.previewLayer.connection?.videoOrientation = .landscapeLeft
        default:
            print("everythoing else")
            self.helpView.transformOrientation(interfaceOrientation: .portrait)
            self.previewLayer.connection?.videoOrientation = .portrait
        }
    }

    private func showFlipError() {
        DispatchQueue.main.async {
            self.showAlertWithOkAction(title: "Arrgh!", message: "We couldn't flip the camera.")
        }
    }

    private func setCamera(_ position: AVCaptureDevice.Position) throws {
        session.beginConfiguration()
        if let currentInput = session.inputs.first { session.removeInput(currentInput) }

        guard let device = getCameraForPosition(position) else {
            showFlipError()
            throw KHError(message: "Couldn't find camera at new position \(String(describing: position))")
        }

        if device.supportsSessionPreset(.hd4K3840x2160), session.canSetSessionPreset(.hd4K3840x2160) {
            session.sessionPreset = .hd4K3840x2160
        } else {
            session.sessionPreset = .high
        }

        guard let newVideoInput = try? AVCaptureDeviceInput(device: device) else {
            showFlipError()
            throw KHError(message: "Couldn't create new input")
        }

        guard session.canAddInput(newVideoInput) else {
            showFlipError()
            throw KHError(message: "Couldn't add input to session")
        }

        device.hasTorch ? enableTorch() : disableTorch()

        configureDevice(device) { (lockedDevice) in
            if lockedDevice.isFocusModeSupported(.continuousAutoFocus) {
                lockedDevice.focusMode = .continuousAutoFocus
            }

            if lockedDevice.isExposureModeSupported(.continuousAutoExposure) {
                lockedDevice.exposureMode = .continuousAutoExposure
            }
        }

        DispatchQueue.main.async {
            if !self.autoIso {
                self.isoView.setIso(nil)
                self.isoView.setColor(.gold)
                self.autoIso.toggle()
            }
        }

        activeCamera = device
        setupIsoObserver()
        session.addInput(newVideoInput)
        session.commitConfiguration()
    }

    @objc private func cameraTapped() {
        helpView.isHidden = true
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
        let allCams = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera, .builtInDualCamera, .builtInTelephotoCamera],
            mediaType: .video,
            position: position
        ).devices

        print(allCams)
        print(allCams.count)
        print(allCams.first?.localizedName)
        print(String(describing: allCams.first?.deviceType))
        return allCams.first
    }
}
