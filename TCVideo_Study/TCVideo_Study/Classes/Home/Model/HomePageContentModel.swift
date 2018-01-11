//
//  HomePageContentModel.swift
//  TCVideo_Study
//
//  Created by tcan on 17/5/27.
//  Copyright © 2017年 tcan. All rights reserved.
//

import UIKit

class HomePageContentModel: BaseModel {

    /*
    "avatar": "https://file.qf.56.com/p/group3/M10/0B/69/MTAuMTAuODguODM=/dXBsb2FkRmlsZV8xXzE0ODc5MzA4NTkzNzg=/cut@m=crop,x=0,y=189,w=1197,h=1197_cut@m=resize,w=100,h=100.jpg",
    "uid": "shunm_5610029265",
    "roomid": "6876139",
    "name": "可爱橘里",
    "pic51": "https://file.qf.56.com/p//group3/M03/0C/02/MTAuMTAuODguODQ=/dXBsb2FkRmlsZV8xXzE0ODk0MTcwNDM4NzY=/cut@m=crop,x=0,y=0,w=510,h=510_cut@m=resize,w=510,h=510.png",
    "pic74": "https://file.qf.56.com/p//group3/M07/0C/0B/MTAuMTAuODguODM=/dXBsb2FkRmlsZV8xXzE0ODkzOTYyOTcwOTY=/cut@m=crop,x=0,y=0,w=510,h=740_cut@m=resize,w=510,h=740.png",
    "live": 1,
    "push": 2,
    "focus": 2181,
    "charge": 0,
    "mic": 0,
    "weeklyStar": 0,
    "yearParty": 0,
    "gameName": "",
    "gameIcon": "",
    "gameId": 0
    */
    var uid : String = ""
    var roomid : Int = 0
    var name : String = ""
    var pic51 : String = ""
    var pic74 : String = ""
    var live : Int = 0 // 是否在直播
    var push : Int = 0 // 直播显示方式
    var focus : Int = 0 // 关注数
    
    var isEvenIndex : Bool = false
    
}
