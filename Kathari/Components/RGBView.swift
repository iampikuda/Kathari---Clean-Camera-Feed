//
//  RGBView.swift
//  Kathari
//
//  Created by Oluwadamisi Pikuda on 05/09/2020.
//  Copyright © 2020 Damisi Pikuda. All rights reserved.
//

import UIKit
import SnapKit
import TactileSlider

protocol RGBDelegate: WindowViewDelegate {
    func slider(_ rgb: RGB, changedTo value: Float)
}

enum RGB {
    case red, green, blue
}

final class RGBView: WindowView {
    weak var delegate: RGBDelegate?

    private let viewArea = UIView()

    private let sliderWidth: CGFloat = 80
    private let sliderHeight: CGFloat = 180

    private let rSlider = TactileSlider()
    private let gSlider = TactileSlider()
    private let bSlider = TactileSlider()

    private let rLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.9
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = ""
        return label
    }()

    private let gLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.9
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = ""
        return label
    }()

    private let bLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.9
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = ""
        return label
    }()

    var rLevel: Float = 1 {
        didSet {
            self.rLabel.text = String(format: "%.3f", rLevel)
        }
    }

    var gLevel: Float = 1 {
        didSet {
            self.gLabel.text = String(format: "%.3f", gLevel)
        }
    }

    var bLevel: Float = 1 {
        didSet {
            self.bLabel.text = String(format: "%.3f", bLevel)
        }
    }

    override var height: CGFloat {
        return UIApplication.safeLayoutRect().height
            - anchoredRect.height
            - 10
    }

    private let anchorView: UIView
    private var anchoredRect: CGRect = .zero

    private let rgbStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        return stackView
    }()

    init(anchor: UIView) {
        self.anchorView = anchor
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupViews() {
        setupAnchorRect()
        super.setupViews()
        setupSlider()
    }

    private func setupAnchorRect() {
        if let rect = anchorView.superview?.convert(anchorView.frame, to: UIApplication.visibleWindow()) {
            self.anchoredRect = rect
        } else {
            self.anchoredRect = anchorView.convert(anchorView.frame, to: UIApplication.visibleWindow())
            Helper.logError(
                KHError(message: "RGBView may fail... no superview for anchorView"),
                errorMsg: "Having issues placing the RGB View in a window view"
            )
        }
    }

    private func configureSlider(_ rgb: RGB, slider: TactileSlider) {
        slider.cornerRadius = 15
        slider.vertical = true
        slider.setValue(0, animated: true)
        slider.trackBackground = UIColor.black.withAlphaComponent(0.8)

        switch rgb {
        case .red:
            slider.addSubview(rLabel)
            rLabel.snp.makeConstraints { (make) in
                make.left.bottom.right.equalTo(slider)
                make.height.equalTo(30)
            }
        case .green:
            slider.addSubview(gLabel)
            gLabel.snp.makeConstraints { (make) in
                make.left.bottom.right.equalTo(slider)
                make.height.equalTo(30)
            }
        case .blue:
            slider.addSubview(bLabel)
            bLabel.snp.makeConstraints { (make) in
                make.left.bottom.right.equalTo(slider)
                make.height.equalTo(30)
            }
        }
    }

    private func setupSlider() {
        addSubview(viewArea)
        viewArea.clipsToBounds = true
        viewArea.addSubview(rgbStackView)
        rgbStackView.addArrangedSubviews([rSlider, gSlider, bSlider])

        configureSlider(.red, slider: rSlider)
        configureSlider(.green, slider: gSlider)
        configureSlider(.blue, slider: bSlider)

        rSlider.tintColor = .red
        gSlider.tintColor = .green
        bSlider.tintColor = .blue

        rSlider.addTarget(self, action: #selector(rSliderSlid(_:)), for: .valueChanged)
        gSlider.addTarget(self, action: #selector(gSliderSlid(_:)), for: .valueChanged)
        bSlider.addTarget(self, action: #selector(bSliderSlid(_:)), for: .valueChanged)
        let stackViewWidth = sliderWidth * 3 + 10

        viewArea.frame = CGRect(
            x: anchoredRect.midX - (stackViewWidth / 2),
            y: anchoredRect.origin.y - sliderHeight - cordY - 8,
            width: anchoredRect.width,
            height: sliderHeight
        )

        rgbStackView.frame = CGRect(
            x: 0,
            y: sliderHeight,
            width: stackViewWidth,
            height: sliderHeight
        )
    }

    func setMinMax(min: Float, max: Float) {
        self.rSlider.minimum = min
        self.rSlider.maximum = max

        self.gSlider.minimum = min
        self.gSlider.maximum = max

        self.bSlider.minimum = min
        self.bSlider.maximum = max
    }

    func setSlider(_ rgb: RGB, value: Float) {
        switch rgb {
        case .red:
            self.rSlider.setValue(value, animated: true)
            self.rLevel = value
        case .green:
            self.gSlider.setValue(value, animated: true)
            self.gLevel = value
        case .blue:
            self.bSlider.setValue(value, animated: true)
            self.bLevel = value
        }
    }

    override func show() {
        super.show()

        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseIn,
            animations: {
                self.rgbStackView.frame.origin.y = 0
            },
            completion: { _ in
                self.rSlider.setValue(self.rLevel, animated: true)
                self.gSlider.setValue(self.gLevel, animated: true)
                self.bSlider.setValue(self.bLevel, animated: true)
            }
        )
    }

    override func hide() {
        super.hide()
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.rgbStackView.frame.origin.y = self.sliderHeight
            },
            completion: { _ in
                self.removeFromSuperview()
                self.delegate?.windowDismissed()
            }
        )
    }

    @objc private func rSliderSlid(_ slider: TactileSlider) {
        rLabel.text = String(format: "%.3f", slider.value)
        self.delegate?.slider(.red, changedTo: slider.value)
    }

    @objc private func gSliderSlid(_ slider: TactileSlider) {
        gLabel.text = String(format: "%.3f", slider.value)
        self.delegate?.slider(.green, changedTo: slider.value)
    }

    @objc private func bSliderSlid(_ slider: TactileSlider) {
        bLabel.text = String(format: "%.3f", slider.value)
        self.delegate?.slider(.blue, changedTo: slider.value)
    }
}
