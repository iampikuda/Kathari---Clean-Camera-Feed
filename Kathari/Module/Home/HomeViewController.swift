//
//  HomeViewController.swift
//  Kathari
//
//  Created by Oluwadamisi Pikuda on 14/08/2020.
//  Copyright © 2020 Damisi Pikuda. All rights reserved.
//

import UIKit
import SnapKit
import AVFoundation

final class HomeViewController: KHViewController {

    let cameraNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.alpha = 0
        return label
    }()

    // MARK: Settings
    var autoIso = true
    var autoRGB = true

    // Buttons
    let flashImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(imageName: .flash)?.withRenderingMode(.alwaysTemplate)
        imageView.clipsToBounds = true
        imageView.tintColor = .white
        return imageView
    }()

    let helpImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(imageName: .help)?.withRenderingMode(.alwaysTemplate)
        imageView.clipsToBounds = true
        imageView.tintColor = .white
        return imageView
    }()

    let settingsContainerView = UIView()
    let isoButtonView = IsoContainer()
    let rgbButtonView = WBContainer()

    let settingsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 11
        return stackView
    }()

    // Sliders
    lazy var isoSliderView: SliderView = {
        let view = SliderView(anchor: isoButtonView)
        view.delegate = self
        return view
    }()

    lazy var torchSliderView: SliderView = {
        let view = SliderView(anchor: flashImageView)
        view.delegate = self
        return view
    }()

    lazy var rgbSliderView: RGBView = {
        let view = RGBView(anchor: settingsContainerView)
        view.delegate = self
        return view
    }()

    var previousTorchLevel: Float = 1
    var torchCanBeTapped = true

    var rgbTimer: Timer? = nil {
        willSet {
            rgbTimer?.invalidate()
        }
    }

    var hideTimer: Timer? = nil {
        willSet {
            hideTimer?.invalidate()
        }
    }

    // MARK: Cameras
    // Session
    let sessionQueue = DispatchQueue(label: "Session Queue")
    var sessionSetupSucceeds = false

    lazy var session = AVCaptureSession()
    lazy var previewView = UIView()
    lazy var previewLayer = AVCaptureVideoPreviewLayer(session: session)

    @objc dynamic var activeCamera: AVCaptureDevice?
    var allCameras: [AVCaptureDevice] = []
    var activeCamIndex: Int = 0
    var nextCamIndex: Int = 0
    var numberOfCams: Int {
        return allCameras.count
    }

    // Zoom
    var zoomScaleRange: ClosedRange<CGFloat> = 1...5
    var lastZoomFactor: CGFloat = 0

    let helpView = HelpView()

    deinit {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.removeObserver(self, forKeyPath: "activeCamera.ISO")
        NotificationCenter.default.removeObserver(self, forKeyPath: "activeCamera.deviceWhiteBalanceGains")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

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
        setupObservers()
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

    private func setupView() {
        setupCamera()
        setupSettings()
        setupHelpView()
        setupNameLabel()
        setupGestures()
    }

    private func setupCamera() {
        setupPreviewLayer()
        checkCameraStatus()
    }

    private func setupSettings() {
        setupSettingsView()
        setupButtonStackView()
        setupLongPress()
    }

    private func setupGestures() {
        setupTapGestures()
        setupSwipeGesture()
        setupPinchGesture()
    }
}
