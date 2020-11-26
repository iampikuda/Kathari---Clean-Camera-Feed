//
//  AppCoordinator.swift
//  Boiler
//
//  Created by Oluwadamisi Pikuda on 24/06/2020.
//  Copyright © 2020 Damisi Pikuda. All rights reserved.
//

import UIKit
import Sentry

final class AppCoordinator {

    let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    final func startApp() {
        self.window.rootViewController = HomeViewController()
        setupSentry()
    }

    func setupSentry() {
        SentrySDK.start { options in
            options.dsn = ApiKey.sentryDSN.stringValue
            options.debug = true
            #if DEBUG
            options.environment = "Debug"
            #else
            options.environment = "Production"
            #endif
        }

        SentrySDK.configureScope { scope in
            scope.setTag(value: UIDevice.current.identifierForVendor?.uuidString ?? "No Device ID", key: "device_id")
            #if DEBUG
            scope.setTag(value: "Debug app", key: "Kathari version")
            #else
            scope.setTag(value: "Production app", key: "Kathari version")
            #endif
        }
    }
}
