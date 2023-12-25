//
//  DFWBaseCollectionView.swift
//  DongFuWang
//
//  Created by Ye.Sir on 2020/11/16.
//

import UIKit

class DFWBaseCollectionView: UICollectionView, UIGestureRecognizerDelegate {
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}

