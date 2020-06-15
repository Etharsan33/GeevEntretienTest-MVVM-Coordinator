//
//  DonationViewCell.swift
//  GeevEntretienTest
//
//  Created by ELANKUMARAN Tharsan on 11/06/2020.
//  Copyright © 2020 ELANKUMARAN Tharsan. All rights reserved.
//

import UIKit

class DonationViewCell: UICollectionViewCell {
    
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet var icons: [UIImageView]!
    
    var donationViewModel: DonationViewModel! {
        didSet {
            self.titleLabel.text = donationViewModel.title
            self.locationLabel.text = donationViewModel.distance
            self.durationLabel.text = donationViewModel.duration
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if Helper.osVersionIs(maj: 12) {
            setupSelfSizingForiOS12(contentView: contentView)
        }
        
        self.imageView.setCornerRadius(4)
        self.icons.forEach {
            $0.image = $0.image?.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .donationColor
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageView.image = nil
    }
}
