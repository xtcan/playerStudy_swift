//
//  EmotionView.swift
//  TCVideo_Study
//
//  Created by tcan on 2017/7/18.
//  Copyright © 2017年 tcan. All rights reserved.
//

import UIKit

private let kEmoticonCell = "kEmoticonCell"

class EmotionView: UIView {

    ///点击某个item的回调
    var emotionClickCallback : ((Emotion) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//Mark: - 设置UI
extension EmotionView {
    
    fileprivate func setupUI(){
        
        let titles = ["热门","常见"]
        let style = TCPageStyle()
        style.isShowBottomLine = true
        
        let layout = TCInputIconChooseViewLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.cols = 7
        layout.rows = 3
        
        let pageCollectionView = TCInputIconChooseView(frame: bounds, titles: titles, titleStyle: style, isTitleInTop: false, layout: layout)
        pageCollectionView.dataSource = self
        pageCollectionView.delegate = self
        pageCollectionView.register(nib: UINib(nibName: "EmotionViewCell", bundle: nil), identifier: kEmoticonCell)
        
        addSubview(pageCollectionView)
    }
}

//Mark: - 数据源方法
extension EmotionView : TCInputIconChooseViewDataSource{
    ///组数
    func numberOfSections(in inputIconCollectionView: TCInputIconChooseView) -> Int {
        return EmotionViewModel.shareInstance.packages.count
    }
    
    ///item数
    func inputIconCollectionView(_ inputIconChooseView: TCInputIconChooseView, numberOfItemsInSection section: Int) -> Int {
       
        return EmotionViewModel.shareInstance.packages[section].emotions.count
    }
    
    ///每一个item
    func inputIconCollectionView(_ inputIconChooseView: TCInputIconChooseView, _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kEmoticonCell, for: indexPath) as! EmotionViewCell
        
        cell.emotion = EmotionViewModel.shareInstance.packages[indexPath.section].emotions[indexPath.item]
        
        return cell
    }
}

extension EmotionView : TCInputIconChooseViewDelegate{
   
    func inputIconCollectionView(_ inputIconChooseView: TCInputIconChooseView, didSelectItemAt indexPath: IndexPath) {
        //取出当前点击的模型数据
        let emo = EmotionViewModel.shareInstance.packages[indexPath.section].emotions[indexPath.item]
        if (emotionClickCallback != nil) {
            emotionClickCallback!(emo)
        }
    }
    
}










