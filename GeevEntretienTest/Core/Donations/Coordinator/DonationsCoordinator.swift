//
//  DonationsCoordinator.swift
//  GeevEntretienTest
//
//  Created by ELANKUMARAN Tharsan on 14/06/2020.
//  Copyright © 2020 ELANKUMARAN Tharsan. All rights reserved.
//

import UIKit

class DonationsCoordinator : BaseCoordinator {

    var navigationController: UINavigationController
    private var donationViewController: DonationsViewController

    override init() {
        self.donationViewController = DonationsViewController.instance
        self.navigationController = UINavigationController(rootViewController: self.donationViewController)
        super.init()
    }
    
    override func start() {
        self.donationViewController.title = GEEVLoc.Tab.TAB_DONATION.localized
        let viewModel = DonationsViewModel()
        viewModel.onCommitSelectDonation = { [weak self] donationID in
            self?.coordinateToDonationDetail(with: donationID)
        }
        self.donationViewController.viewModel = viewModel
    }
    
    public var rootViewController: UIViewController {
        return navigationController
    }
    
    // MARK: - Coordination
    private func coordinateToDonationDetail(with donationID: String) {
        let donationDetailCoordinator = DonationDetailCoordinator(navigationController: self.navigationController,
                                                                  donationID: donationID)
        donationDetailCoordinator.start()
    }
}
