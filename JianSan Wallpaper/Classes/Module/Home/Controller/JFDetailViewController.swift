//
//  JFDetailViewController.swift
//  JianSan Wallpaper
//
//  Created by jianfeng on 16/2/4.
//  Copyright © 2016年 六阿哥. All rights reserved.
//

import UIKit

class JFDetailViewController: UIViewController,VLDContextSheetDelegate {
    
    var image: UIImage? {
        didSet {
            imageView.image = image!
            print(image)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressed:")
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc private func longPressed(gestureRecognizer: UILongPressGestureRecognizer) {
        
        if gestureRecognizer.state == .Began {
            contextSheet.startWithGestureRecognizer(gestureRecognizer, inView: view)
        }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        contextSheet.end()
    }
    
    // MARK: - VLDContextSheetDelegate
    func contextSheet(contextSheet: VLDContextSheet!, didSelectItem item: VLDContextSheetItem!) {
        
        switch (item.title) {
        case "返回":
            dismissViewControllerAnimated(true, completion: nil)
            break
        case "预览":
            if (scrollView.superview == nil) {
                self.view.addSubview(scrollView)
            }
            break
        case "下载":
            
            break
        default:
            break
        }
    }
    
    // MARK: - Navigation
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = SCREEN_BOUNDS
        self.view.addSubview(imageView)
        return imageView
    }()
    
    private lazy var contextSheet: VLDContextSheet = {
        
        let back = VLDContextSheetItem(title: "返回", image: UIImage(named: "content_icon_back"), highlightedImage: UIImage(named: "content_icon_back"))
        let preview = VLDContextSheetItem(title: "预览", image: UIImage(named: "content_icon_preview"), highlightedImage: UIImage(named: "content_icon_preview"))
        let download = VLDContextSheetItem(title: "下载", image: UIImage(named: "content_icon_download"), highlightedImage: UIImage(named: "content_icon_download"))
        
        let contextSheet = VLDContextSheet(items: [download, preview, back])
        contextSheet.delegate = self
        
        return contextSheet
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: SCREEN_BOUNDS)
        scrollView.backgroundColor = UIColor.clearColor()
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize(width: SCREEN_WIDTH * 2, height: SCREEN_HEIGHT)
        let previewImage1 = UIImageView(image: UIImage(named: "preview_cover00_640x1136"))
        previewImage1.frame = SCREEN_BOUNDS
        let previewImage2 = UIImageView(image: UIImage(named: "preview_cover01_640x1136"))
        previewImage2.frame = CGRect(x: SCREEN_WIDTH, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        
        scrollView.addSubview(previewImage1)
        scrollView.addSubview(previewImage2)
        return scrollView
    }()
    
}
