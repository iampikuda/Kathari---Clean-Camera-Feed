//
//  Data+Utils.swift
//  Boiler
//
//  Created by Oluwadamisi Pikuda on 09/02/2020.
//  Copyright © 2020 Pikuda. All rights reserved.
//

import Foundation

extension Data {
    var asJsonString: String? {
        if let dict = try? JSONSerialization.jsonObject(with: self, options: []) as? [String: Any] {
            return dict.asJsonString
        }

        return nil
    }
}
