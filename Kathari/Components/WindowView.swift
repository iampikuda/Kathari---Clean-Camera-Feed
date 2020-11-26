//
//  WindowView.swift
//  Kathari
//
//  Created by Oluwadamisi Pikuda on 23/08/2020.
//  Copyright © 2020 Damisi Pikuda. All rights reserved.
//

import UIKit
import SnapKit

class WindowView: UIView {
    let backgroundView: UIView = {
        let view  = UIView()
        view.backgroundColor = .clear
        return view
    }()

    var cordX: CGFloat {
        return UIApplication.safeLayoutRect().origin.x
    }

    var cordY: CGFloat {
        return UIApplication.safeLayoutRect().origin.y
    }

    var width: CGFloat {
        return UIApplication.safeLayoutRect().width
    }

    var height: CGFloat {
        return UIApplication.safeLayoutRect().height
    }

    private(set) var currentOrientation: UIInterfaceOrientation?

    private(set) var isShowing = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        commoninit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commoninit()
    }

    func commoninit() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        backgroundView.addGestureRecognizer(tapGesture)
        backgroundColor = UIColor.clear
        clipsToBounds = true
    }

    func transformOrientation(interfaceOrientation: UIInterfaceOrientation) {
        guard isShowing,
            currentOrientation != interfaceOrientation,
            interfaceOrientation != .portraitUpsideDown else {
                if currentOrientation == nil {
                    currentOrientation = interfaceOrientation
                }
                return
        }

        currentOrientation = interfaceOrientation
        show()
    }

    @objc private func backgroundTapped() {
        hide()
    }

    func setupViews() {
        setFrame()
        setupBackgrounView()
        addToWindow()
    }

    func setupBackgrounView() {
        addSubview(backgroundView)
        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }

        self.sendSubviewToBack(backgroundView)
    }

    private func setFrame() {
        self.frame = CGRect(
            x: cordX,
            y: cordY,
            width: width,
            height: height
        )
    }

    private func addToWindow() {
        let visibleWindow = window != nil ? window : UIApplication.visibleWindow()
        visibleWindow?.addSubview(self)
        visibleWindow?.bringSubviewToFront(self)
    }

    func show() {
        setupViews()
        isShowing = true
        self.layoutIfNeeded()
    }

    func hide() {
        isShowing = false
    }
}
