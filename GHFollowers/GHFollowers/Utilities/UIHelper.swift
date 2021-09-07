//
//  UIHelper.swift
//  GHFollowers
//
//  Created by Rosliakov Evgenii on 10.08.2021.
//

import UIKit

struct UIHelper {
    
    static func createThreeColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let screenWidth = view.bounds.width
        let padding: CGFloat = 12
        let minItemSpacing: CGFloat = 10
        let itemWidth = (screenWidth - padding * 2 - minItemSpacing * 2) / 3
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)
        
        return flowLayout
    }
    
}
