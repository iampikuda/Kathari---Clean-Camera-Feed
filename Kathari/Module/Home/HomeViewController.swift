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

    let hideLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .red
        label.backgroundColor = .red
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.9
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Text"
        return label
    }()

    let flashImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(imageName: .flash)?.withRenderingMode(.alwaysTemplate)
        imageView.clipsToBounds = true
        imageView.tintColor = .white
        return imageView
    }()

    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.spacing = 11
        return stackView
    }()

    let overlayView = UIView()

    var lastZoomFactor: CGFloat = 0

    // Camera
    lazy var session = AVCaptureSession()
    lazy var previewLayer = AVCaptureVideoPreviewLayer(session: session)
    var activeCamera: AVCaptureDevice?
    var zoomScaleRange: ClosedRange<CGFloat> = 1...10

    let sessionQueue = DispatchQueue(label: "Session Queue")

    // Torch
    lazy var torchView: TorchView = {
        let view = TorchView(anchor: flashImageView)
        view.delegate = self
        return view
    }()
    lazy var torchIsActiveObserver = NSKeyValueObservation()
    var previousTorchLevel: Float = 1

    var sessionSetupSucceeds = false

    var torchCanBeTapped = true

    override init(screenSize: CGSize = UIScreen.main.bounds.size) {

        super.init(screenSize: screenSize)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        setupCameraView()
        setupOverlay()
        setupSettingsView()
    }

    private func setupOverlay() {
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        overlayView.layer.cornerRadius = 5
        overlayView.isUserInteractionEnabled = true
        overlayView.isHidden = true
        // FIXME: change to black
        view.backgroundColor = .white
        view.addSubview(overlayView)
        overlayView.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.centerX.equalTo(view)
            make.width.equalTo(self.screenWidth * 0.98)
            make.height.equalTo(50)
        }

        overlayView.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { (make) in
            make.centerY.left.right.equalTo(overlayView)
            make.height.equalTo(overlayView).multipliedBy(0.8)
        }

        buttonStackView.addArrangedSubviews([flashImageView])
    }
}

extension HomeViewController: UIScrollViewDelegate {

}

extension HomeViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
}
