//
//  DonationDetailViewController.swift
//  GeevEntretienTest
//
//  Created by ELANKUMARAN Tharsan on 13/06/2020.
//  Copyright © 2020 ELANKUMARAN Tharsan. All rights reserved.
//

import UIKit
import MapKit
import RxSwift
import RxRelay

class DonationDetailViewController: BaseViewController, UIScrollViewDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var imagesScrollView: UIScrollView!
    @IBOutlet weak var imageStackView: UIStackView!
    @IBOutlet weak var imagesPageControl: UIPageControl!
    @IBOutlet weak var adTypeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var productStateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    
    var viewModel: DonationDetailViewModel!
    private let disposeBag = DisposeBag()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagesPageControl.currentPageIndicatorTintColor = .donationColor
        
        self.imagesScrollView.delegate = self
        self.userImageView.setCornerRadius(userImageView.frame.height / 2)
        self.mapView.delegate = self
        
        self.observeLoading()
        self.observeDonation()
        
        // Get Donation
        self.viewModel.getDonation { [weak self] error in
            self?.showAlert(title: GEEVLoc.Error.ERROR_DEFAULT_TILE.localized, message: error.localizedDescription, buttons: nil, highlightedButtonIndex: nil, completion: { _ in
                self?.viewModel.onCommitPopBack?()
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.transparent()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.transparent(false)
    }
}

// MARK: - Rx
extension DonationDetailViewController {
    
    private func observeLoading() {
        self.viewModel.isLoading
            .subscribe(onNext: { [weak self] isLoading in
                self?.loadingView.state = (isLoading) ? .loading : .none
            })
            .disposed(by: disposeBag)
    }
    
    private func observeDonation() {
        
        self.viewModel.donationFullViewModel
            .compactMap { $0 }
            .subscribe(onNext: { [unowned self] donationViewModel in
                
                self.imagesPageControl.numberOfPages = donationViewModel.pictures.count
                self.imagesPageControl.currentPage = 0
                
                donationViewModel.pictures
                    .map { pictureId -> UIImageView in
                        let imageView = UIImageView()
                        imageView.contentMode = .scaleAspectFit
                        imageView.translatesAutoresizingMaskIntoConstraints = false
                        imageView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
                        ResourcesManager.shared.loadImageUrl(pictureId, imageView: imageView)
                        return imageView
                }
                .forEach(self.imageStackView.addArrangedSubview)
                
                self.adTypeLabel.text = donationViewModel.type
                self.durationLabel.text = donationViewModel.duration
                self.productStateLabel.text = donationViewModel.category
                self.titleLabel.text = donationViewModel.title
                self.descriptionLabel.text = donationViewModel.description
                self.distanceLabel.text = donationViewModel.distance
                self.userNameLabel.text = donationViewModel.authorFullName
                
                ResourcesManager.shared.loadImageUrl(donationViewModel.authorPicture, imageView: self.userImageView)
                
                self.setCircleOrPinInMaps(location: donationViewModel.location)
                
                }, onError: { [weak self] _ in
                    self?.viewModel.onCommitPopBack?()
            })
            .disposed(by: self.disposeBag)
    }
    
    private func setCircleOrPinInMaps(location: Location) {
        if location.obfuscated {
            let circle = MKCircle(center: location.coordinate, radius: 200)
            self.mapView.addOverlay(circle)
        } else {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            self.mapView.addAnnotation(annotation)
        }
        
        self.mapView.centerMap(location.coordinate, animated: false)
    }
}

// MARK: - UIScrollViewDelegate
extension DonationDetailViewController {
    
    // Set pageControl currentPage
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageSide = self.view.frame.width
        let offset = scrollView.contentOffset.x
        let currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
        self.imagesPageControl.currentPage = currentPage
    }
}

// MARK: - MKMapViewDelegate
extension DonationDetailViewController {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = .donationColor
            circle.fillColor = UIColor.donationColor.withAlphaComponent(0.1)
            circle.lineWidth = 1
            return circle
        } else {
            return MKPolylineRenderer()
        }
    }
}
