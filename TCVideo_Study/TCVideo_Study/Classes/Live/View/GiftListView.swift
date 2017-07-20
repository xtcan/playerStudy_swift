//
//  GiftListView.swift
//  TCVideo_Study
//
//  Created by tcan on 17/6/22.
//  Copyright © 2017年 tcan. All rights reserved.
//

import UIKit

class GiftListView: UIView {

    // MARK: 控件属性
    @IBOutlet weak var giftView: UIView!
    @IBOutlet weak var sendGiftBtn: UIButton!

}


extension GiftListView {
    
    @IBAction func sendGiftBtnClick() {
//        let package = giftVM.giftlistData[currentIndexPath!.section]
//        let giftModel = package.list[currentIndexPath!.item]
//        delegate?.giftListView(giftView: self, giftModel: giftModel)
    }
}
