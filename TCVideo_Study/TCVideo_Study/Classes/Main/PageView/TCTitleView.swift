//
//  TCTitleView.swift
//  TCPageView
//
//  Created by tcan on 17/5/23.
//  Copyright © 2017年 tcan. All rights reserved.
//
/*
 
 titleview:外部接收frame，标题数组，样式
 根据标题数组创建label数组添加到scrollview，增加tap事件
 
 */

import UIKit

protocol TCTitleViewDelegate : class {
    func titleView(_ titleView : TCTitleView, selectedIndex index : Int)
}

class TCTitleView: UIView {

    // MARK: 定义属性
    weak var delegate : TCTitleViewDelegate?
    
    //标题数组
    fileprivate var titles : [String]
    //样式
    fileprivate var style : TCPageStyle
    
    // MARK: 懒加载
    //当前index
    fileprivate lazy var currentIndex : Int = 0
    //标题label数组
    fileprivate lazy var titleLabels : [UILabel] = [UILabel]()
    //scrollview
    fileprivate lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView(frame: self.bounds)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        return scrollView
    }()
    //底部分割线
    fileprivate lazy var splitLineView : UIView = {
        let splitView = UIView()
        splitView.backgroundColor = UIColor.lightGray
        let h : CGFloat = 0.5
        splitView.frame = CGRect(x: 0, y: self.frame.height - h, width: self.frame.width, height: h)
        return splitView
    }()
    //底部标识线
    fileprivate lazy var bottomLine : UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = self.style.bottomLineColor
        bottomLine.frame.size.height = self.style.bottomLineHeight
        return bottomLine
    }()
    //遮罩view
    fileprivate lazy var coverView : UIView = {
        let coverView = UIView()
        coverView.backgroundColor = self.style.coverBgColor
        coverView.alpha = self.style.coverAlpha
        return coverView
    }()
    
    // MARK: 计算属性（title颜色）
    fileprivate lazy var normalColorRGB : (r : CGFloat, g : CGFloat, b : CGFloat) = self.getGRBValue(self.style.normalColor)
    fileprivate lazy var selectedColorRGB : (r : CGFloat, g : CGFloat, b : CGFloat) = self.getGRBValue(self.style.selectColor)
    
    // MARK: 构造函数
    init(frame : CGRect, titles : [String], style : TCPageStyle) {
        
        self.titles = titles
        self.style = style
        
        super.init(frame: frame)
        
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("不能从Xib中加载")
    }

}


// MARK:- 设置UI界面
extension TCTitleView{
    
    fileprivate func setupUI(){
        
        // 1.添加滚动view
        addSubview(scrollView)
        
        // 2.添加title对应的label
        setupTitleLabels()
        
        // 3.设置Label的frame
        setupTitleLabelsFrame()
        
        // 4.设置BottomLine
        setupBottomLine()
        
        // 5.设置CoverView
        setupCoverView()
        
        // 6.添加底部分割线
        addSubview(splitLineView)
    }
    

    private func setupTitleLabels() {
        
        //根据标题数组创建label并加到数组
        for (i, title) in titles.enumerated() {
            // 1.创建Label
            let titleLabel = UILabel()
            
            // 2.设置label的属性
            titleLabel.text = title
            titleLabel.tag = i
            titleLabel.font = style.titleFont
            titleLabel.textColor = i == 0 ? style.selectColor : style.normalColor
            titleLabel.textAlignment = .center
            
            // 3.添加到父控件中
            scrollView.addSubview(titleLabel)
            
            // 4.保存label
            titleLabels.append(titleLabel)
            
            // 5.添加手势
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(_:)))
            titleLabel.addGestureRecognizer(tapGes)
            titleLabel.isUserInteractionEnabled = true
        }
    }

    
    private func setupTitleLabelsFrame() {
        let count = titles.count
        
        for (i, label) in titleLabels.enumerated() {
            var w : CGFloat = 0
            let h : CGFloat = bounds.height
            var x : CGFloat = 0
            let y : CGFloat = 0
            
            if !style.isScrollEnable {
                w = bounds.width / CGFloat(count)
                x = w * CGFloat(i)
            } else {
                w = (titles[i] as NSString).boundingRect(with: CGSize(width : CGFloat.greatestFiniteMagnitude, height: 0), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName : style.titleFont], context: nil).width
                if i == 0 {
                    x = style.titleMargin * 0.5
                } else {
                    let preLabel = titleLabels[i - 1]
                    x = preLabel.frame.maxX + style.titleMargin
                }
            }
            
            label.frame = CGRect(x: x, y: y, width: w, height: h)
            
            if style.isTitleScale && i == 0 {
                label.transform = CGAffineTransform(scaleX: style.scaleRange, y: style.scaleRange)
            }
        }
        
        if style.isScrollEnable {
            
            let contentSizeW = titleLabels.last!.frame.maxX + style.titleMargin * 0.5
            scrollView.contentSize = CGSize(width: contentSizeW, height: 0)
      
        }
    }

    
    private func setupBottomLine() {
        // 1.判断是否需要显示底部线段
        guard style.isShowBottomLine else { return }
        
        // 2.将bottomLine添加到titleView中
        scrollView.addSubview(bottomLine)
        
        // 3.设置frame
        bottomLine.frame.origin.x = titleLabels.first!.frame.origin.x
        bottomLine.frame.origin.y = bounds.height - style.bottomLineHeight
        bottomLine.frame.size.width = titleLabels.first!.bounds.width
    }

    private func setupCoverView() {
        // 1.判断是否需要显示
        guard style.isShowCoverView else { return }
        
        // 2.添加coverView到scrollview中
        scrollView.addSubview(coverView)
        
        // 3.设置frame
        var coverW : CGFloat = titleLabels.first!.frame.width - 2 * style.coverMargin
        if style.isScrollEnable {
            coverW = titleLabels.first!.frame.width + style.titleMargin * 0.5
        }
        let coverH : CGFloat = style.coverHeight
        coverView.bounds = CGRect(x: 0, y: 0, width: coverW, height: coverH)
        coverView.center = titleLabels.first!.center
        
        coverView.layer.cornerRadius = style.coverHeight * 0.5
        coverView.layer.masksToBounds = true
    }

}


