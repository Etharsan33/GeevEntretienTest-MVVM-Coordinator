//
//  DonationDetailViewModel.swift
//  GeevEntretienTest
//
//  Created by ELANKUMARAN Tharsan on 14/06/2020.
//  Copyright © 2020 ELANKUMARAN Tharsan. All rights reserved.
//

import RxRelay
import RxSwift

class DonationDetailViewModel {
    
    private let id: String
    
    private let worker = DonationsWorker()
    let isLoading = BehaviorSubject<Bool>(value: false)
    let donationFullViewModel: BehaviorRelay<DonationPresentationFullViewModel?> = .init(value: nil)
    
    var onCommitPopBack: (()->())?
    
    init(id: String) {
        self.id = id
    }
    
    // MARK: - Network Call
    func getDonation(onError: @escaping (Error) ->()) {
        
        self.isLoading.onNext(true)
        
        DonationDetailWorker().getDonation(id: self.id, completion: { [weak self] result in
            self?.isLoading.onNext(false)
            
            switch result {
                case .success(let donation):
                    self?.donationFullViewModel.accept(DonationPresentationFullViewModel(donation: donation))
                case .failure(let error):
                    onError(error)
            }
        })
    }
}
