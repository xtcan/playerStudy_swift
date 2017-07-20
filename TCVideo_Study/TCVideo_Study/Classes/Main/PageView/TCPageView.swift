//
//  TCPageView.swift
//  TCPageView
//
//  Created by tcan on 17/5/23.
//  Copyright © 2017年 tcan. All rights reserved.
//
//  包含titleview和contentview，他们的代理都设为pageview，当切换title的时候偏移contentview，当滑动contentview的时候切换title
//  contentview里面放collectionview，每个item都是流水布局的控制器的view

import UIKit

class TCPageView: UIView {

    // MARK:- 定义属性
    fileprivate var titles : [String]
    fileprivate var childVCs : [UIViewController]
    fileprivate var parentVC : UIViewController
    fileprivate var titleStyle : TCPageStyle
    
    fileprivate var titleView : TCTitleView!
    fileprivate var contentView : TCContentView!
    
    // MARK:- 构造函数
    init(frame: CGRect, titles : [String], titleStyle : TCPageStyle, childVCs :[UIViewController], parentVC : UIViewController) {
        
        //super前得得先把所有属性初始化
        self.titles = titles
        self.childVCs = childVCs
        self.parentVC = parentVC
        self.titleStyle = titleStyle
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK:- 设置UI
extension TCPageView{
    
    fileprivate func setupUI(){
        
        // 1.添加titleView到pageView中
        let titleViewFrame = CGRect(x: 0, y: 0, width: bounds.width, height: titleStyle.titleViewHeight)
        titleView = TCTitleView(frame: titleViewFrame, titles: titles, style : titleStyle)
        addSubview(titleView)
        titleView.backgroundColor = UIColor.randomColor()
        titleView.delegate = self
        
        // 2.添加contentView到pageView中
        let contentViewFrame = CGRect(x: 0, y: titleView.frame.maxY, width: bounds.width, height: frame.height - titleViewFrame.height)
        contentView = TCContentView(frame: contentViewFrame, childVCs: childVCs, parentVC: parentVC)
        addSubview(contentView)
        contentView.backgroundColor = UIColor.randomColor()
        contentView.delegate = self
     
    }
    
}


//Mark: - titleview代理方法，切换title，控制contentview 切换
extension TCPageView : TCTitleViewDelegate{
    
    func titleView(_ titleView: TCTitleView, selectedIndex index: Int) {
        contentView.setCurrentIndex(index)
    }
}


//Mark: - contentview代理方法，滑动contentview，根据progress控制title切换效果
extension TCPageView : TCContentViewDelegate{
    
    func contentView(_ contentView: TCContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        titleView.setTitleWithProgress(progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
    
    func contentViewEndScroll(_ contentView: TCContentView) {
        titleView.titleViewAdjustPosition()
    }
    
}
