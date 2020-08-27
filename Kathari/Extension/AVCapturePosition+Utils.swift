//
//  AVCapturePosition+Utils.swift
//  Kathari
//
//  Created by Oluwadamisi Pikuda on 23/08/2020.
//  Copyright © 2020 Damisi Pikuda. All rights reserved.
//

import AVFoundation

extension AVCaptureDevice.Position {
    var flipped: AVCaptureDevice.Position {
        return self == .back ? .front : .back
    }
}
