//
//  BaseCollectionReusableView.swift
//  GeevEntretienTest
//
//  Created by ELANKUMARAN Tharsan on 11/06/2020.
//  Copyright © 2020 ELANKUMARAN Tharsan. All rights reserved.
//

import Foundation
import UIKit

open class BaseCollectionReusableView: UICollectionReusableView {
    
    //MARK: Life Cycle
    override open func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override open func prepareForReuse() {
        super.prepareForReuse()
    }
    
    //MARK: Instance
    open class func registerNibFor(collectionView: UICollectionView) {
        assertionFailure("Must be override")
    }
    
    open class func reusableViewForCollection(collectionView: UICollectionView, indexPath : IndexPath) -> UICollectionReusableView {
        assertionFailure("Must be override")
        return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: self), for: indexPath as IndexPath)
    }
    
}
