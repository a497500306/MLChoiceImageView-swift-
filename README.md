# MLChoiceImageView-swift-
图片选择器,多图片选择器,图片浏览器(swift版)
## <a id="图片浏览"></a>图片浏览
- 相册选择界面

![(App)](http://a3.qpic.cn/psb?/V13XLmNA0zbAmP/h*c5kljL6Eu4G7mrHODX1.w5yWHcJ*D5cler106x55s!/b/dMIJTm62GwAA&bo=gAJwBAAAAAAFB9I!&rf=viewer_4)
- 照片选择界面

![(App)](http://a2.qpic.cn/psb?/V13XLmNA0zbAmP/i55cWgi.JmfWdyBWaGcjsQkXO.wvTVVR6smtKfFbZEs!/b/dHYCt20fAwAA&bo=gAJwBAAAAAAFB9I!&rf=viewer_4)
- 照片浏览界面(支持手势放大缩小)

![(App)](http://a2.qpic.cn/psb?/V13XLmNA0zbAmP/qBg9R2HNls*XIUx7YUwTMqUS3TcnWJxOTtseEjUTJr4!/b/dJOLd2.hKwAA&bo=gAJwBAAAAAAFB9I!&rf=viewer_4)
## <a id="基本使用"></a>基本使用
```objc
    //创建控制器
    var imageView : MLChoiceImageView! = MLChoiceImageView()
   //最多选择照片的数量
    imageView.SelectNumber = 6
    //遵循代理
    imageView.delegate = self
    //创建NavigationController
    var nav : UINavigationController! = UINavigationController(rootViewController: imageView)
    //模态出控制器
    self.presentViewController(nav, animated: true) { () -> Void in
            
    }
//实现代理方法
func assetPickerController(picker: MLChoiceImageView!, assets: NSArray!) {
        //关闭控制器
        self.dismissViewControllerAnimated(true, completion: nil)
        //取出照片(想取什么照片自己选择)
        println("您选择了\(assets.count)张照片")
    }
```

