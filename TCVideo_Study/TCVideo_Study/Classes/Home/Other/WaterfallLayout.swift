//
//  WaterfallLayout.swift
//  WaterfallLayout
//
//  Created by tcan on 17/5/24.
//  Copyright © 2017年 tcan. All rights reserved.
//

/*
 
 原理：
 
 对外设置datasource属性，设置两个datasource方法，让datasource设置列数，对应indexpath的随机高度
 
 1、prepare 方法调用一次：创建一个样式数组（对应indexpath元素的frame）
 先创建一个数组，用来记录每一行元素的底部位置，默认元素为列数个组顶部内边距
 
 宽度：从datasource中取出列数，根据间距和列数可以算出item的宽度
 
 高度：遍历所有元素，创建indexpath，根据indexpath从datasource中取出对应项随机高度，
 
 需要从数组中取出高度最小的一项，因为要在这一项底部放对应indexpath元素
 
 x：根据数组中高度最小一项index，计算x
 y：根据高度最小一项底部加行距，即maxY + minimumLineSpacing
 
 把数组中最小一项替换成新增元素的底部位置
 
 
 2、layoutAttributesForElements方法：返回样式数组
 
 3、设置返回collectionview contentsize
 根据每一行元素的底部位置数组，可以得到最底部的y
 
 */

import UIKit

@objc protocol WaterfallLayoutDataSource : class {
    
    //对应indexpath item的高度
    func waterfallLayout(_ layout : WaterfallLayout, indexPath : IndexPath) -> CGFloat
    
    //需要显示多少列
    @objc optional func numberOfColsInWaterfallLayout(_ layout : WaterfallLayout) -> Int
    
}


class WaterfallLayout: UICollectionViewFlowLayout {
    
    //Mark: - 对外提供属性
    //数据源
    weak var dataSource : WaterfallLayoutDataSource?
    
    //Mark: - 私有属性
    //样式数组
    fileprivate lazy var attrsArray : [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    
    //总高度
    fileprivate var totalHeight : CGFloat = 0
    
    //列高数组
    fileprivate lazy var colHeight : [CGFloat] = {
        
        //列数，数据源不一定有，若无，?? 后是默认值2
        let cols = self.dataSource?.numberOfColsInWaterfallLayout?(self) ?? 2
        //高度数组，初始化为列数个顶部inset
        var colHeights = Array(repeatElement(self.sectionInset.top, count: cols))
        return colHeights
    }()
    
    //最大高
    fileprivate var maxH : CGFloat = 0
    //起始index
    fileprivate var startIndex = 0
    
}

//Mark: - 创建样式数组
extension WaterfallLayout {
    
    override func prepare() {
        
        super.prepare()
        
        //获取item的个数
        let itemCount = collectionView!.numberOfItems(inSection: 0)
        
        //获取列数
        let cols = dataSource?.numberOfColsInWaterfallLayout?(self) ?? 2
        
        //计算item的宽度
        let itemW = (collectionView!.bounds.width - self.sectionInset.left - self.sectionInset.right - self.minimumInteritemSpacing * (CGFloat(cols)-1)) / CGFloat(cols)
        
        //计算所有item的属性
        for i in startIndex..<itemCount{
            
            //根据i创建indexpath
            let indexPath = IndexPath(item: i, section: 0)
            
            //根据indexpath创建对应的uicollectionviewlayoutattributes
            let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            // 随机一个高度
            guard let height = dataSource?.waterfallLayout(self, indexPath: indexPath) else {
                fatalError("请设置数据源,并且实现对应的数据源方法")
            }
            
            //取出高度最小列的高度
            let minH = colHeight.min()!
            //取出高度最小列的位置
            let index = colHeight.index(of: minH)!
            //高度最小项的下面item的y = 最小项maxY+行距
            let minHItemNextItemY = minH + height + minimumLineSpacing
            //更改高度数组中该项的值
            colHeight[index] = minHItemNextItemY
            
            let x = self.sectionInset.left + (self.minimumInteritemSpacing + itemW) * CGFloat(index)
            let y = minHItemNextItemY - height - self.minimumLineSpacing
            
            
            //设置attr中的frame
            attr.frame = CGRect(x: x, y: y, width: itemW, height: height)
            
            //保存attr
            attrsArray.append(attr)
            
        }
        
        //记录最大值（用来设置contentsize）
        maxH = colHeight.max()!
        
        //重新设置起始index
        startIndex = itemCount
        
    }
    
}


//Mark: - 返回准备好所有布局
extension WaterfallLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attrsArray
    }
    
    //设置collectionview contentsize
    override var collectionViewContentSize: CGSize{
        
        return CGSize(width: 0, height: maxH + sectionInset.bottom - minimumLineSpacing)
        
    }
    
}



















