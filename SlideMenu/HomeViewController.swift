//
//  HomeViewController.swift
//  SlideMenu
//
//  Created by ccwonline on 16/7/8.
//  Copyright © 2016年 tmachc. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var navBar: UINavigationBar!
    var navItem: UINavigationItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBar = UINavigationBar.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 64))
        self.view.addSubview(navBar)
        self.navItem = UINavigationItem.init()
        navBar.pushNavigationItem(self.navItem, animated: false)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
