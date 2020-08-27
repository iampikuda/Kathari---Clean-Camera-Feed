//
//  AppCoordinator.swift
//  Boiler
//
//  Created by Oluwadamisi Pikuda on 24/06/2020.
//  Copyright © 2020 Damisi Pikuda. All rights reserved.
//

import UIKit
//import RealmSwift
//import SwiftyUserDefaults

final class AppCoordinator {

    let window: UIWindow

//    var user: User?

//    var realmInstance: Realm {
//        // swiftlint:disable:next force_try
//        return try! Realm()
//    }

    init(window: UIWindow) {
        self.window = window
    }

    final func setUserIfPossible() {
//        if let currentUser = UserDataService.getAll(from: realmInstance).first {
//            self.user = currentUser
//            if currentUser.hasToken {
//            } else {
//                showLogin()
//            }
//        } else {
            showLogin()
//        }
    }

    final func logOutUser() {
        self.nukeRealm()
        // FIXME: We probably don't want to remove everything
//        Defaults.removeAll()

        setUserIfPossible()
    }

    private final func nukeRealm() {
        // swiftlint:disable:next force_try
//        try! realmInstance.safeWrite {
//            realmInstance.deleteAll()
//        }

//        self.user = nil
    }

    final func startApp() {
        self.setUserIfPossible()
    }

    private func showLogin() {
//        let vm = LoginViewModel()
//        let vc = AuthViewController()
//
//        let navController = UINavigationController(rootViewController: vc)
//

        self.window.rootViewController = HomeViewController()
    }


//    private final func showHomeController() {
//        let vm = HomeViewModel()
//        let vc = HomeViewController(viewModel: vm)
//        navigationController.setViewControllers([vc], animated: true)
//    }
}
