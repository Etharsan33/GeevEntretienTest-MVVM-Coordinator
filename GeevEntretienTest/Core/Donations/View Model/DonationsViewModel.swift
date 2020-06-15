//
//  DonationsViewModel.swift
//  GeevEntretienTest
//
//  Created by ELANKUMARAN Tharsan on 14/06/2020.
//  Copyright © 2020 ELANKUMARAN Tharsan. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay
import RxDataSources
import MapKit

class DonationsViewModel {
    
    private let worker = DonationsWorker()
    let isLoading = BehaviorSubject<Bool>(value: false)
    
    var donations: BehaviorRelay<[SectionData]> = .init(value: [])
    
    typealias DataSource = RxCollectionViewSectionedReloadDataSource<SectionData>
    struct SectionData: SectionModelType {
        typealias Item = DonationViewModel
        var items: [Item]
        
        init(items: [DonationViewModel]) {
            self.items = items
        }
        
        init(original: DonationsViewModel.SectionData, items: [DonationViewModel]) {
            self = original
            self.items = items
        }
    }

    class DonationAnnotation: MKPointAnnotation {
        var id: String!
    }
    
    var onCommitSelectDonation: ((_ id: String) -> ())?
    
    // MARK: - Network Call
    func getDonations(keywords: String?, onError: @escaping (Error) -> ()) {
        
        self.isLoading.onNext(true)
        
        DonationsWorker().getDonations(keywords: keywords) { [weak self] result in
            self?.isLoading.onNext(false)
            
            switch result {
                case .success(let panigatedDonation):
                    let donationViewModels = panigatedDonation.content.map { DonationViewModel(donation: $0) }
                    self?.donations.accept([SectionData(items: donationViewModels)])
                case .failure(let error):
                    onError(error)
            }
        }
    }
    
    // MARK: - MapAnnotation
    func configureMapAnnotations(mapView: MKMapView, donations: [DonationViewModel]) {
        mapView.removeAnnotations(mapView.annotations)
        
        let annotations = donations.map { donation -> MKPointAnnotation in
            let annotation = DonationAnnotation()
            annotation.id = donation.id
            annotation.title = donation.title
            annotation.coordinate = donation.coordinate
            return annotation
        }
        
        mapView.addAnnotations(annotations)
        mapView.showAnnotations(mapView.annotations, animated: false)
    }
}
