//
//  NavViewController.swift
//  TCVideo_Study
//
//  Created by tcan on 17/5/22.
//  Copyright © 2017年 tcan. All rights reserved.
//

import UIKit

class NavViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //---------使用运行时，打印手势中的所有属性------------//
        /*
        var count : UInt32 = 0
        let ivars = class_copyIvarList(UIGestureRecognizer.self, &count)!
        for i in 0..<count {
            let nameP = ivar_getName(ivars[Int(i)])!
            let name = String(cString: nameP)
            print(name)
        }
        */
        //-----------------------------------------------//
        
        //取出滑动返回手势interactivePopGestureRecognizer的target和action
        guard let targets = interactivePopGestureRecognizer!.value(forKey: "_targets") as? [NSObject] else {
            return
        }
        let targetObj = targets[0]
        let target = targetObj.value(forKey: "target")
        let action = Selector(("handleNavigationTransition:"))
        
        //创建pan手势，设置上面获得的target和action
        let panGes = UIPanGestureRecognizer(target: target, action: action)
        
        //pan手势加到当前的view（导航控制器的view）
        view.addGestureRecognizer(panGes)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent;
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.hidesBottomBarWhenPushed = true
        super.pushViewController(viewController, animated: animated)
    }
}
