//
//  UIFlowLayoutHelper.swift
//  ImagEngine
//
//  Created by Ahmet Yusuf Yuksek on 1/18/22.
//

import UIKit

struct UIFlowLayoutHelper {
    
    static func createThreeColumnLayout(in view: UIView) -> UICollectionViewFlowLayout {
        
        let width = view.bounds.width
        let padding: CGFloat = 2
        let minimumSpacing: CGFloat = 10
        let availableWidth = width - (padding * 2) - (minimumSpacing * 2)
        let itemWidth = availableWidth / 3
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        return flowLayout
    }
    
}
