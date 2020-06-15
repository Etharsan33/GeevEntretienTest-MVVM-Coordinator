//
//  DonationViewModel.swift
//  GeevEntretienTest
//
//  Created by ELANKUMARAN Tharsan on 14/06/2020.
//  Copyright © 2020 ELANKUMARAN Tharsan. All rights reserved.
//

import Foundation
import MapKit

class DonationViewModel {
    
    let id: String
    let title: String
    let distance: String?
    let duration: String
    let picture: String?
    let coordinate: CLLocationCoordinate2D
    
    init(donation: Donation) {
        self.id = donation.id
        self.title = donation.title
        self.distance = UserLocationManager.shared.getDistanceByUserLocation(donation.location)
        self.duration = Date(timeIntervalSince1970: donation.lastUpdateTimestamp).dateDuration()
        self.picture = donation.pictures.first
        self.coordinate = donation.location.coordinate
    }
}
