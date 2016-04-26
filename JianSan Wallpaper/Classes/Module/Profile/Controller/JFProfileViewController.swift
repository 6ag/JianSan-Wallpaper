//
//  JFProfileViewController.swift
//  JianSan Wallpaper
//
//  Created by zhoujianfeng on 16/4/27.
//  Copyright © 2016年 六阿哥. All rights reserved.
//

import UIKit

class JFProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "设置"
        view.backgroundColor = UIColor.whiteColor()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "navigation_back")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(back))
        
    }
    
    /**
     返回
     */
    @objc private func back() {
        navigationController?.popViewControllerAnimated(true)
    }
}
