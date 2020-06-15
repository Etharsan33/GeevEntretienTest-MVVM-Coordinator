//
//  TabBarCoordinator.swift
//  GeevEntretienTest
//
//  Created by ELANKUMARAN Tharsan on 14/06/2020.
//  Copyright © 2020 ELANKUMARAN Tharsan. All rights reserved.
//

import UIKit

class TabBarCoordinator: BaseCoordinator {

    private var navigationController: UINavigationController?
    
    private let donationsCoordinator: DonationsCoordinator

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
        
        donationsCoordinator = DonationsCoordinator()
        donationsCoordinator.start()
    }
    
    override func start() {
        let tabBarController = TabBarController.instance
        
        let donationsViewController = donationsCoordinator.rootViewController
        donationsViewController.tabBarItem = UITabBarItem(title: GEEVLoc.Tab.TAB_DONATION.localized, image: #imageLiteral(resourceName: "tab_donation"), tag: 0)
        
        let creationVC = UIViewController()
        let creationNVC = UINavigationController(rootViewController: creationVC)
        creationNVC.tabBarItem = UITabBarItem(title: GEEVLoc.Tab.TAB_CREATION.localized, image: #imageLiteral(resourceName: "tab_creation"), tag: 1)
        
        let messagesVC = UIViewController()
        let messagesNVC = UINavigationController(rootViewController: messagesVC)
        messagesNVC.tabBarItem = UITabBarItem(title: GEEVLoc.Tab.TAB_MESSAGES.localized, image: #imageLiteral(resourceName: "tab_messages"), tag: 2)
        
        let profileVC = UIViewController()
        let profileNVC = UINavigationController(rootViewController: profileVC)
        profileNVC.tabBarItem = UITabBarItem(title: GEEVLoc.Tab.TAB_PROFILE.localized, image: #imageLiteral(resourceName: "tab_profil"), tag: 3)
        
        tabBarController.viewControllers = [donationsViewController, creationNVC, messagesNVC, profileNVC]
        
        navigationController?.pushViewController(tabBarController, animated: true)
    }
}
