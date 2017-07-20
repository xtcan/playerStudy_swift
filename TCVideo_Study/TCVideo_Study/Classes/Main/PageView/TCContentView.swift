//
//  TCContentView.swift
//  TCPageView
//
//  Created by tcan on 17/5/23.
//  Copyright © 2017年 tcan. All rights reserved.
//

import UIKit

@objc protocol TCContentViewDelegate : class {
    func contentView(_ contentView : TCContentView, progress : CGFloat, sourceIndex : Int, targetIndex : Int)
//    func contentView(_ contentView : TCContentView, targetIndex : Int, progress : CGFloat)
//    func contentView(_ contentView : TCContentView, endScroll inIndex : Int)
    @objc optional func contentViewEndScroll(_ contentView : TCContentView)
}

//cell ID
private let kContentCellId = "kContentCellId"

class TCContentView: UIView {

    //Mark: 定义属性
    weak var delegate : TCContentViewDelegate?
    
    fileprivate var childVCs : [UIViewController]
    fileprivate var parentVC : UIViewController
    
    //懒加载
    fileprivate lazy var startOffsetX : CGFloat = 0
    fileprivate lazy var isForbidDelegate : Bool = false
    
    fileprivate lazy var collectionView : UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kContentCellId)
        collectionView.isPagingEnabled = true
        collectionView.scrollsToTop = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        
        return collectionView
    }()
    
    // MARK: 构造函数
    init(frame: CGRect, childVCs: [UIViewController], parentVC: UIViewController) {
        
        self.childVCs = childVCs
        self.parentVC = parentVC
        
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK:- 设置UI界面
extension TCContentView {
    fileprivate func setupUI() {
        // 1.将childVc添加到父控制器中
        for vc in childVCs {
            parentVC.addChildViewController(vc)
        }
        
        // 2.初始化用于显示子控制器View的View（UIScrollView/UICollectionView）
        addSubview(collectionView)
    }
}

// MARK:- 遵守UICollectionViewDataSource协议
extension TCContentView : UICollectionViewDataSource{
    
    //行数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVCs.count
    }
    
    //每一个cell，并把子控制器的view加到contentview
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentCellId, for: indexPath)
        
        //先移除
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        //再添加
        let vc = childVCs[indexPath.item]
        vc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(vc.view)
        
        return cell
    }
}


// MARK:- 遵守UICollectionViewDelegate协议
extension TCContentView : UICollectionViewDelegate{
    
    //开始拖拽
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        // 记录开始的位置
        isForbidDelegate = false
        startOffsetX = scrollView.contentOffset.x
    }
    
    //滚动回调
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //当前位置就是开始拖动位置或者titleview的点击代理触发当前 scroll
        if scrollView.contentOffset.x == startOffsetX || isForbidDelegate { return }
        
        // 1.定义目标的index、进度
        var targetIndex : Int = 0
        var sourceIndex : Int = 0
        var progress : CGFloat = 0
        
        // 2.判断用户是左滑还是右滑
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewWidth = scrollView.bounds.width
        
        if currentOffsetX > startOffsetX {
            // 左滑往右下一页
            // 计算已经滑动的比例progress
            progress = currentOffsetX / scrollViewWidth - floor(currentOffsetX / scrollViewWidth)
            
            sourceIndex = Int(currentOffsetX / scrollViewWidth)
            //获取滑动到的index
            targetIndex = sourceIndex + 1
            
            if targetIndex >= childVCs.count {
                //超过最后一个，就是最后一个
                targetIndex = childVCs.count - 1
            }
            // 如果完全划过去
            if currentOffsetX - startOffsetX == scrollViewWidth {
                progress = 1
                targetIndex = sourceIndex
            }
            
        } else {
            // 右滑
            progress = 1 - (currentOffsetX / scrollViewWidth - floor(currentOffsetX / scrollViewWidth))
            // 2.计算targetIndex
            targetIndex = Int(currentOffsetX / scrollViewWidth)
            
            // 3.计算sourceIndex
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVCs.count {
                sourceIndex = childVCs.count - 1
            }
        }
        
        // 3.将progress/sourceIndex/targetIndex传递给pageview再去控制titleView
        delegate?.contentView(self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
    
    //减速停止
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        collectionViewDidEndScroll()
    }
    
    //拖拽停止
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if !decelerate {
            collectionViewDidEndScroll()
        }
    }
    
    private func collectionViewDidEndScroll(){
        
        // 1.获取结束时，对应的indexPath
//        let endIndex = Int(collectionView.contentOffset.x / collectionView.bounds.width)
        
        // 2.通知titleView改变下标
//        delegate?.contentView(self, endScroll: endIndex)
        
        //通知pageview去控制titleView改变下标
        delegate?.contentViewEndScroll?(self)
        
    }
    
}


// MARK:- 对外暴露的方法
extension TCContentView{
    
//    //点击title，scroll到相应位置
//    func titleView(_ titleView: TCTitleView, didSelected currentIndex: Int) {
//        
//        isForbidDelegate = true
//        
//        let indexPath = IndexPath(item: currentIndex, section: 0)
//        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
//    }
    func setCurrentIndex(_ currentIndex : Int) {
        
        // 1.记录需要进制执行代理方法
        isForbidDelegate = true
        
        // 2.滚动正确的位置
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
}











