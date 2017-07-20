//
//  HomeViewController.swift
//  TCVideo_Study
//
//  Created by tcan on 17/5/22.
//  Copyright © 2017年 tcan. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        view.backgroundColor = UIColor(hex: "e0e0e0")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}


//MARK:- UI
extension HomeViewController{
    
    fileprivate func setupUI(){
        setupNavigationBar()
        setupContentView()
    }
    
    private func setupNavigationBar(){
        
        // 2.设置右侧收藏的item
        let collectImage = UIImage(named: "search_btn_follow")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: collectImage, style: .plain, target: self, action: #selector(followItemClick))
        // 事件监听 --> 发送消息 --> 将方法包装SEL  --> 类方法列表 --> IMP
        
        // 3.搜索框
        let searchFrame = CGRect(x: 0, y: 0, width: 200, height: 32)
        let searchBar = UISearchBar(frame: searchFrame)
        searchBar.placeholder = "昵称/房间号/链接"
        navigationItem.titleView = searchBar
        searchBar.searchBarStyle = .minimal
        let searchFiled = searchBar.value(forKey: "_searchField") as? UITextField
        searchFiled?.textColor = UIColor.white
    }
    
    fileprivate func setupContentView() {
        
         automaticallyAdjustsScrollViewInsets = false
        
        //frame
        let pageViewFrame = CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height - 64 - 44)
        
//        //头部标题
//        let titles = ["推荐","热点","搞笑哈哈频道","音乐","体育","娱乐抢先看","汽车"]
        //获取头部标题数据
        let homeCategoryTypes = loadCategoryTypeData()
        //遍历数组，取出每个模型的title属性
        let titles = homeCategoryTypes.map({ $0.title })
        
        /*
        let titles1 = homeCategoryTypes.map { (type : HomeCategoryType) -> String in
            return type.title
        }
        */
 
        //样式
        let style = TCPageStyle()
        style.isScrollEnable = true
        style.isTitleScale = true
        style.isShowCoverView = false
        
        //初始化所有控制器
        var childVCs = [WaterfallViewController]()
        
        for type in homeCategoryTypes {
            let vc = WaterfallViewController()
            vc.homeType = type
            childVCs.append(vc)
        }
        
        //根据上面参数创建pageview
        let pageView = TCPageView(frame: pageViewFrame, titles: titles, titleStyle: style, childVCs: childVCs, parentVC: self)
        
        //将pageview添加到当前控制器
        view.addSubview(pageView)
    }
    
    
    /// 读取文件中的主页title分类
    ///
    /// - Returns: 主页title分类
    fileprivate func loadCategoryTypeData() -> [HomeCategoryType]{
        
        //文件路径
        let path = Bundle.main.path(forResource: "types.plist", ofType: nil)!
        //根据文件路径获取的字典数组
        let dictArray = NSArray(contentsOfFile: path) as! [[String : Any]]
        //字典数组转模型数组
        var modelArray = [HomeCategoryType]()
        for dict in dictArray {
            modelArray .append(HomeCategoryType(dict: dict))
        }
        
        return modelArray
        
    }
    
}

// MARK:- 事件监听函数
extension HomeViewController {
    @objc fileprivate func followItemClick() {
        print("------")
    }
}
