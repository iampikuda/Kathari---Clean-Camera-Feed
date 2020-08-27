//
//  Helper.swift
//  Boiler
//
//  Created by Oluwadamisi Pikuda on 09/02/2020.
//  Copyright © 2020 Pikuda. All rights reserved.
//

import Foundation

final class Helper {

    /// Logs error to debug log and Analytics
    static func logError(
        _ error: Error,
        filename: String = #file,
        line: Int = #line,
        funcName: String = #function
    ) {
        let logString = "🚨 ERROR: \(error.localizedDescription)\n" +
            "⭐️ File: \(filename)" +
            "⭐️ Line: \(line)" +
        "⭐️ Function: \(funcName)"

        print(logString)
    }
}

struct KHError: Error, LocalizedError {
    var errorDescription: String? {
        return NSLocalizedString(message, comment: "")
    }

    let message: String
}
