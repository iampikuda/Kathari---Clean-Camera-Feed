//
//  Helper.swift
//  Boiler
//
//  Created by Oluwadamisi Pikuda on 09/02/2020.
//  Copyright © 2020 Pikuda. All rights reserved.
//

import Foundation
import Sentry

final class Helper {

    /// Logs error to debug log and Analytics
    static func logError(
        _ error: Error,
        errorMsg: String,
        filename: String = #file,
        line: Int = #line,
        funcName: String = #function
    ) {
        let logString = "🚨 ERROR: \(error.localizedDescription)\n" +
            "⭐️ File: \(filename)" +
            "⭐️ Line: \(line)" +
        "⭐️ Function: \(funcName)"

        print(logString)

        self.logSentryEvent(
            error: error,
            errorMsg: errorMsg,
            properties: [
                "File": filename,
                "Line": line,
                "Function": funcName
            ]
        )
    }

    private static func logSentryEvent(
        error: Error,
        errorMsg: String?,
        properties: [String: Any]
    ) {
        let event = Event(level: .error)
        event.message = SentryMessage(formatted: errorMsg ?? "App.Error")
        event.environment = Bundle.main.bundleIdentifier
        event.extra = properties as [String: Any]
        SentrySDK.capture(event: event)
    }
}

struct KHError: Error, LocalizedError {
    var errorDescription: String? {
        return NSLocalizedString(message, comment: "")
    }

    let message: String
}
