//
//  JFProfileStarViewController.swift
//  JianSan Wallpaper
//
//  Created by zhoujianfeng on 16/4/27.
//  Copyright © 2016年 六阿哥. All rights reserved.
//

import UIKit

class JFProfileStarViewController: JFBaseTableViewController {

    /// 页码默认为1
    var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateData(currentPage)
        
    }
    
    /**
     加载数据
     */
    private func updateData(currentPage: Int, onePageCount: Int = 10) {
        
        JFFMDBManager.sharedManager.getStarWallpaper(currentPage, onePageCount: onePageCount) { (result) in
            
            print(result)
            
        }
    }

}
