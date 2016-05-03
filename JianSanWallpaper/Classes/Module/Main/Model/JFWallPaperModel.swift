//
//  JFWallPaperModel.swift
//  JianSan Wallpaper
//
//  Created by zhoujianfeng on 16/4/26.
//  Copyright © 2016年 六阿哥. All rights reserved.
//

import UIKit

class JFWallPaperModel: NSObject {
    
    /// 壁纸id
    var id: Int = 0
    
    /// 壁纸分类
    var category: String?
    
    /// 壁纸路径 baseURL/path 获取壁纸url
    var path: String?
    
    /// 存储形变改变的偏移量
    var offsetY: CGFloat = 0
    
    // 快速构造模型
    init(dict: [String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
}
