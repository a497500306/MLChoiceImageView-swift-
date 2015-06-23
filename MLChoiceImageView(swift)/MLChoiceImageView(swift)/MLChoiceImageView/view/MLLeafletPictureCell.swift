//
//  MLLeafletPictureCell.swift
//  MLChoiceImageView(swift)
//
//  Created by a on 15-6-19.
//  Copyright (c) 2015年 sss. All rights reserved.
//

import UIKit

class MLLeafletPictureCell: UICollectionViewCell {
    var imageView : MLPhotoView! = MLPhotoView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func imageViewFarme(rect : CGRect , image : UIImage ){
        self.imageView.removeFromSuperview()
        var imageView : MLPhotoView! = MLPhotoView(frame: CGRectMake(rect.origin.x, 0, rect.size.width, rect.size.height), andImage: image)
        imageView.autoresizingMask = UIViewAutoresizing.None
        self.imageView = imageView
        self.addSubview(self.imageView)
    }
}
