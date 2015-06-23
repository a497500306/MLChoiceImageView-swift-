//
//  ViewController.swift
//  MLChoiceImageView(swift)
//
//  Created by a on 15-6-16.
//  Copyright (c) 2015年 sss. All rights reserved.
//

import UIKit

class ViewController: UIViewController , MLChoiceImageViewDelegate{
    @IBAction func 打开相册(sender: UIButton) {
        var imageView : MLChoiceImageView! = MLChoiceImageView()
        imageView.SelectNumber = 6
        imageView.delegate = self
        var nav : UINavigationController! = UINavigationController(rootViewController: imageView)
        self.presentViewController(nav, animated: true) { () -> Void in
            
        }
    }
    //代理方法
    func assetPickerController(picker: MLChoiceImageView!, assets: NSArray!) {
        //关闭控制器
        self.dismissViewControllerAnimated(true, completion: nil)
        //取出照片(想取什么照片自己选择)
        println("您选择了\(assets.count)张照片")
    }
}

