//
//  NibLoadable.swift
//  TCVideo_Study
//
//  Created by tcan on 17/6/20.
//  Copyright © 2017年 tcan. All rights reserved.
//

import UIKit


protocol NibLoadable {
    
}

extension NibLoadable where Self : UIView{
    
   static func loadFromNib(_ nibname : String? = nil) -> Self {
        let loadName = nibname == nil ? "\(self)" : nibname!
        return Bundle.main.loadNibNamed(loadName, owner: nil, options: nil)?.first as! Self
        
    }
    
}
