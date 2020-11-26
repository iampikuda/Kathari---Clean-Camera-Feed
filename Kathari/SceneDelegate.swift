//
//  SceneDelegate.swift
//  BookReader
//
//  Created by Oluwadamisi Pikuda on 13/07/2020.
//  Copyright © 2020 Damisi Pikuda. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private(set) var appCoordinator: AppCoordinator!

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)

        appCoordinator = AppCoordinator(window: window)
        appCoordinator.startApp()

        self.window = window
        window.makeKeyAndVisible()
    }
}
