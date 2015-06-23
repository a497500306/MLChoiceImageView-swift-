//
//  UIImage+ML.swift
//  MLChoiceImageView(swift)
//
//  Created by a on 15-6-18.
//  Copyright (c) 2015年 sss. All rights reserved.
//


import UIKit

extension UIImage {
    class func resizedImageWithName(#name : String)->UIImage {
      return self.thumbnailWithImageWithoutScale(name: name, left: 0.5, top: 0.5)
    }
    class func thumbnailWithImageWithoutScale(#name : String , left : CGFloat , top : CGFloat)->UIImage {
        var image : UIImage! = UIImage(named: name)
        var left : NSInteger! = NSInteger(image.size.width * left)
        var top : NSInteger! = NSInteger(image.size.height * top)
        return image.stretchableImageWithLeftCapWidth(left, topCapHeight: top )
    }
}
