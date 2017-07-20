//
//  EmotionViewCell.swift
//  TCVideo_Study
//
//  Created by tcan on 2017/7/18.
//  Copyright © 2017年 tcan. All rights reserved.
//

import UIKit

class EmotionViewCell: UICollectionViewCell {

    @IBOutlet weak var emotionImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var emotion : Emotion? {
        didSet {
            emotionImageView.image = UIImage(named: emotion!.emotionName)
        }
    }
    

}
