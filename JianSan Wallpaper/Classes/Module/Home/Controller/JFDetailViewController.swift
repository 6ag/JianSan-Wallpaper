//
//  JFDetailViewController.swift
//  JianSan Wallpaper
//
//  Created by jianfeng on 16/2/4.
//  Copyright © 2016年 六阿哥. All rights reserved.
//

import UIKit
import SVProgressHUD

class JFDetailViewController: UIViewController, JFContextSheetDelegate {
    
    var image: UIImage? {
        didSet {
            imageView.image = image!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTappedView(_:)))
        view.addGestureRecognizer(tapGesture)
        
        // 别日狗
        performSelectorOnMainThread(#selector(dontSleep), withObject: nil, waitUntilDone: false)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Fade)
    }
    
    /**
     唤醒线程
     */
    func dontSleep() -> Void {
        print("起来吧，别日狗了")
    }
    
    /**
     view触摸事件
     */
    @objc private func didTappedView(gestureRecognizer: UITapGestureRecognizer) {
        contextSheet.startWithGestureRecognizer(gestureRecognizer, inView: view)
    }
    
    // MARK: - JFContextSheetDelegate
    func contextSheet(contextSheet: JFContextSheet, didSelectItemWithItemName itemName: String) {
        switch (itemName) {
        case "返回":
            dismissViewControllerAnimated(true, completion: nil)
            break
        case "预览":
            if (scrollView.superview == nil) {
                view.addSubview(scrollView)
            }
            break
        case "下载":
            UIImageWriteToSavedPhotosAlbum(image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            break
        default:
            break
        }
    }
    
    /**
     保存图片到相册回调
     */
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        if error != nil {
            SVProgressHUD.showErrorWithStatus("保存失败")
        } else {
            SVProgressHUD.showSuccessWithStatus("保存成功")
        }
    }
    
    // MARK: - 懒加载
    /// 展示的壁纸图片
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = SCREEN_BOUNDS
        self.view.addSubview(imageView)
        return imageView
    }()
    
    /// 触摸屏幕后弹出视图
    private lazy var contextSheet: JFContextSheet = {
        let contextItem1 = JFContextItem(itemName: "返回", itemIcon: "content_icon_back")
        let contextItem2 = JFContextItem(itemName: "预览", itemIcon: "content_icon_preview")
        let contextItem3 = JFContextItem(itemName: "下载", itemIcon: "content_icon_download")
        
        let contextSheet = JFContextSheet(items: [contextItem1, contextItem2, contextItem3])
        contextSheet.delegate = self
        return contextSheet
    }()
    
    /// 预览滚动视图
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: SCREEN_BOUNDS)
        scrollView.backgroundColor = UIColor.clearColor()
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize(width: SCREEN_WIDTH * 2, height: SCREEN_HEIGHT)
        
        // 第一张背景
        let previewImage1 = UIImageView(image: UIImage(named: "preview_cover00_640x1136"))
        previewImage1.frame = SCREEN_BOUNDS
        
        // 第二张背景
        let previewImage2 = UIImageView(image: UIImage(named: "preview_cover01_640x1136"))
        previewImage2.frame = CGRect(x: SCREEN_WIDTH, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        
        scrollView.addSubview(previewImage1)
        scrollView.addSubview(previewImage2)
        return scrollView
    }()
    
}
