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
import UserNotifications

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

    let wbImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(imageName: .whiteBalance)?.withRenderingMode(.alwaysTemplate)
        imageView.clipsToBounds = true
        imageView.tintColor = .white
        return imageView
    }()

    let rgbImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(imageName: .rgb)
        imageView.clipsToBounds = true
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

    let isoView = IsoContainer()

    let settingsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 11
        return stackView
    }()

    let camStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 11
        return stackView
    }()

    let settingsView = UIView()
    let availableCamView = UIView()

    var lastZoomFactor: CGFloat = 0

    // Camera
    lazy var session = AVCaptureSession()
    lazy var previewView = UIView()
    lazy var previewLayer = AVCaptureVideoPreviewLayer(session: session)
    @objc dynamic var activeCamera: AVCaptureDevice?
    var zoomScaleRange: ClosedRange<CGFloat> = 1...5

    let sessionQueue = DispatchQueue(label: "Session Queue")

    lazy var exposureView: SliderView = {
        let view = SliderView(anchor: isoView)
        view.delegate = self
        return view
    }()

    var autoIso = true

    // Torch
    lazy var torchView: SliderView = {
        let view = SliderView(anchor: flashImageView)
        view.delegate = self
        return view
    }()

    var previousTorchLevel: Float = 1
    var torchCanBeTapped = true

    let helpView = HelpView()

    var sessionSetupSucceeds = false

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        setupCameraView()
        setupSettingsView()
        setupHelpView()

        // FIXME: change to black
        view.backgroundColor = .white
    }

    private func setupHelpView() {
        view.addSubview(helpView)
        helpView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(view)
            make.bottom.equalTo(settingsView.snp.top)
        }

//        helpView.isHidden = true
    }
}

extension HomeViewController: UIScrollViewDelegate {

}

extension HomeViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
}
