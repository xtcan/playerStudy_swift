//
//  TCInputIconChooseViewLayout.swift
//  TCVideo_Study
//
//  Created by tcan on 17/6/20.
//  Copyright © 2017年 tcan. All rights reserved.
//

import UIKit

class TCInputIconChooseViewLayout: UICollectionViewFlowLayout {

    //行数
    var rows : Int = 2
    //列数
    var cols : Int = 4
    
    //样式数组
    fileprivate lazy var cellAttrs : [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    //contentSize的宽度
    fileprivate lazy var maxWidth : CGFloat = 0
}

extension TCInputIconChooseViewLayout {
    
    //每一页从左到右排，然后换行，然后换页，然后换组
    //每一个item的x，就是（前面所有组的总页数+当前组的页序）* 面板宽度 + item在当前页的偏移位置
    
    override func prepare() {
        super.prepare()
        
        //计算item的宽高
        let itemWidth = (collectionView!.bounds.width - sectionInset.left - sectionInset.right - minimumInteritemSpacing * CGFloat(cols - 1)) / CGFloat(cols)
        let itemHeight = (collectionView!.bounds.height - sectionInset.top - sectionInset.bottom - minimumLineSpacing * CGFloat(rows - 1)) / CGFloat(rows)
        
        //获取多少组
        let sectionCount = collectionView!.numberOfSections
        
        var prePageCount : Int = 0
        //遍历所有组
        for i in 0..<sectionCount {
            //获取该组多少item
            let itemCount = collectionView!.numberOfItems(inSection: i)
            //遍历每一组
            for j in 0..<itemCount {
                //获取对应的indexpath
                let indexPath = IndexPath(item: j, section: i)
                
                //根据indexpath创建样式
                let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                //在该组的第几页（注意，下标从0开始）
                let page = j / (cols * rows)
                //在该页的index
                let index = j % (cols * rows)
                //当前所在的总页数 =（前面的组共有多少页＋该item在本组的第几页）
                //当前item所在页的最左边位置 = 当前所在的总页数 * collectionview宽度
                //CGFloat(index % cols)在横方向的index，0～cols-1
                let itemX = CGFloat(prePageCount + page) * collectionView!.bounds.width + sectionInset.left + (itemWidth + minimumInteritemSpacing) * CGFloat(index % cols)
                let itemY = sectionInset.top + (itemHeight + minimumLineSpacing) * CGFloat(index / cols)
                //设置样式的frame
                attr.frame = CGRect(x: itemX, y: itemY, width: itemWidth, height: itemHeight)
                
                //把样式保存到数组中
                cellAttrs.append(attr)
            }
            //前面的组有多少页
            prePageCount += (itemCount - 1) / (cols * rows) + 1
        }
        
        //计算目前宽度最大值，用于最后设置contentsize
        maxWidth = CGFloat(prePageCount) * collectionView!.bounds.width
    }
}


// MARK: - 返回所有的样式
extension TCInputIconChooseViewLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cellAttrs
    }
}


// MARK: - 返回collectionview的contentsize
extension TCInputIconChooseViewLayout {
    override var collectionViewContentSize: CGSize{
        return CGSize(width: maxWidth, height: 0)
    }
}
