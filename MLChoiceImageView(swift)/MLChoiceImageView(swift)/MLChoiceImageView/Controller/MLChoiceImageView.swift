//
//  MLChoiceImageView.swift
//  MLChoiceImageView(swift)
//
//  Created by a on 15-6-16.
//  Copyright (c) 2015年 sss. All rights reserved.
//

import UIKit
import AssetsLibrary

/**点击发送代理方法*/
protocol MLChoiceImageViewDelegate : NSObjectProtocol{
    func assetPickerController(picker : MLChoiceImageView! , assets : NSArray!)
}
class MLChoiceImageView: UIViewController ,UIGestureRecognizerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,MLChoiceImageCellDelegate{
    /*图片单例*/
    class var sharedInstance : ALAssetsLibrary {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : ALAssetsLibrary? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = ALAssetsLibrary()
        }
        return Static.instance!
    }
    
    /**代理*/
    var delegate: MLChoiceImageViewDelegate!
    /**发送按钮*/
    var barBtn : UIBarButtonItem!
    /**collectionView*/
    var collectionView : UICollectionView!
    /**照片获取权限判断*/
    var isQuanxian : Bool!
    /**最多选择张数,默认9张*/
    var SelectNumber : NSInteger! = NSInteger()
    /**相册文件*/
    var assetsGroup : ALAssetsGroup?
    /**选中的照片*/
    var xuanzheArray : NSMutableArray! = NSMutableArray()
    /**存放照片模型*/
    var modelArray : NSMutableArray! = NSMutableArray()
    /**存放相册数据*/
    var albumsArray : NSMutableArray! = NSMutableArray()
    /**存放相册对象*/
    var assetsLibrary:ALAssetsLibrary!

    
    //实现滑动退出功能,实现self.navigationController.interactivePopGestureRecognizer.delegate = self;
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        获取相片资源()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        初始化()
        //通知
        var center : NSNotificationCenter! = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "通知:", name: "MLLeafletPictureController_Send", object: nil)
    }
    //获取相片资源
    func 获取相片资源() {
        var tipTextWhenNoPhotosAuthorization : NSString!
        // 获取当前应用对照片的访问授权状态
        var authorizationStatus : ALAuthorizationStatus! = ALAssetsLibrary.authorizationStatus()
        // 如果没有获取访问授权，或者访问授权状态已经被明确禁止，则显示提示语，引导用户开启授权
        if authorizationStatus == ALAuthorizationStatus?() || authorizationStatus == ALAuthorizationStatus?() {
            var mainInfoDictionary : NSDictionary! = NSBundle.mainBundle().infoDictionary
            var appName: NSString! = mainInfoDictionary.objectForKey("CFBundleDisplayName") as NSString
            tipTextWhenNoPhotosAuthorization = "请在设备的\"设置-隐私-照片\"选项中，允许\(appName)访问你的手机相册"
            self.isQuanxian = true
        }
        if (self.assetsGroup != nil){
            var modelArray = NSMutableArray()
            var assetsGroup : ALAssetsGroup! = self.assetsGroup
            assetsGroup.enumerateAssetsWithOptions(NSEnumerationOptions(), usingBlock: { (result:ALAsset!, index:Int, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
                if (result != nil) {
                    var model = MLChoiceModel()
                    model.isSelected = false;
                    model.mark = 0;
                    model.asset = result;
                    modelArray.addObject(model)
                }else{
                    if self.modelArray == nil {
                        self.modelArray = NSMutableArray()
                    }
                    if self.modelArray.count > 0 {
                        self.collectionView.reloadData()
                        return
                    }
                    self.modelArray = modelArray
                    self.collectionView.reloadData()
                }
            })
        }else{
            var assetGroupEnumerator = {(group:ALAssetsGroup!, stop:UnsafeMutablePointer<ObjCBool>)->Void in
                if (group == nil){
                    println("相册个数\(self.albumsArray.count)")
                    for var i = 0 ; i < self.albumsArray.count ; ++i{
                        var assetsGroup : ALAssetsGroup! = self.albumsArray[i] as ALAssetsGroup
                        var groupname : NSString! = assetsGroup.valueForProperty(ALAssetsGroupPropertyName) as NSString
                        if groupname == "Camera Roll" {
                            self.assetsGroup = assetsGroup
                            assetsGroup.enumerateAssetsWithOptions(NSEnumerationOptions(), usingBlock: { (result:ALAsset!, index : Int, stop :UnsafeMutablePointer<ObjCBool>) -> Void in
                                if (result != nil) {
                                    var model : MLChoiceModel! = MLChoiceModel()
                                    model.isSelected = false
                                    model.mark = 0
                                    model.asset = result
                                    self.modelArray.addObject(model)
                                    self.collectionView.reloadData()
                                }
                            })
                        }
                    }
                }else{
                    var al : ALAssetsFilter! = ALAssetsFilter.allPhotos()
                    group.setAssetsFilter(al)
                    if group.numberOfAssets() > 0 {
                        self.albumsArray.addObject(group)
                    }
                }
            }
            var assetGroupEnumberatorFailure = {(error:NSError!)->Void in
            }
            self.assetsLibrary = ALAssetsLibrary()
            var albumsArray : NSMutableArray! = NSMutableArray()
            assetsLibrary.enumerateGroupsWithTypes(ALAssetsGroupType(ALAssetsGroupSavedPhotos), usingBlock: assetGroupEnumerator, failureBlock:assetGroupEnumberatorFailure)
        }
    }
    //collectionView代理和数据源方法
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.xuanzheArray == nil {self.xuanzheArray = NSMutableArray()}
        if self.xuanzheArray.count == 0 {
            self.barBtn.title = "发送"
            self.barBtn.enabled = false
        }else{
            self.barBtn.title = "发送\(self.xuanzheArray.count)"
            self.barBtn.enabled = true
        }
        return self.modelArray.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell : MLChoiceImageCell! = collectionView.dequeueReusableCellWithReuseIdentifier("image", forIndexPath: indexPath) as MLChoiceImageCell
        var model : MLChoiceModel! = self.modelArray[indexPath.row] as MLChoiceModel
        var imageA : UIImage! = UIImage(CGImage: model.asset.thumbnail().takeUnretainedValue())
        cell.图片.image = imageA
        cell.选择按钮.selected = model.isSelected
        cell.delegate = self
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var leaflet : MLLeafletPictureController! = MLLeafletPictureController() as MLLeafletPictureController
        leaflet.modeArray = self.modelArray
        leaflet.xuanzheArray = self.xuanzheArray
        leaflet.showSeat = indexPath.row
        leaflet.seletNumber = self.SelectNumber
        leaflet.jinruIndexPath = indexPath
        self.navigationController?.pushViewController(leaflet, animated: true)
    }
    //初始化
    func 初始化 () {
        self.navigationItem.title = "发送图片"
//        self.navigationItem.titleView!.tintColor = UIColor(red: 65.0/255.0, green: 153.0/255.0, blue: 228.0/255.0, alpha: 1)
        self.navigationController?.interactivePopGestureRecognizer.delegate = self
        //设置返回按钮
        var leftBtn : UIButton! = UIButton(frame: CGRectMake(0, 0, 34, 34))
        leftBtn.setBackgroundImage(UIImage(named: "back_nor.png"), forState: UIControlState.Normal)
        leftBtn.addTarget(self, action: "点击返回", forControlEvents: UIControlEvents.TouchUpInside)
        var leftBarItem = UIBarButtonItem(customView: leftBtn)
        self.navigationItem.leftBarButtonItems = [leftBarItem]
        //设置发送按钮
        var rightBtn : UIBarButtonItem! = UIBarButtonItem(title: "发送", style: UIBarButtonItemStyle.Bordered, target: self, action: "点击发送")
        rightBtn.tintColor = UIColor(red: 53/255.0, green: 133/255.0, blue: 221/255.0, alpha: 1)
        self.navigationItem.rightBarButtonItem = rightBtn
        self.barBtn = rightBtn
        
        //创建CollectionView
        var 布局 : MLCollectionViewFlowLayout! = MLCollectionViewFlowLayout()
        var collectionView : UICollectionView! = UICollectionView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height), collectionViewLayout: 布局)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerNib(UINib(nibName: "MLChoiceImageCell", bundle: nil), forCellWithReuseIdentifier: "image")
        collectionView.backgroundColor = UIColor.whiteColor()
        //设置额外的滚动区域
        collectionView.contentInset = UIEdgeInsetsMake(0, 0, 50 + 64, 0)
        self.view.addSubview(collectionView)
        self.collectionView = collectionView
        //底部选择相册
        var 底部条 : UIImageView! = UIImageView(frame: CGRectMake(0, UIScreen.mainScreen().bounds.size.height - 50 - 64, self.view.frame.size.width, 50))

        底部条.backgroundColor = UIColor.whiteColor()
        底部条.userInteractionEnabled = true
        //选择相册按钮
        var btn : UIButton! = UIButton(frame: CGRectMake(5, 5, 100, 40))
        btn.setBackgroundImage(UIImage.resizedImageWithName(name: "write_sms_bg_pre"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage.resizedImageWithName(name: "write_sms_bg_pre"), forState: UIControlState.Highlighted)
        btn.setTitle("选择相册", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor(red: 53/255.0, green: 133/255.0, blue: 221/255.0, alpha: 1), forState: UIControlState.Normal)
        btn.addTarget(self, action: "点击选择相册", forControlEvents: UIControlEvents.TouchUpInside)
        //线
        var 线 = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 1))
        线.backgroundColor = UIColor(red: 232/255.0, green: 232/255.0, blue: 232/255.0, alpha: 1)
        底部条.addSubview(线)
        底部条.addSubview(btn)
        self.view.addSubview(底部条)
    }
    //点击选择相册
    func 点击选择相册(){
        var choice : MLChoiceAlbumController! = MLChoiceAlbumController()
        choice.albumsArray = self.albumsArray
        choice.ap = self
        self.xuanzheArray = nil
        self.modelArray = nil
        self.navigationController?.pushViewController(choice, animated: true)
    }
    //点击左上角返回
    func 点击返回(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    //点击发送
    func 点击发送(){
        println("点击发送")
        var array : NSMutableArray! = NSMutableArray()
        for var i : Int = 0; i < self.xuanzheArray.count; ++i {
            var model : MLChoiceModel! = self.xuanzheArray[i] as MLChoiceModel
            array.addObject(model.asset)
        }
        var array1 : NSArray! = NSArray(array: array)
        self.delegate.assetPickerController(self, assets: array1)
    }
    //通知
    func 通知(aNotification : NSNotification){
        var info : NSDictionary! = aNotification.userInfo
        var array : NSArray! = info.objectForKey("assets") as NSArray
        self.delegate.assetPickerController(self, assets: array)
    }
    //实现cell代理方法
    func xuanzhedezhaopian(choiceButton: MLChoiceButtn, andCell: MLChoiceImageCell) {
        var collection : UICollectionView! = andCell.superview as UICollectionView
        var index : NSIndexPath! = collection.indexPathForCell(andCell)
        if choiceButton.selected == false {//选择
            if (self.SelectNumber != nil) {
                if self.xuanzheArray.count == self.SelectNumber {//弹框提示
                    self.tankuang(self.SelectNumber)
                    return ;
                }
            }
            choiceButton.selected = true
            var model : MLChoiceModel! = self.modelArray[index.row] as MLChoiceModel
            model.isSelected = true
            model.yixuanMark = self.xuanzheArray.count
            self.xuanzheArray.addObject(model)
        }else {//取消
            choiceButton.selected = false
            var model : MLChoiceModel! = self.modelArray[index.row] as MLChoiceModel
            model.isSelected = false
            self.xuanzheArray.removeObjectAtIndex(model.yixuanMark)
            for var i = 0 ; i < self.xuanzheArray.count ; ++i{
                var modelA : MLChoiceModel! = self.xuanzheArray[i] as MLChoiceModel
                if modelA.yixuanMark > model.yixuanMark {
                     modelA.yixuanMark = modelA.yixuanMark - 1
                }
            }
        }
        if self.xuanzheArray.count == 0 {
            self.barBtn.title = "发送"
            self.barBtn.enabled = false
        }else{
            self.barBtn.title = "发送\(self.xuanzheArray.count)"
            self.barBtn.enabled = true
        }
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
}


