//
//  MLCollectionViewFlowLayout.swift
//  MLChoiceImageView(swift)
//
//  Created by a on 15-6-16.
//  Copyright (c) 2015年 sss. All rights reserved.
//

import UIKit

class MLCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func prepareLayout() {
        super.prepareLayout()
        //每个cell的尺寸
        self.itemSize = CGSizeMake((UIScreen.mainScreen().bounds.size.width - 40 )/4, (UIScreen.mainScreen().bounds.size.width - 40 )/4)
        self.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5)
        self.minimumLineSpacing = 5
    }
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
}

