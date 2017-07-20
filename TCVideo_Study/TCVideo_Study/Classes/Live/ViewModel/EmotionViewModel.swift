//
//  EmotionViewModel.swift
//  TCVideo_Study
//
//  Created by tcan on 2017/7/19.
//  Copyright © 2017年 tcan. All rights reserved.
//

import UIKit

class EmotionViewModel {

    static let shareInstance : EmotionViewModel = EmotionViewModel()
    lazy var packages : [EmotionPackage] = [EmotionPackage]()
    
    init() {
        packages.append(EmotionPackage(plistName: "QHNormalEmotionSort.plist"))
        packages.append(EmotionPackage(plistName: "QHSohuGifSort.plist"))
    }
    
}
