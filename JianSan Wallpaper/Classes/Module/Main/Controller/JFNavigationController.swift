//
//  JFNavigationController.swift
//  JianSan Wallpaper
//
//  Created by jianfeng on 16/2/4.
//  Copyright © 2016年 六阿哥. All rights reserved.
//

import UIKit

class JFNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置全局导航栏
        let navBar = UINavigationBar.appearance()
        navBar.barTintColor = UIColor(red:0.102,  green:0.102,  blue:0.102, alpha:1)
        navBar.translucent = false
        navBar.barStyle = UIBarStyle.Black
        navBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navBar.shadowImage = UIImage()
        navBar.titleTextAttributes = [
            NSForegroundColorAttributeName : TITLE_COLOR,
            NSFontAttributeName : TITLE_FONT
        ]
        
    }

}
