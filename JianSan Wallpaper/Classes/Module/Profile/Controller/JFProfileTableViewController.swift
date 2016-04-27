//
//  JFProfileTableViewController.swift
//  JianSan Wallpaper
//
//  Created by zhoujianfeng on 16/4/27.
//  Copyright © 2016年 六阿哥. All rights reserved.
//

import UIKit
import YYWebImage
import SVProgressHUD

class JFProfileTableViewController: JFBaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "设置"
        
        let group1CellModel1 = JFSettingCellArrow(title: "我的收藏", icon: "setting_star_icon", destinationVc: JFProfileStarViewController.self)
        let group1CellModel2 = JFSettingCellArrow(title: "上传壁纸", icon: "setting_upload_icon", destinationVc: JFProfileUploadViewController.self)
        let group1 = JFSettingGroup(cells: [group1CellModel1, group1CellModel2])
        
        let group2CellModel1 = JFSettingCellLabel(title: "清除缓存", icon: "setting_clear_icon", text: "\(String(format: "%.2f", CGFloat(YYImageCache.sharedCache().diskCache.totalCost()) / 1024 / 1024))M")
        group2CellModel1.operation = { () -> Void in
            SVProgressHUD.showWithStatus("正在清理")
            YYImageCache.sharedCache().diskCache.removeAllObjectsWithBlock({ 
                SVProgressHUD.showSuccessWithStatus("清理成功")
                group2CellModel1.text = "0.00M"
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
            })
        }
        let group2CellModel2 = JFSettingCellArrow(title: "设置帮助", icon: "setting_help_icon", destinationVc: JFProfileHelpViewController.self)
        let group2CellModel3 = JFSettingCellArrow(title: "意见反馈", icon: "setting_feedback_icon", destinationVc: JFProfileFeedbackViewController.self)
        let group2 = JFSettingGroup(cells: [group2CellModel1, group2CellModel2, group2CellModel3])
        
        let group3CellModel1 = JFSettingCellArrow(title: "推荐给好友", icon: "setting_share_icon")
        group3CellModel1.operation = { () -> Void in
            print("推荐给好友")
        }
        let group3CellModel2 = JFSettingCellArrow(title: "关于我们", icon: "setting_about_icon", destinationVc: JFProfileAboutViewController.self)
        let group3 = JFSettingGroup(cells: [group3CellModel1, group3CellModel2])
        
        groupModels = [group1, group2, group3]
    }
    
}
