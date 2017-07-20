//
//  KingfisherExtension.swift
//  TCVideo_Study
//
//  Created by tcan on 17/6/19.
//  Copyright © 2017年 tcan. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {

    func setImage(_ URLString : String?, _ placeHolderName : String?) {
        guard let URLString = URLString else {
            return
        }
        
        guard let placeHolderName = placeHolderName else {
            return
        }
        
        guard let url = URL(string: URLString) else { return }
        kf.setImage(with: url, placeholder : UIImage(named: placeHolderName))
    }

}
