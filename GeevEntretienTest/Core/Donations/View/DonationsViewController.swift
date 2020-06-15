//
//  DonationsViewController.swift
//  GeevEntretienTest
//
//  Created by ELANKUMARAN Tharsan on 11/06/2020.
//  Copyright © 2020 ELANKUMARAN Tharsan. All rights reserved.
//

import UIKit
import MapKit
import RxSwift
import RxRelay
import RxCocoa
import RxDataSources

class DonationsViewController: BaseViewController, UICollectionViewDelegateFlowLayout, MKMapViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    
    private let padding: CGFloat = 14
    private var isShowList: Bool = true
    
    var viewModel: DonationsViewModel!
    private let disposeBag = DisposeBag()
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBarItem: UIBarButtonItem!
    
    override var loadingTitle: String {
        return GEEVLoc.Donation.DONATION_NO_RESULT.localized
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = .black
        let mapBarItem = UIBarButtonItem(image: #imageLiteral(resourceName: "map_icon"), style: .plain, target: self, action: #selector(toggleMapListAction))
        self.searchBarItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchBarAction))
        self.navigationItem.rightBarButtonItems = [self.searchBarItem, mapBarItem]
        
        // setup SearchController
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.delegate = self
        self.definesPresentationContext = true
        
        self.mapView.isHidden = self.isShowList
        self.mapView.showsUserLocation = true
        self.mapView.delegate = self
        
        self.collectionView.delegate = self
        DonationHeaderViewCell.registerNibFor(collectionView: collectionView)
        DonationViewCell.registerNibFor(collectionView: collectionView)
        
        // Configure Custom FlowLayout
        let alignedFlowLayout = collectionView?.collectionViewLayout as? AlignedCollectionViewFlowLayout
        alignedFlowLayout?.sectionInset = UIEdgeInsets(top: 20, left: self.padding / 2, bottom: 20, right: self.padding / 2)
        alignedFlowLayout?.horizontalAlignment = .left
        
        // Setup Cells
        let dataSource = self.configureCells()
        self.configureSupplementaryView(dataSource)
        self.bindItemsToCells(dataSource)
        self.setupTapCell()
        
        self.observeLoading()
        self.observeDonations()
        self.observeSearchBarText()
        
        self.viewModel.getDonations(keywords: nil) { [weak self] error in
            self?.showAlert(title: GEEVLoc.Error.ERROR_DEFAULT_TILE.localized, message: error.localizedDescription)
        }
    }
    
    // MARK: - Actions
    @objc func toggleMapListAction(_ barItem: UIBarButtonItem) {
        self.isShowList.toggle()
        barItem.image = (self.isShowList) ? #imageLiteral(resourceName: "map_icon") : #imageLiteral(resourceName: "list_icon")
        self.collectionView.isHidden = !self.isShowList
        self.mapView.isHidden = self.isShowList
    }
    
    @objc func searchBarAction(_ barItem: UIBarButtonItem) {
        self.navigationItem.titleView = self.searchController.searchBar
        if let index = self.navigationItem.rightBarButtonItems?.firstIndex(where: {$0 == barItem}) {
            self.navigationItem.rightBarButtonItems?.remove(at: index)
        }
        self.searchController.searchBar.becomeFirstResponder()
    }
}

// MARK: - RxDataSources
extension DonationsViewController {
    
    private func configureCells() -> DonationsViewModel.DataSource {
        return DonationsViewModel.DataSource(configureCell: { (dataSource, collectionView, indexPath, donationViewModel) -> UICollectionViewCell in
            let cell = DonationViewCell.cellForCollection(collectionView: collectionView, indexPath: indexPath)
            cell.widthConstraint.constant = self.collectionView.bounds.width / 2 - (self.padding)
            cell.donationViewModel = donationViewModel
            ResourcesManager.shared.loadImageUrl(donationViewModel.picture, imageView: cell.imageView)
            return cell
        })
    }
    
    private func configureSupplementaryView(_ dataSource: DonationsViewModel.DataSource) {
        dataSource.configureSupplementaryView = { (dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in
            let header = DonationHeaderViewCell.reusableViewForCollection(collectionView: collectionView, indexPath: indexPath)
            return header
        }
    }
}

// MARK: - Rx
extension DonationsViewController {
    
    private func bindItemsToCells(_ dataSource: DonationsViewModel.DataSource) {
        self.viewModel.donations
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
    }
    
    private func setupTapCell() {
        self.collectionView.rx
            .modelSelected(DonationViewModel.self)
            .subscribe(onNext: { donation in
                self.viewModel.onCommitSelectDonation?(donation.id)
        }).disposed(by: self.disposeBag)
    }
    
    // Observers
    private func observeDonations() {
        self.viewModel.donations.subscribe(onNext: { sectionDatas in
            if let sectionData = sectionDatas.first {
                self.viewModel.configureMapAnnotations(mapView: self.mapView, donations: sectionData.items)
            }
        }).disposed(by: self.disposeBag)
    }
    
    private func observeSearchBarText() {
        self.searchController.searchBar.rx.text
            .orEmpty
            .skip(1) // Ship first time when initial searchController
            .debounce(.milliseconds(250), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
                let keywords = text.isEmpty ? nil : text
                self?.viewModel.getDonations(keywords: keywords, onError: { _ in
                    self?.loadingView.state = .titleOnly
                })
            })
            .disposed(by: self.disposeBag)
    }
    
    private func observeLoading() {
        self.viewModel.isLoading
            .subscribe(onNext: { [weak self] isLoading in
                self?.loadingView.state = (isLoading) ? .loading : .none
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension DonationsViewController {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: DonationHeaderViewCell.preferredHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.padding
    }
}

// MARK: - MKMapViewDelegate
extension DonationsViewController {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: false)
        
        if let donationAnnotation = view.annotation as? DonationsViewModel.DonationAnnotation {
            self.viewModel.onCommitSelectDonation?(donationAnnotation.id)
        }
    }
}

// MARK: - UISearchBarDelegate
extension DonationsViewController {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        
        if #available(iOS 13.0, *) {
            searchBar.searchTextField.sendActions(for: .editingChanged)
        } else {
            (searchBar.value(forKey: "_searchField") as? UITextField)?.sendActions(for: .editingChanged)
        }
        
        self.navigationItem.titleView = nil
        self.navigationItem.rightBarButtonItems?.insert(self.searchBarItem, at: 0)
    }
}
