//
//  MLChoiceAlbumController.swift
//  MLChoiceImageView(swift)
//
//  Created by a on 15-6-18.
//  Copyright (c) 2015年 sss. All rights reserved.
//

import UIKit
import AssetsLibrary

class MLChoiceAlbumController: UITableViewController ,UIGestureRecognizerDelegate{
    /**相册数组*/
    var albumsArray : NSMutableArray! = NSMutableArray()
    /**控制器*/
    var ap : MLChoiceImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer.delegate = self
        //cell高度
        self.tableView.rowHeight = 60
        //设置返回按钮
        var leftBtn : UIButton! = UIButton(frame: CGRectMake(0, 0, 34, 34))
        leftBtn.setBackgroundImage(UIImage(named: "back_nor.png"), forState: UIControlState.Normal)
        leftBtn.addTarget(self, action: "点击返回", forControlEvents: UIControlEvents.TouchUpInside)
        var leftBarItem = UIBarButtonItem(customView: leftBtn)
        self.navigationItem.leftBarButtonItems = [leftBarItem]
    }
    //实现滑动退出功能,实现self.navigationController.interactivePopGestureRecognizer.delegate = self;
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    //tableView代理方法
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albumsArray.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell? = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        var assetsGroup : ALAssetsGroup! = self.albumsArray[self.albumsArray.count - indexPath.row - 1] as ALAssetsGroup
        println("图片\(assetsGroup)")
        //相册名字
        var str : NSString! = NSString(format: "%d", assetsGroup.numberOfAssets())
        if assetsGroup.valueForProperty(ALAssetsGroupPropertyName) as NSString == "Camera Roll" {
            cell!.textLabel.text = "相机胶卷";
            cell!.detailTextLabel?.text = str
        }else if assetsGroup.valueForProperty(ALAssetsGroupPropertyName) as NSString == "My Photo Stream" {
            cell!.textLabel.text = "我的照片流";
            cell!.detailTextLabel?.text = str
        }else{
            cell!.textLabel.text = assetsGroup.valueForProperty(ALAssetsGroupPropertyName) as NSString
            cell!.detailTextLabel?.text = str
        }
        //取出图片
        assetsGroup.enumerateAssetsWithOptions(NSEnumerationOptions(), usingBlock: { (result:ALAsset!, index:Int, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
            if (result != nil) {
                cell!.imageView.image = UIImage(CGImage: result.thumbnail().takeUnretainedValue())
            }else{
                
            }
        })
        //显示剪头
        cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell!
    }
    //点击cell
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var assetsGroup : ALAssetsGroup! = self.albumsArray[self.albumsArray.count - indexPath.row - 1 ] as ALAssetsGroup
        self.ap.assetsGroup = assetsGroup
        if self.ap.xuanzheArray != nil {
            self.ap.xuanzheArray.removeAllObjects()
        }else{
           self.ap.xuanzheArray = NSMutableArray()
        }
        self.ap.modelArray = nil
        self.点击返回()
    }
    //点击左上角返回
    func 点击返回(){
        self.navigationController?.popViewControllerAnimated(true)
    }
}
