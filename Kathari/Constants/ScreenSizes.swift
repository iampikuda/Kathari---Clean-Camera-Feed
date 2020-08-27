//
//  ScreenSizes.swift
//  Boiler
//
//  Created by Pk
//  Copyright © 2019 WAVE Meditation. All rights reserved.
//

import UIKit

struct Screen {
    /// Width: 320 Height: 568
    static let iSiPhoneSe: CGSize = CGSize(width: 320, height: 568)

    /// Width: 375 Height: 667
    static let iSStandard: CGSize = CGSize(width: 375, height: 667)

    /// Width: 375 Height: 812
    static let iSiPhoneX: CGSize = CGSize(width: 375, height: 812)

    /// Width: 414 Height: 896
    static let iSiPhoneMax: CGSize = CGSize(width: 414, height: 896)

    /// Width: 414 Height: 896
    static let iSiPhone11: CGSize = CGSize(width: 414, height: 896)

    static var isSmall: Bool {
        return UIScreen.main.bounds.height < 667
    }
}
