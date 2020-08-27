//
//  TorchView.swift
//  Kathari
//
//  Created by Oluwadamisi Pikuda on 23/08/2020.
//  Copyright © 2020 Damisi Pikuda. All rights reserved.
//

import UIKit
import SnapKit
import TactileSlider
import AVFoundation

protocol TorchViewDelegate: class {
    func sliderValueChanged(to value: Float)
}

final class TorchView: WindowView {

    weak var delegate: TorchViewDelegate?

    private let viewArea = UIView()
    private let sliderWidth: CGFloat = 80
    private let sliderHeight: CGFloat = 180
    private let slider = TactileSlider()

    var initialLevel: Float = 1

    private let anchoredRect: CGRect

    init(anchor: UIView) {
        if let rect = anchor.superview?.convert(anchor.frame, to: UIApplication.visibleWindow()) {
            self.anchoredRect = rect
        } else {
            self.anchoredRect = anchor.convert(anchor.frame, to: UIApplication.visibleWindow())
            Helper.logError(KHError(message: "Dropdown may fail... no superview for anchorView"))
        }

        super.init(frame: .zero)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupViews() {
        super.setupViews()
        setupSlider()
    }

    private func setupSlider() {
        addSubview(viewArea)
        viewArea.clipsToBounds = true
        viewArea.addSubview(slider)
        slider.cornerRadius = 15
        slider.vertical = true
        slider.setValue(0, animated: true)
        slider.trackBackground = UIColor.black.withAlphaComponent(0.8)
        slider.tintColor = .gold

        slider.addTarget(self, action: #selector(sliderSlid(_:)), for: .valueChanged)

//        if let device = AVCaptureDevice.default(for: .video) {
//            print(device.torchLevel)
//            device.observe(\.isTorchActive, options: .) { (device, value) in
//                print("#####")
//                print(value)
//                print(device.torchLevel)
//                print("#####")
//            }
//            slider.setValue(device.torchLevel, animated: true)
//        }

        viewArea.frame = CGRect(
            x: anchoredRect.midX - (sliderWidth / 2),
            y: anchoredRect.origin.y - sliderHeight - cordY - 8,
            width: sliderWidth,
            height: sliderHeight
        )

        slider.frame = CGRect(
            x: 0,
            y: sliderHeight,
            width: sliderWidth,
            height: sliderHeight
        )
    }

    override func show() {
        super.show()

        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseIn,
            animations: {
                self.slider.frame.origin.y = 0
            },
            completion: { _ in
                self.slider.setValue(self.initialLevel, animated: true)
            }
        )
    }

    override func hide(in seconds: TimeInterval = 0.2) {
        super.hide(in: seconds)
        UIView.animate(
            withDuration: seconds,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.slider.frame.origin.y = self.sliderHeight
            },
            completion: { _ in
                self.removeFromSuperview()
            }
        )
    }

    @objc private func sliderSlid(_ slider: TactileSlider) {
        self.delegate?.sliderValueChanged(to: slider.value.roundTo(1))
    }
}
