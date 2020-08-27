//
//  Dictionary+Utils.swift
//  Boiler
//
//  Created by Oluwadamisi Pikuda on 09/02/2020.
//  Copyright © 2020 Pikuda. All rights reserved.
//

import Foundation

extension Dictionary {

    /// Ported from SwiftDebugLog
    /// https://github.com/dtroupe18/SwiftDebugLog/
    var asJsonString: String {
        let invalidJson = "invalid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }
}
