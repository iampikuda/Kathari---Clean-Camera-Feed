//
//  UIViewController+Utils.swift
//  Boiler
//
//  Created by Oluwadamisi Pikuda on 12/11/19.
//  Copyright © 2019 Pikuda. All rights reserved.
//

import UIKit

extension UIViewController {

    func dismissKeyboardOn(_ targets: [UIView]) {
        for target in targets {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            tapGesture.cancelsTouchesInView = false
            target.isUserInteractionEnabled = true
            target.addGestureRecognizer(tapGesture)
        }
    }

    func addFunctionTo(_ function: Selector, view: UIView) {
        let tapGesture = UITapGestureRecognizer(target: self, action: function)
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard(gestureRecognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    @objc func showAlertWithOkAction(
        title: String,
        message: String,
        addCancel: Bool = false,
        completion: ((UIAlertAction) -> Void)? = nil
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        var handler: ((UIAlertAction) -> Void)?

        if let completion = completion {
            handler = completion
        }

        let action  = UIAlertAction(
            title: "OK",
            style: .default,
            handler: handler)

        alert.addAction(action)

        if addCancel {
            let cancelAction  = UIAlertAction(
                title: "Cancel",
                style: .cancel,
                handler: nil)

            alert.addAction(cancelAction)
        }

        self.present(alert, animated: true, completion: nil)
    }

    func showErrorAlertFor(errorMessage: String) {
        showAlertWithOkAction(
            title: "ERROR",
            message: errorMessage
        )
    }

    func clearBackButtonTitle() {
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: " ",
            style: .plain,
            target: nil,
            action: nil
        )
    }

    func configureNavigationHeader(
        transparency: Bool,
        barTintColor: UIColor?,
        titleTextColor: UIColor?,
        navItemsColor: UIColor?
    ) {

        let navBar = navigationController?.navigationBar
        navBar?.setTransparent(to: transparency)
        navBar?.barTintColor = barTintColor

        if let titleColor = titleTextColor {
            navBar?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: titleColor]
        }

        if let itemColor = navItemsColor {
            navBar?.tintColor = itemColor
        }
    }

    func configureNavBarWithWhiteText() {
        let navBar = navigationController?.navigationBar
        navBar?.setTransparent(to: false)
        navBar?.barTintColor = UIColor.black.withAlphaComponent(0.2)
        navBar?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navBar?.tintColor = UIColor.white
    }

    func configureTransparentNavBarWithWhiteText() {
        let navBar = navigationController?.navigationBar
        navBar?.setTransparent(to: true)
        navBar?.barTintColor = UIColor.black
        navBar?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navBar?.tintColor = UIColor.white
    }

    func configureTransparentNavBarWithBlackText() {
        let navBar = navigationController?.navigationBar
        navBar?.setTransparent(to: true)
        navBar?.barTintColor = UIColor.black
        navBar?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navBar?.tintColor = UIColor.black
    }

//    func configureBackButtonColor(_ color: UIColor) {
//        navigationItem.leftBarButtonItem = UIBarButtonItem.makeButton(
//            self,
//            action: #selector(pop),
//            imageName: .empty,
//            imageColor: .lightGray
//        )
//    }

    @objc private func pop() {
        navigationController?.popViewController(animated: true)
    }

    func dismissWithAnimation(completion: (() -> Void)? = nil) {
        guard let window = self.view.window else {
            dismiss(animated: true, completion: nil)
            return
        }

        let transition: CATransition = CATransition()
        transition.duration = 0.4
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromBottom
        window.layer.add(transition, forKey: nil)

        dismiss(animated: false, completion: completion)
    }

//    func showActivityIndicator(disableUserInteraction: Bool = true, backgroundColor: UIColor? = nil) {
//        // Prevent multiple activity indicators from being added to the view
//        if let currentIndicator = view.viewWithTag(UIConstants.activityIndicatorTag.rawValue.asInt) {
//            if let backgroundColor = backgroundColor {
//                currentIndicator.backgroundColor = backgroundColor
//            }
//
//            return
//        }
//
////        if let nav = self.navigationController as? CdVNavigationController {
////            nav.showNavOverlay()
////        }
//
//        let activityIndicator = CdVActivityIndicatorView()
//        activityIndicator.tag = UIConstants.activityIndicatorTag.rawValue.asInt
//        self.view.addSubview(activityIndicator)
//
//        if let backgroundColor = backgroundColor {
//            activityIndicator.backgroundColor = backgroundColor
//        }
//
//        activityIndicator.snp.makeConstraints { make in
//            make.height.width.equalToSuperview()
//            make.centerX.centerY.equalToSuperview()
//        }
//
//        activityIndicator.startAnimating()
//        activityIndicator.isUserInteractionEnabled = disableUserInteraction
//        self.view.isUserInteractionEnabled = !disableUserInteraction
//    }
//
//    func hideActivityIndicator() {
//        view.isUserInteractionEnabled = true
//
////        if let nav = self.navigationController as? CdVNavigationController {
////            nav.hideNavOverlay()
////        }
//
//        if let activityIndicator = view.viewWithTag(UIConstants.activityIndicatorTag.rawValue.asInt) {
//            activityIndicator.removeFromSuperview()
//        }
//    }

    func removeChildViewController(_ vc: UIViewController) {
        vc.willMove(toParent: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParent()
    }

    var navigationBarHeight: CGFloat {
        return self.navigationController?.navigationBar.frame.size.height ?? 0.0
    }

    func performUIUpdate(using closure: @escaping () -> Void) {
        // If we are already on the main thread, execute the closure directly
        if Thread.isMainThread {
            closure()
        } else {
            DispatchQueue.main.async(execute: closure)
        }
    }
}
