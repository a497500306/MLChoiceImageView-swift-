//
//  MLLeafletPictureLayout.swift
//  MLChoiceImageView(swift)
//
//  Created by a on 15-6-19.
//  Copyright (c) 2015年 sss. All rights reserved.
//

import UIKit

class MLLeafletPictureLayout: UICollectionViewFlowLayout {
    //初始化
    override func prepareLayout() {
        super.prepareLayout()
        //每个cell的尺寸
        self.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
        //设置水平滚动
        self.scrollDirection = UICollectionViewScrollDirection.Horizontal
        //设置间距
        self.minimumLineSpacing = 0
        //分页
        self.collectionView?.pagingEnabled = true
        //显示指示器
        self.collectionView?.showsHorizontalScrollIndicator = false
        self.collectionView?.showsVerticalScrollIndicator = false

    }
}
