//
//  DonationDetailCoordinator.swift
//  GeevEntretienTest
//
//  Created by ELANKUMARAN Tharsan on 14/06/2020.
//  Copyright © 2020 ELANKUMARAN Tharsan. All rights reserved.
//

import UIKit

class DonationDetailCoordinator: BaseCoordinator {
    
    private var navigationController: UINavigationController?
    private var donationID: String

    init(navigationController: UINavigationController?, donationID: String) {
        self.navigationController = navigationController
        self.donationID = donationID
    }
    
    override func start() {
        let donationDetail = DonationDetailViewController.instance
        let viewModel = DonationDetailViewModel(id: self.donationID)
        viewModel.onCommitPopBack = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        donationDetail.viewModel = viewModel
        
        self.navigationController?.pushViewController(donationDetail, animated: true)
    }
}
