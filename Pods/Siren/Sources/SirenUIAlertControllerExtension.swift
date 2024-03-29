//
//  SirenUIAlertControllerExtension.swift
//  SirenExample
//
//  Created by Arthur Sabintsev on 3/17/17.
//  Copyright © 2017 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

// MARK: - UIAlertController Extension for Siren

internal extension UIAlertController {
    @objc func show() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = SirenViewController()
        window.windowLevel = UIWindow.Level.alert + 1

        Siren.shared.updaterWindow = window

        window.makeKeyAndVisible()
        window.rootViewController!.present(self, animated: true, completion: nil)
    }
}
