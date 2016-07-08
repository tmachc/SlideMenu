//
//  ViewController.swift
//  SlideMenu
//
//  Created by ccwonline on 16/7/8.
//  Copyright © 2016年 tmachc. All rights reserved.
//

import UIKit

let WINDOW_WIDTH = UIScreen.mainScreen().bounds.size.width
let WINDOW_HEIGHT = UIScreen.mainScreen().bounds.size.height

class ViewController: UIViewController {
    
    /** 主视图tabbarViewController */
    var homeControl: HomeViewController!
    /** 侧滑菜单视图的来源 */
    var leftViewController: LeftViewController!
    /** 首页上面的遮罩 */
    var viewShade: UIView!
    /** 滑动后的比例 */
    let Proportion: CGFloat = 0.825
    let TargetCenterX: CGFloat = WINDOW_WIDTH * 3/2  * 0.825
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        
        // menu页
        leftViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LeftViewController") as! LeftViewController
        leftViewController.view.frame.size = CGSizeMake(WINDOW_WIDTH * Proportion, WINDOW_HEIGHT)
        self.view.addSubview(leftViewController.view)
        
        // 首页控制器
        homeControl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
        self.view.addSubview(homeControl.view)
        
        let menu = UIBarButtonItem.init(title: "菜单", style: .Done, target: self, action: #selector(showLeft))
        homeControl.navItem.leftBarButtonItem = menu
        
        // menu页出现后 在首页上面的遮罩
        viewShade = UIView.init()
        viewShade.hidden = true
        viewShade.userInteractionEnabled = true
        viewShade.backgroundColor = UIColor.clearColor()
        homeControl.view.addSubview(viewShade)
        viewShade.translatesAutoresizingMaskIntoConstraints = false
//        viewShade.addConstraint(NSLayoutConstraint.init(item: viewShade, attribute: .Left, relatedBy: .Equal, toItem: homeControl.view, attribute: .Left, multiplier: 1, constant: 0))
//        viewShade.addConstraint(NSLayoutConstraint.init(item: viewShade, attribute: .Top, relatedBy: .Equal, toItem: homeControl.view, attribute: .Top, multiplier: 1, constant: 0))
//        viewShade.addConstraint(NSLayoutConstraint.init(item: viewShade, attribute: .Right, relatedBy: .Equal, toItem: homeControl.view, attribute: .Right, multiplier: 1, constant: 0))
//        viewShade.addConstraint(NSLayoutConstraint.init(item: viewShade, attribute: .Bottom, relatedBy: .Equal, toItem: homeControl.view, attribute: .Bottom, multiplier: 1, constant: 0))
        
        // 生成单击收起菜单手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showHome))
        // 给首页 加入 点击自动关闭侧滑菜单功能
        self.viewShade.addGestureRecognizer(tapGesture)
        
        let panGesture = UIPanGestureRecognizer()
        panGesture.addTarget(self, action: #selector(pan(_:)))
        self.viewShade.addGestureRecognizer(panGesture)
        
        // 设置初始状态
        self.setInitialState()
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    // MARK: - function
    
    // 响应 UIPanGestureRecognizer 事件
    func pan(recongnizer: UIPanGestureRecognizer) {
        let x = recongnizer.translationInView(self.view).x
        let trueDistance = -x / Proportion // 实时距离
        
        // 如果 UIPanGestureRecognizer 结束，则激活自动停靠
        if recongnizer.state == UIGestureRecognizerState.Ended {
            if trueDistance < WINDOW_WIDTH / 2 {
                showLeft()
            }
            else {
                showHome()
            }
            return
        }
        
        // 计算缩放比例
        let proportion: CGFloat = Proportion + trueDistance/WINDOW_WIDTH * (1 - Proportion)
        
        // 左右 到头了 就不动了
        if x >= 0 || proportion > 1 {
            print("nonono")
            return
        }
        // 执行平移和缩放动画
        homeControl.view!.center = CGPointMake(TargetCenterX + x + trueDistance * 0.5 * (1 - Proportion), self.view.center.y)
        homeControl.view!.transform = CGAffineTransformScale(CGAffineTransformIdentity, proportion, proportion)
        
        // 执行左视图动画
        let pro = 1 - (proportion - Proportion)
        leftViewController.view.center = CGPointMake((self.view.center.x + x) * self.Proportion, self.view.center.y)
        leftViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, pro, pro)
    }
    
    func setInitialState() {
        leftViewController.view.center = CGPointMake(WINDOW_WIDTH - self.TargetCenterX, self.view.center.y)
        leftViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, self.Proportion, self.Proportion)
        homeControl.view.center = CGPointMake(self.view.center.x, self.view.center.y)
        homeControl.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1)
    }
    
    // 展示左视图
    func showLeft() {
        self.viewShade.hidden = false
        UIView.animateWithDuration(0.3, animations: {
            self.homeControl.view.center = CGPointMake(self.TargetCenterX, self.view.center.y)
            self.homeControl.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, self.Proportion, self.Proportion)
            self.leftViewController.view.center = CGPointMake(self.view.center.x * self.Proportion, self.view.center.y)
            self.leftViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1)
        })
    }
    // 展示主视图
    func showHome() {
        UIView.animateWithDuration(0.3, animations: {
            self.setInitialState()
        }) { (a) in
            self.viewShade.hidden = true
        }
    }
}

