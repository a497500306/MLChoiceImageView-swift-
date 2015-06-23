//
//  MLLeafletPictureController.swift
//  MLChoiceImageView(swift)
//
//  Created by a on 15-6-19.
//  Copyright (c) 2015年 sss. All rights reserved.
//

import UIKit
import AssetsLibrary

class MLLeafletPictureController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    /**图片数组*/
    var modeArray : NSMutableArray! = NSMutableArray()
    /**已选数组*/
    var xuanzheArray : NSMutableArray! = NSMutableArray()
    /**显示位子*/
    var showSeat : NSInteger!
    /**最多选中张数*/
    var seletNumber : NSInteger! = NSInteger()
    /**头部View*/
    var headView : UIView!
    /**底部View*/
    var belowView : UIView!
    /**collectionView*/
    var collectionView : UICollectionView!
    /**选择Btn*/
    var xuanzheBtn : UIButton!
    /**发送Btn*/
    var fasongBtn : UIButton!
    /**image*/
    var resolutionImage : UIImage! 
    var screeImage : UIImage!
    /**当前Cell的indexPath*/
    var indexPath : NSIndexPath! = NSIndexPath()
    /**点击进入的Cell的indexPath*/
    var jinruIndexPath : NSIndexPath! = NSIndexPath()
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        var center : NSNotificationCenter! = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "单击", name: "MLPhotoBrowser_SingleClick", object: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.translucent = true
        //隐藏navigationContoller
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        //初始化
        self.初始化()
    }
    func 单击() {
        if self.headView.frame.origin.y == 0 {
             UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.headView.frame = CGRectMake(0, -64, self.view.frame.size.width, 64)
                self.belowView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width, 44)
             })
        }else{
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.headView.frame = CGRectMake(0, 0, self.view.frame.size.width, 64)
                self.belowView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height - 44 , UIScreen.mainScreen().bounds.size.width, 44)
            })
        }
    }
    func 初始化() {
        //collectionView
        var collectionView : UICollectionView! = UICollectionView(frame: CGRectMake(0, 0, self.view.frame.size.width + 20, self.view.frame.size.height), collectionViewLayout: MLLeafletPictureLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(MLLeafletPictureCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = UIColor.whiteColor()
        //设置默认位置
//        var indexPath1 : NSIndexPath! = NSIndexPath()
//        indexPath1 =  NSIndexPath(indexes: UnsafePointer(bitPattern: 5), length: 0)
//        println("\(indexPath1.row)---\(indexPath1.section)")
        collectionView.scrollToItemAtIndexPath(self.jinruIndexPath, atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
        self.view.addSubview(collectionView)
        self.collectionView = collectionView
        //创建头部
        self.headView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 64))
        self.headView.backgroundColor = UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 0.8)
        //线
        var xian : UIView! = UIView(frame: CGRectMake(0, 63, self.view.frame.width, 0.5))
        xian.backgroundColor = UIColor(red: 182.0/255.0, green: 182.0/255.0, blue: 182.0/255.0, alpha: 1)
        self.headView.addSubview(xian)
        //创建返回按钮
        var btn : UIButton! = UIButton(frame: CGRectMake(15, 25, 34, 34))
        btn.setBackgroundImage(UIImage(named: "back_nor.png"), forState: UIControlState.Normal)
        btn.addTarget(self, action: "点击返回", forControlEvents: UIControlEvents.TouchUpInside)
        self.headView.addSubview(btn)
        //创建选择按钮
        self.xuanzheBtn = UIButton(frame: CGRectMake(UIScreen.mainScreen().bounds.size.width - 15 - 34, 25, 34, 34))
        xuanzheBtn.setImage(UIImage(named: "xc_agreement_unchecked"), forState: UIControlState.Normal)
        xuanzheBtn.setImage(UIImage(named: "xc_agreement_checked"), forState: UIControlState.Selected)
        xuanzheBtn.addTarget(self, action: "点击选择:", forControlEvents: UIControlEvents.TouchUpInside)
        self.headView.addSubview(self.xuanzheBtn)
        self.view.addSubview(self.headView)
        //创建底部
        self.belowView =  UIView(frame: CGRectMake(0, UIScreen.mainScreen().bounds.size.height - 44, UIScreen.mainScreen().bounds.size.width, 44))
        self.belowView.backgroundColor = UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 0.8)
        //线
        var dixian : UIView! = UIView(frame: CGRectMake(0, 1, UIScreen.mainScreen().bounds.size.width, 0.5))
        dixian.backgroundColor = UIColor(red: 182.0/255.0, green: 182.0/255.0, blue: 182.0/255.0, alpha: 1)
        self.belowView.addSubview(dixian)
        //创建发送按钮
        self.fasongBtn = UIButton(frame: CGRectMake(UIScreen.mainScreen().bounds.size.width - 68 - 15, 5, 68, 34))
        if self.xuanzheArray.count > 0 {
            self.fasongBtn.setTitle("发送(\(self.xuanzheArray.count))", forState: UIControlState.Normal)
            
            self.fasongBtn.enabled = true
        }else {
            self.fasongBtn.setTitle("发送", forState: UIControlState.Normal)
            self.fasongBtn.enabled = false
        }
        self.fasongBtn.setTitleColor(UIColor(red: 53.0/255.0, green: 133.0/255.0, blue: 221.0/255.0, alpha: 1), forState: UIControlState.Normal)
        self.fasongBtn.setTitleColor(UIColor(red: 193.0/255.0, green: 193.0/255.0, blue: 193.0/255.0, alpha: 1), forState: UIControlState.Disabled)
        self.fasongBtn.addTarget(self, action: "点击发送", forControlEvents: UIControlEvents.TouchUpInside)
        self.belowView.addSubview(self.fasongBtn)
        self.view.addSubview(self.belowView)
    }
    //点击选择
    func 点击选择(btn:UIButton){
        if btn.selected == true {//取消选择
           btn.selected = false
            var model : MLChoiceModel! = self.modeArray[self.indexPath.row] as MLChoiceModel
            model.isSelected = false
            self.xuanzheArray.removeObjectAtIndex(model.yixuanMark)
            for var i : Int = 0 ; i < self.xuanzheArray.count; ++i {
                var model1 : MLChoiceModel! = self.xuanzheArray[i] as MLChoiceModel
                if model1.yixuanMark > model.yixuanMark {
                     model1.yixuanMark = model1.yixuanMark - 1
                }
            }
            self.collectionView.reloadData()
        }else{//选择
           //判断选中张数
            if (self.seletNumber != nil) {
                if self.xuanzheArray.count == self.seletNumber {//弹框提示
                    self.tankuang(self.seletNumber)
                    return ;
                }
            }
            btn.selected = true
            var model : MLChoiceModel! = self.modeArray[self.indexPath.row] as MLChoiceModel
            model.isSelected = true
            model.yixuanMark = self.xuanzheArray.count
            self.xuanzheArray.addObject(model)
        }
        if self.xuanzheArray.count == 0 {
            self.fasongBtn.setTitle("发送", forState: UIControlState.Normal)
            self.fasongBtn.enabled = false
        }else {
            self.fasongBtn.setTitle("发送(\(self.xuanzheArray.count))", forState: UIControlState.Normal)
            self.fasongBtn.enabled = true
        }
        self.collectionView.reloadData()
    }
    //点击发送
    func 点击发送() {
        var mutableArray : NSMutableArray! = NSMutableArray()
        for var i : Int = 0 ; i < xuanzheArray.count; ++i {
            var model : MLChoiceModel! = self.xuanzheArray[i] as MLChoiceModel
            mutableArray.addObject(model.asset)
        }
        var array : NSArray! = NSArray(array: mutableArray)
        //传通知
        var center:NSNotificationCenter! = NSNotificationCenter.defaultCenter()
        var dict : NSDictionary! = ["assets":array]
        center.postNotificationName("MLLeafletPictureController_Send", object: self, userInfo: dict)
    }
    //点击返回
    func 点击返回() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    //弹框提示
    func tankuang(ger : NSInteger){
        if UIDevice.currentDevice().systemVersion._bridgeToObjectiveC().floatValue >= 8.0 {
            var alert : UIAlertController! = UIAlertController(title: "你最多只能选择\(ger)张", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            alert.popoverPresentationController?.barButtonItem = self.navigationItem.leftBarButtonItem
            alert.addAction(UIAlertAction(title: "我知道了", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }else{
            var alert : UIAlertView! = UIAlertView(title: "你最多只能选择\(ger)张", message: nil, delegate: nil, cancelButtonTitle: "我知道了")
            alert.alertViewStyle = UIAlertViewStyle.Default
            alert.show()
        }
    }
    //collectioView代理方法
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.modeArray.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        self.indexPath = indexPath
        var cell : MLLeafletPictureCell! = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as MLLeafletPictureCell
        var model : MLChoiceModel! = self.modeArray[indexPath.row] as MLChoiceModel
        var asset : ALAsset! = model.asset
        var reprexentation : ALAssetRepresentation! = asset.defaultRepresentation()
        autoreleasepool {
            self.screeImage = UIImage(CGImage: reprexentation.fullScreenImage().takeUnretainedValue())
            if (self.screeImage.size.height / self.screeImage.size.width > 3||self.screeImage.size.width / self.screeImage.size.height > 3) {
                self.resolutionImage = UIImage(CGImage: reprexentation.fullResolutionImage().takeUnretainedValue())
                //把图片添加到cell
                cell.imageViewFarme(UIScreen.mainScreen().bounds, image: self.resolutionImage)
            }else{
                //把图片添加到cell
                cell.imageViewFarme(UIScreen.mainScreen().bounds, image: self.screeImage)
                
            }
        }
        self.xuanzheBtn.selected = model.isSelected
       return cell
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(self.view.frame.size.width + 20, self.view.frame.size.height)
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
