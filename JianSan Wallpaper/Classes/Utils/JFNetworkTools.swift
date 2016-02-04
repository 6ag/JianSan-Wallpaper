//
//  JFNetworkTools.swift
//  JianSan Wallpaper
//
//  Created by jianfeng on 16/2/4.
//  Copyright © 2016年 六阿哥. All rights reserved.
//

import UIKit
import Alamofire

class JFNetworkTools: NSObject {
    
    typealias NetworkFinished = (success: Bool, result: [String]?, error: NSError?) -> ()
    static let shareNetworkTools = JFNetworkTools()
}

extension JFNetworkTools {
    
    func get(URLstring: String, finished: NetworkFinished) {
        
        Alamofire.request(.GET, URLstring).responseJSON { response in
            if let JSON = response.result.value {
                finished(success: true, result: JSON as? [String], error: nil)
            } else {
                finished(success: false, result: nil, error: response.result.error)
            }
        }
    }
}