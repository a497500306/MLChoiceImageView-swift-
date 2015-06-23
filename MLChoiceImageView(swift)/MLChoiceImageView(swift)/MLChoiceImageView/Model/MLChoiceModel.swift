//
//  MLChoiceModel.swift
//  MLChoiceImageView(swift)
//
//  Created by a on 15-6-16.
//  Copyright (c) 2015年 sss. All rights reserved.
//

import UIKit
import AssetsLibrary

class MLChoiceModel: NSObject {
    /**
    *  存放在数组的位置
    */
    var mark : NSInteger!
    /**
    *  存放在已选数组的位置
    */
    var yixuanMark : NSInteger!
    /**
    *  是否被选中
    */
    var isSelected : Bool!
    /**
    *  图片属性
    */
    var asset : ALAsset!
}
