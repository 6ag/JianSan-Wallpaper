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
    
    typealias NetworkFinished = (success: Bool, result: [[String : AnyObject]]?, error: NSError?) -> ()
    static let shareNetworkTools = JFNetworkTools()
}

extension JFNetworkTools {
    
    /**
     检测壁纸保存状态
     */
    func checkSaveState(finished: (on: Bool)->()) -> Void {
        Alamofire.request(.GET, "\(baseURL)fuck.php").responseJSON { response in
            if let JSON = response.result.value {
                finished(on: JSON.integerValue == 1 ? true : false)
            }
        }
    }
    
    /**
     get请求
     
     - parameter URLString:  接口url
     - parameter parameters: 参数
     - parameter finished:   回调
     */
    func get(URLString: String, parameters: [String : AnyObject], finished: NetworkFinished) {
        
        Alamofire.request(.GET, URLString, parameters: parameters, encoding: ParameterEncoding.URL, headers: nil).responseJSON { (response) in
            
            if let JSON = response.result.value {
                let dict = JSON as! [String : AnyObject]
                
                if dict["code"]?.integerValue == 1 {
                    finished(success: true, result: dict["data"] as? [[String : AnyObject]], error: nil)
                } else {
                    finished(success: false, result: nil, error: nil)
                }
                
            } else {
                finished(success: false, result: nil, error: response.result.error)
            }
        }
    }
    
    /**
     post请求
     
     - parameter URLString:  接口url
     - parameter parameters: 参数
     - parameter finished:   回调
     */
    func post(URLString: String, parameters: [String : AnyObject], finished: NetworkFinished) {
        
        Alamofire.request(.POST, URLString, parameters: parameters, encoding: ParameterEncoding.URL, headers: nil).responseJSON { (response) in
            
            if let JSON = response.result.value {
                let dict = JSON as! [String : AnyObject]
                
                if dict["code"]?.integerValue == 1 {
                    finished(success: true, result: dict["data"] as? [[String : AnyObject]], error: nil)
                } else {
                    finished(success: false, result: nil, error: nil)
                }
                
            } else {
                finished(success: false, result: nil, error: response.result.error)
            }
        }
    }
    
}