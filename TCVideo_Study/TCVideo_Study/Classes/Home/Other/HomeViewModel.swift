//
//  HomeViewModel.swift
//  TCVideo_Study
//
//  Created by tcan on 17/5/27.
//  Copyright © 2017年 tcan. All rights reserved.
//

//获取数据

import UIKit

class HomeViewModel: NSObject {

    lazy var homePageContentModels = [HomePageContentModel]()
}

extension HomeViewModel{
    
    func loadHomeData(type : HomeCategoryType, index : Int, finishedCallback : @escaping () -> ()) {
        NetworkTool.requestData(.get, URLString: "http://qf.56.com/home/v4/moreAnchor.ios", parameters: ["type" : type.type, "index" : index, "size" : 48]) { (result) -> Void in
            
            guard let resultDict = result as? [String : Any] else { return }
            guard let messageDict = resultDict["message"] as? [String : Any] else {return}
            guard let dataArray = messageDict["anchors"] as? [[String : Any]] else { return }
            
            //遍历数据
            for (index , dict) in dataArray.enumerated() {
                //字典转模型
                let contentModel = HomePageContentModel(dict : dict)
                contentModel.isEvenIndex = index % 2 == 0
                self.homePageContentModels .append(contentModel)
                
            }
            finishedCallback()
        }
        
    }
}
