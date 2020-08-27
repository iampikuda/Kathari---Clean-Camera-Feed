//
//  String+Utils.swift
//  Boiler
//
//  Created by Oluwadamisi Pikuda on 12/11/19.
//  Copyright © 2019 Pikuda. All rights reserved.
//

import Foundation

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    /// Check if a string is all white-space or empty
    var isBlank: Bool {
        let trimmed = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return trimmed.isEmpty
    }

    var replaceNewlinesWithWhiteSpace: String {
        return components(separatedBy: .newlines).joined(separator: " ")
    }

    var removingAllWhitespacesAndNewlines: String {
        return filter { !$0.isNewline && !$0.isWhitespace }
    }

    var wordCount: Int {
        var wordCount: Int = 0
        self.enumerateSubstrings(in: self.startIndex..., options: .byWords) { _, _, _, _ in
            wordCount += 1
        }

        return wordCount
    }

    func toData() -> Data? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return data
    }

//    func toCdVError() throws -> CdVError? {
//        do {
//            guard let stringData = self.toData() else { return nil }
//
//            return try JSONDecoder().decode(CdVError.self, from: stringData)
//
//        } catch let error {
//            print("👀 Error is not CdVError - \(self)")
//            Helper.logError(error)
//            return nil
//        }
//    }

    func stringByAddingPercentEncoding() -> String? {
        let unreserved = "-._~/?"
        let allowed = NSMutableCharacterSet.alphanumeric()
        allowed.addCharacters(in: unreserved)
        return addingPercentEncoding(withAllowedCharacters: allowed as CharacterSet)
    }
}
