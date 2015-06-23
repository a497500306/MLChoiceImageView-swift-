//
//  MLChoiceImageCell.swift
//  MLChoiceImageView(swift)
//
//  Created by a on 15-6-16.
//  Copyright (c) 2015年 sss. All rights reserved.
//

import UIKit
protocol MLChoiceImageCellDelegate : NSObjectProtocol{
    func xuanzhedezhaopian(choiceButton : MLChoiceButtn , andCell : MLChoiceImageCell)
}
class MLChoiceImageCell: UICollectionViewCell{
    @IBOutlet weak var 图片: UIImageView!
    @IBOutlet weak var 选择按钮: MLChoiceButtn!
    var delegate: MLChoiceImageCellDelegate!
    @IBAction func 点击选择(sender: MLChoiceButtn) {
        if self.delegate != nil {
             self.delegate.xuanzhedezhaopian(sender, andCell: self)
        }
    }
}
