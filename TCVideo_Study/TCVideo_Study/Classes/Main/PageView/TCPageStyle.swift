//
//  TCPageStyle.swift
//  TCPageView
//
//  Created by tcan on 17/5/23.
//  Copyright © 2017年 tcan. All rights reserved.
//

import UIKit

class TCPageStyle: NSObject {

    var titleViewHeight : CGFloat = 44
    var titleFont : UIFont = UIFont.systemFont(ofSize: 14.0)
    var isScrollEnable : Bool = true
    
    var titleMargin : CGFloat = 25
    
    var normalColor : UIColor = UIColor(r: 255, g: 255, b: 255)
    var selectColor : UIColor = UIColor(r: 255, g: 127, b: 0)
    
    var isShowBottomLine : Bool = false
    var bottomLineColor : UIColor = UIColor.orange
    var bottomLineHeight : CGFloat = 2
    
    var isTitleScale : Bool = true
    var scaleRange : CGFloat = 1.2
    
    var isShowCoverView : Bool = false
    var coverBgColor : UIColor = UIColor.black
    var coverAlpha : CGFloat = 0.4
    var coverMargin : CGFloat = 8
    var coverHeight : CGFloat = 20
    
}
