//
//  UIViewController+Utils.swift
//  Boiler
//
//  Created by Oluwadamisi Pikuda on 12/11/19.
//  Copyright © 2019 Pikuda. All rights reserved.
//

import UIKit

extension UIViewController {
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
}
