//
//  DonationPresentationFullViewModel.swift
//  GeevEntretienTest
//
//  Created by ELANKUMARAN Tharsan on 14/06/2020.
//  Copyright © 2020 ELANKUMARAN Tharsan. All rights reserved.
//

import Foundation

class DonationPresentationFullViewModel {
    
    let id: String
    let type: String
    let category: String?
    let title: String
    let description: String?
    let distance: String?
    let duration: String
    let pictures: [String]
    let location: Location
    let authorFullName: String
    let authorPicture: String?
    
    init(donation: Donation) {
        self.id = donation.id
        self.type = donation.type
        self.category = donation.category
        self.title = donation.title
        self.description = donation.description
        self.distance = UserLocationManager.shared.getDistanceByUserLocation(donation.location)
        self.duration = Date(timeIntervalSince1970: donation.lastUpdateTimestamp).dateDuration()
        self.pictures = donation.pictures
        self.location = donation.location
        self.authorFullName = donation.author.fullname
        self.authorPicture = donation.author.picture
    }
}
