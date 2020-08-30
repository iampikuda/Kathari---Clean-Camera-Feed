//
//  KHViewController.swift
//  Boiler
//
//  Created by Oluwadamisi Pikuda on 25/06/2020.
//  Copyright © 2020 Damisi Pikuda. All rights reserved.
//

import UIKit

class KHViewController: UIViewController {

    final var screenPortraitHeight: CGFloat {
        return max(UIScreen.main.bounds.height, UIScreen.main.bounds.width)
    }

    final var screenPortraitWidth: CGFloat {
        return min(UIScreen.main.bounds.height, UIScreen.main.bounds.width)
    }

    final var statusBarPlusNavBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
        } else {
            return UIApplication.shared.statusBarFrame.size.height +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
        }

    }

    var hideStatusBar: Bool = true {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }

    override var prefersStatusBarHidden: Bool {
        return hideStatusBar
    }

    let screenSize: CGSize

    init(screenSize: CGSize = UIScreen.main.bounds.size) {
        self.screenSize = screenSize
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        clearBackButtonTitle()
    }
}
