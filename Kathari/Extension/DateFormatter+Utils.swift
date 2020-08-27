//
//  DateFormatter+Utils.swift
//  Boiler
//
//  Created by Oluwadamisi Pikuda on 01/03/2020.
//  Copyright © 2020 Pikuda. All rights reserved.
//

import Foundation

extension DateFormatter {
    static let apiDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
