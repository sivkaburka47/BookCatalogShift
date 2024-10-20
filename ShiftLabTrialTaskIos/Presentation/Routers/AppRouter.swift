//
//  AppRouter.swift
//  ShiftLabTrialTaskIos
//
//  Created by Станислав Дейнекин on 19.10.2024.
//

import UIKit

class AppRouter {
    
    private var window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let signUpViewController = SignUpViewController()
        let navigationController = UINavigationController(rootViewController: signUpViewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func navigateToMain() {
        let mainViewController = MainViewController()
        if let navigationController = window.rootViewController as? UINavigationController {
            navigationController.pushViewController(mainViewController, animated: true)
        } else {
            let navigationController = UINavigationController(rootViewController: mainViewController)
            window.rootViewController = navigationController
        }
    }
}