// MARK:- 事件处理函数
extension TCTitleView {
    
    @objc fileprivate func titleLabelClick(_ tapGes : UITapGestureRecognizer) {
        // 0.取出点击的Label
        guard let newLabel = tapGes.view as? UILabel else { return }
        
        // 1.改变自身的titleLabel的颜色
        let oldLabel = titleLabels[currentIndex]
        oldLabel.textColor = style.normalColor
        newLabel.textColor = style.selectColor
        currentIndex = newLabel.tag
        
        // 2.通知内容View改变当前的位置
        delegate?.titleView(self, selectedIndex: currentIndex)
        
        // 3.调整BottomLine
        if style.isShowBottomLine {
            bottomLine.frame.origin.x = newLabel.frame.origin.x
            bottomLine.frame.size.width = newLabel.frame.width
        }
        
        // 4.调整缩放比例
        if style.isTitleScale {
            newLabel.transform = oldLabel.transform
            oldLabel.transform = CGAffineTransform.identity
        }
        
        // 5.调整位置
        titleViewAdjustPosition()
        
        // 6.调整coverView的位置
        if style.isShowCoverView {
            let coverW = style.isScrollEnable ? (newLabel.frame.width + style.titleMargin) : (newLabel.frame.width - 2 * style.coverMargin)
            coverView.frame.size.width = coverW
            coverView.center = newLabel.center
        }
    }
}


//Mark: - 对外暴露方法，pageview可通过方法控制titleview切换
extension TCTitleView{
    
    func setTitleWithProgress(_ progress : CGFloat, sourceIndex : Int, targetIndex : Int) {
        // 1.取出sourceLabel/targetLabel
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        // 3.颜色的渐变(复杂)
        // 3.1.取出变化的范围
        let colorDelta = (selectedColorRGB.0 - normalColorRGB.0, selectedColorRGB.1 - normalColorRGB.1, selectedColorRGB.2 - normalColorRGB.2)
        
        // 3.2.变化sourceLabel
        sourceLabel.textColor = UIColor(r: selectedColorRGB.0 - colorDelta.0 * progress, g: selectedColorRGB.1 - colorDelta.1 * progress, b: selectedColorRGB.2 - colorDelta.2 * progress)
        
        // 3.2.变化targetLabel
        targetLabel.textColor = UIColor(r: normalColorRGB.0 + colorDelta.0 * progress, g: normalColorRGB.1 + colorDelta.1 * progress, b: normalColorRGB.2 + colorDelta.2 * progress)
        
        // 4.记录最新的index
        currentIndex = targetIndex
        
        
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveTotalW = targetLabel.frame.width - sourceLabel.frame.width
        
        // 5.计算滚动的范围差值
        if style.isShowBottomLine {
            bottomLine.frame.size.width = sourceLabel.frame.width + moveTotalW * progress
            bottomLine.frame.origin.x = sourceLabel.frame.origin.x + moveTotalX * progress
        }
        
        // 6.放大的比例
        if style.isTitleScale {
            let scaleDelta = (style.scaleRange - 1.0) * progress
            sourceLabel.transform = CGAffineTransform(scaleX: style.scaleRange - scaleDelta, y: style.scaleRange - scaleDelta)
            targetLabel.transform = CGAffineTransform(scaleX: 1.0 + scaleDelta, y: 1.0 + scaleDelta)
        }
        
        // 7.计算cover的滚动
        if style.isShowCoverView {
            coverView.frame.size.width = style.isScrollEnable ? (sourceLabel.frame.width + 2 * style.coverMargin + moveTotalW * progress) : (sourceLabel.frame.width + moveTotalW * progress)
            coverView.frame.origin.x = style.isScrollEnable ? (sourceLabel.frame.origin.x - style.coverMargin + moveTotalX * progress) : (sourceLabel.frame.origin.x + moveTotalX * progress)
        }
    }
    
    func titleViewAdjustPosition() {
        
        guard style.isScrollEnable else { return }
        
        // 1.获取获取目标的Label
        let newLabel = titleLabels[currentIndex]
        
        //获取新标签和中间位置的偏移量
        var offsetX = newLabel.center.x - scrollView.bounds.width * 0.5
        let maxOffset = scrollView.contentSize.width - bounds.width
        
        if offsetX < 0 {
            offsetX = 0
        }else if offsetX > maxOffset {
            offsetX = maxOffset
        }
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
      
    }
    
    fileprivate func getGRBValue(_ color : UIColor) -> (CGFloat, CGFloat, CGFloat) {
        guard  let components = color.cgColor.components else {
            fatalError("文字颜色请按照RGB方式设置")
        }
        
        return (components[0] * 255, components[1] * 255, components[2] * 255)
    }
}














