//
//  ViewController.swift
//  ColorFulTabBar
//
//  Created by Broccoli on 15/11/12.
//  Copyright © 2015年 Broccoli. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBarController = UITabBarController()
        
        for _ in 0 ..< 5 {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor(red: CGFloat(arc4random() % 10) / 10.0, green: CGFloat(arc4random() % 10) / 10.0, blue: CGFloat(arc4random() % 10) / 10.0, alpha: 1.0)
            tabBarController.addChildViewController(vc)
        }
        
        let tabbar = ColorFulTabBar(frame: tabBarController.tabBar.frame)
        tabBarController.setValue(tabbar, forKey: "tabBar")
        
        view.addSubview(tabBarController.view)
        addChildViewController(tabBarController)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

