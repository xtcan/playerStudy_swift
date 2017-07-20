//
//  WaterfallViewController.swift
//  TCVideo_Study
//
//  Created by tcan on 17/5/27.
//  Copyright © 2017年 tcan. All rights reserved.
//

import UIKit

private let kMargin : CGFloat = 8
private let kCellId = "kCellId"

class WaterfallViewController: UIViewController {

    // MARK: 对外属性
    var homeType : HomeCategoryType!
    
    //Mark: - 定义属性
    fileprivate lazy var homeVM : HomeViewModel = HomeViewModel()
    fileprivate lazy var collectionView : UICollectionView = {
        
        let layout = WaterfallLayout()
        layout.sectionInset = UIEdgeInsets(top: kMargin, left: kMargin, bottom: kMargin, right: kMargin)
        
        layout.minimumLineSpacing = kMargin
        layout.minimumInteritemSpacing = kMargin
        
        layout.dataSource = self
        
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: "HomeContentCell", bundle: nil), forCellWithReuseIdentifier: kCellId)
        
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = UIColor.orange
        return collectionView
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置UI
        setupUI()
        //加载数据
        loadData(index: 0)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


extension WaterfallViewController {
    
   fileprivate func setupUI() {
        view.addSubview(collectionView)
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kCellId)
    }
}


extension WaterfallViewController {
    
    fileprivate func loadData(index : Int){
        homeVM.loadHomeData(type: homeType, index: index, finishedCallback: {
            self.collectionView.reloadData()
        })
    }
}

//MARK:- collectionview数据源&代理
extension WaterfallViewController : UICollectionViewDataSource, UICollectionViewDelegate , WaterfallLayoutDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeVM.homePageContentModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellId, for: indexPath) as! HomeContentCell
        
        cell.contentModel = homeVM.homePageContentModels[indexPath.item]
        
        //滚到最下面的时候加载数据
        if indexPath.item == homeVM.homePageContentModels.count - 1 {
            loadData(index: homeVM.homePageContentModels.count)
        }
        
        cell.backgroundColor = UIColor.white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let roomVc = RoomViewController()
        navigationController?.pushViewController(roomVc, animated: true)
    }
    
    func waterfallLayout(_ layout: WaterfallLayout, indexPath: IndexPath) -> CGFloat {
        return indexPath.item % 2 == 0 ? kScreenW * 1 / 2 : kScreenW * 1 / 3
    }
    
    func numberOfColsInWaterfallLayout(_ layout: WaterfallLayout) -> Int {
        return 3
    }
    
}

