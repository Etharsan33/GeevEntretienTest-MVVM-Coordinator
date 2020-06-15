//
//  AppCoordinator.swift
//  GeevEntretienTest
//
//  Created by ELANKUMARAN Tharsan on 14/06/2020.
//  Copyright © 2020 ELANKUMARAN Tharsan. All rights reserved.
//

import UIKit

class AppCoordinator: BaseCoordinator {

    let window : UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    override func start() {
        
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true
        let tabBarCoordinator = TabBarCoordinator(navigationController: navigationController)
        
        self.store(coordinator: tabBarCoordinator)
        tabBarCoordinator.start()

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
