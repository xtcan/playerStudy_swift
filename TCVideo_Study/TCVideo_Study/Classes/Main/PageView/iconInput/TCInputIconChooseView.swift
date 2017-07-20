//
//  TCInputIconChooseView.swift
//  TCVideo_Study
//
//  Created by tcan on 17/6/20.
//  Copyright © 2017年 tcan. All rights reserved.
//  表情选择view

import UIKit

protocol TCInputIconChooseViewDataSource : class {
    
    /// 多少组
    ///
    /// - Parameter inputIconCollectionView: TCInputIconChooseView
    /// - Returns: 组数
    func numberOfSections(in inputIconCollectionView : TCInputIconChooseView) -> Int
    
    /// 某组多少个item
    ///
    /// - Parameters:
    ///   - inputIconChooseView: TCInputIconChooseView
    ///   - section: 组
    /// - Returns: 该组多少个item
    func inputIconCollectionView(_ inputIconChooseView : TCInputIconChooseView, numberOfItemsInSection section : Int) -> Int
    
    
    /// 初始化cell
    ///
    /// - Parameters:
    ///   - inputIconChooseView: TCInputIconChooseView
    ///   - collectionView: UICollectionView
    ///   - indexPath: indexPath
    /// - Returns: cell
    func inputIconCollectionView(_ inputIconChooseView : TCInputIconChooseView, _ collectionView : UICollectionView, cellForItemAt indexPath : IndexPath) -> UICollectionViewCell
}

protocol TCInputIconChooseViewDelegate : class{
    
    /// 选中某个item
    func inputIconCollectionView(_ inputIconChooseView : TCInputIconChooseView, didSelectItemAt indexPath: IndexPath)
}

class TCInputIconChooseView: UIView {

    weak var dataSource : TCInputIconChooseViewDataSource?
    weak var delegate : TCInputIconChooseViewDelegate?
    
    fileprivate var titles : [String]
    fileprivate var isTitleInTop : Bool
    fileprivate var layout : TCInputIconChooseViewLayout
    fileprivate var style : TCPageStyle
    fileprivate var titleView : TCTitleView!
    fileprivate var pageControl : UIPageControl!
    fileprivate var collectionView : UICollectionView!
    fileprivate var sourceIndexPath : IndexPath = IndexPath(item: 0, section: 0)
    
    init(frame: CGRect, titles : [String], titleStyle : TCPageStyle, isTitleInTop : Bool, layout : TCInputIconChooseViewLayout) {
        self.titles = titles
        self.isTitleInTop = isTitleInTop
        self.layout = layout
        self.style = titleStyle
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


//Mark: - 设置UI
extension TCInputIconChooseView{
    
    /// 设置UI
    fileprivate func setupUI() {
        //创建titleview
        let titleY = isTitleInTop ? 0 : bounds.height - style.titleViewHeight
        let titleFrame = CGRect(x: 0, y: titleY, width: bounds.width, height: style.titleViewHeight)
        style.isScrollEnable = false
        titleView = TCTitleView.init(frame: titleFrame, titles: titles, style: style)
        addSubview(titleView)
        titleView.delegate = self
        titleView.backgroundColor = UIColor.randomColor()
        
        //创建UIpagecontrol
        let pageControlHeight : CGFloat = 20
        let pageControlY = isTitleInTop ? (bounds.height - pageControlHeight) : (bounds.height - pageControlHeight - style.titleViewHeight)
        let pageControlFrame = CGRect(x: 0, y: pageControlY, width: bounds.width, height: pageControlHeight)
        pageControl = UIPageControl(frame: pageControlFrame)
        pageControl.numberOfPages = 4
        pageControl.isEnabled = false
        addSubview(pageControl)
        pageControl.backgroundColor = UIColor.randomColor()
        
        //创建UIcollectionview
        let collectionViewY = isTitleInTop ? style.titleViewHeight : 0
        let collectionViewFrame = CGRect(x: 0, y: collectionViewY, width: bounds.width, height: bounds.height - style.titleViewHeight - pageControlHeight)
        collectionView = UICollectionView(frame: collectionViewFrame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        addSubview(collectionView)
        collectionView.backgroundColor = UIColor.randomColor()
        
    }
}


//Mark: - 对外暴露方法
extension TCInputIconChooseView {
    
    func register(cell : AnyClass?, identifier : String) {
        collectionView.register(cell, forCellWithReuseIdentifier: identifier)
    }
    
    func register(nib : UINib, identifier : String) {
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
}


extension TCInputIconChooseView : UICollectionViewDelegate,UICollectionViewDataSource {
    
    //多少组
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return dataSource?.numberOfSections(in: self) ?? 0
    }
    
    //组内多少个item
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemCount = dataSource?.inputIconCollectionView(self, numberOfItemsInSection: section) ?? 0
        if section == 0 {
            pageControl.numberOfPages = (itemCount - 1) / (layout.cols * layout.rows) + 1
        }
        
        return itemCount
    }
    
    //对应cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return (dataSource!.inputIconCollectionView(self, collectionView, cellForItemAt: indexPath))
    }
    
    //滑动减速到停止
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewEndScroll()
    }
    
    //停止拖动
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollViewEndScroll()
    }
    
    fileprivate func scrollViewEndScroll() {
        // 1.取出在屏幕中显示的Cell
        let point = CGPoint(x: layout.sectionInset.left + 1 + collectionView.contentOffset.x, y: layout.sectionInset.top + 1)
        guard let indexPath = collectionView.indexPathForItem(at: point) else { return }
        
        // 2.判断分组是否有发生改变
        if sourceIndexPath.section != indexPath.section {
            // 3.1.修改pageControl的个数
            let itemCount = dataSource?.inputIconCollectionView(self, numberOfItemsInSection: indexPath.section) ?? 0
            pageControl.numberOfPages = (itemCount - 1) / (layout.cols * layout.rows) + 1
            
            // 3.2.设置titleView位置
            titleView.setTitleWithProgress(1.0, sourceIndex: sourceIndexPath.section, targetIndex: indexPath.section)
            
            // 3.3.记录最新indexPath
            sourceIndexPath = indexPath
        }
        
        // 3.根据indexPath设置pageControl
        pageControl.currentPage = indexPath.item / (layout.cols * layout.rows)
    }
}


extension TCInputIconChooseView : TCTitleViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.inputIconCollectionView(self, didSelectItemAt: indexPath)
    }
    
    func titleView(_ titleView: TCTitleView, selectedIndex currentIndex: Int) {
        
        let indexPath = IndexPath(item: 0, section: currentIndex)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        collectionView.contentOffset.x -= layout.sectionInset.left
        
        scrollViewEndScroll()
    }
}



