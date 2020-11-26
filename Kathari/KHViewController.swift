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
        self.view.backgroundColor = .black
    }
}
