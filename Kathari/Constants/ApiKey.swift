//
//  ApiKey.swift
//  Kathari
//
//  Created by Oluwadamisi Pikuda on 26/11/2020.
//  Copyright © 2020 Damisi Pikuda. All rights reserved.
//

import Foundation

enum ApiKey: String, CaseIterable {
    case sentryDSN = "SENTRY_DSN"

    var stringValue: String {
        // swiftlint:disable:next force_unwrapping force_cast
        return Bundle.main.infoDictionary![self.rawValue] as! String
    }
}
