//
//  ColorFulTabBar.swift
//  ColorFulTabBar
//
//  Created by Broccoli on 15/11/12.
//  Copyright © 2015年 Broccoli. All rights reserved.
//

import UIKit

class ColorFulTabBar: UITabBar {
    
    /// tabbar item 的个数 默认是 四个
    var itemCount = 5
    /// tabbar item 的 四个颜色 默认是 红蓝黄绿
    var itemColors = [UIColor.redColor(), UIColor.blueColor(), UIColor.yellowColor(), UIColor.greenColor(), UIColor.purpleColor()]
    
    /// 彩色的 view
    lazy private var colorfulView: UIView = UIView(frame: self.bounds)
    /// 需要显示的 视窗
    lazy private var colorfulMaskView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.colorfulItemWidth, height: self.bounds.height))
        view.backgroundColor = UIColor.blackColor()
        return view
    }()
    /// tabbar 之前 选中的 index
    var fromeIndex = 1
    /// tabbar 即将 选中的 index
    var toIndex = 1
   
    /// 只读 计算属性  单个 item width
    private var colorfulItemWidth: CGFloat {
        return bounds.width / CGFloat(itemCount)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        /// 初始化 并设置 colorView
        setupColorView()
        
        /// 将遮罩层 作为 彩色 view 的遮罩
        colorfulView.layer.mask = colorfulMaskView.layer
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 因为tabbar设置代理先后顺序的原因，如果在初始化时，就将代理设置为自己，系统会在添加到UITabbarController上的时候，将代理设置为UITabbarController
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        delegate = self
    }
    
    private func setupColorView() {
        addSubview(colorfulView)
        
        for i in 0 ..< itemCount {
            let singleItem = UIView(frame: CGRect(x: colorfulItemWidth * CGFloat(i), y: 0, width: colorfulItemWidth, height: bounds.height))
            singleItem.backgroundColor = itemColors[i]
            colorfulView.addSubview(singleItem)
        }
    }
}

extension ColorFulTabBar {
    func moveAnimation() {
        /// 遮罩每次移动时，都先会多出来一部分，然后再到另一个index，这个变量用来设置多出来那部分的宽度
        let extraWidth = colorfulItemWidth / 4
         /// 根据多出来的部分，设置frame
        let scaleFrame: CGRect
        
        // 判断遮罩层应该滑动的方向，来修改多出来部分的frame
        if fromeIndex > toIndex {
            scaleFrame = CGRect(x: CGRectGetMinX(colorfulMaskView.frame) - extraWidth, y: 0, width: colorfulItemWidth + extraWidth, height: bounds.height)
        } else {
            scaleFrame = CGRect(x: CGRectGetMinX(colorfulMaskView.frame), y: 0, width: colorfulItemWidth + extraWidth, height: bounds.height)
        }
        /// 动画结束时 新的 frame
        let toFrame = CGRect(x: CGFloat(toIndex) * colorfulItemWidth, y: 0, width: colorfulItemWidth, height: bounds.height)
        
        /// 动画分为两部分
        /// 第一部分：遮罩先展开一部分
        /// 第二部分：位移并缩小回原来的大小
        /// 第一部分淡入，第二部分淡出
        
        UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseIn, animations: { () -> Void in
            self.colorfulMaskView.frame = scaleFrame
            }) { (finished) -> Void in
                if finished {
                    UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
                            self.colorfulMaskView.frame = toFrame
                        }, completion: nil)
                }
        }
    }
}


// MARK: - UITabBarDelegate
extension ColorFulTabBar: UITabBarDelegate {
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        let index = items!.indexOf(item)!
        fromeIndex = toIndex
        toIndex = index
        moveAnimation()
    }
}

//// 在这个方法中进行遮罩层的布局，横竖屏切换都会调用，所以可以进行横竖屏适配
