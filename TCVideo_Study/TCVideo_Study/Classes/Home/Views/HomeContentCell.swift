//
//  HomeContentCell.swift
//  TCVideo_Study
//
//  Created by tcan on 17/5/27.
//  Copyright © 2017年 tcan. All rights reserved.
//

import UIKit
import Kingfisher

class HomeContentCell: UICollectionViewCell {
    //Mark: - 控件属性
    //背景图片
    @IBOutlet weak var albumImageView: UIImageView!
    //live图标
    @IBOutlet weak var liveImageView: UIImageView!
    //昵称
    @IBOutlet weak var nickNameLabel: UILabel!
    //在线人数
    @IBOutlet weak var onlinePeopleLabel: UIButton!
    
    //Mark: - 对外属性
    var contentModel : HomePageContentModel? {
        didSet{
            albumImageView.setImage(contentModel!.isEvenIndex ? contentModel?.pic74 : contentModel?.pic51, "home_pic_default")
            liveImageView.isHidden = contentModel?.live == 0
            nickNameLabel.text = contentModel?.name
            onlinePeopleLabel.setTitle("\(contentModel?.focus ?? 0)", for: .normal)
        }
    }
}
