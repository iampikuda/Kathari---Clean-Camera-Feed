//
//  SliderView.swift
//  Kathari
//
//  Created by Oluwadamisi Pikuda on 28/08/2020.
//  Copyright © 2020 Damisi Pikuda. All rights reserved.
//

import UIKit
import SnapKit
import TactileSlider

protocol WindowViewDelegate: class {
    func windowDismissed()
}

protocol SliderViewDelegate: WindowViewDelegate {
    func slider(_ slider: SliderView, changedTo value: Float)
}

final class SliderView: WindowView {
    weak var delegate: SliderViewDelegate?

    private let viewArea = UIView()
    private let sliderWidth: CGFloat = 80
    private let sliderHeight: CGFloat = 180
    private let slider = TactileSlider()

    var initialLevel: Float = 1

    override var height: CGFloat {
        return UIApplication.safeLayoutRect().height
            - anchoredRect.height
            - 10
    }

    private let anchorView: UIView
    private var anchoredRect: CGRect = .zero

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
                KHError(message: "SliderView may fail... no superview for anchorView"),
                errorMsg: "Having issues placing the slider view in a window view"
            )
        }
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

    func setMinMax(min: Float, max: Float) {
        self.slider.minimum = min
        self.slider.maximum = max
    }

    func setValue(_ value: Float) {
        slider.setValue(value, animated: true)
        initialLevel = value
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

    override func hide() {
        super.hide()
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.slider.frame.origin.y = self.sliderHeight
            },
            completion: { _ in
                self.removeFromSuperview()
                self.delegate?.windowDismissed()
            }
        )
    }

    @objc private func sliderSlid(_ slider: TactileSlider) {
        self.delegate?.slider(self, changedTo: slider.value)
    }
}
