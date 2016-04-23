//
//  JFCategoriesMenuView.swift
//  JianSan Wallpaper
//
//  Created by zhoujianfeng on 16/4/23.
//  Copyright © 2016年 六阿哥. All rights reserved.
//

import UIKit

protocol JFCategoriesMenuViewDelegate {
    func didTappedItem(item: JFCategoryModel)
}

class JFCategoriesMenuView: UIView {
    
    var delegate: JFCategoriesMenuViewDelegate?
    
    /// 分类模型
    var items: Array<JFCategoryModel>!
    
    // MARK: - 初始化
    init(items: Array<JFCategoryModel>) {
        super.init(frame: SCREEN_BOUNDS)
        self.items = items
        self.alpha = 0.02
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedShadowView(_:))))
        UIApplication.sharedApplication().keyWindow?.addSubview(self)
        
        let width: CGFloat = 50
        let height: CGFloat = 50
        let margin: CGFloat = 20
        
        menuScrollView.contentSize = CGSize(width: 0, height: CGFloat(items.count) * (height + margin) + margin)
        
        let blur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let effectView = UIVisualEffectView(effect: blur)
        effectView.frame = CGRect(x: 0, y: -500, width: 95, height: menuScrollView.contentSize.height + 1000)
        menuScrollView.addSubview(effectView)
        
        for (index, item) in items.enumerate() {
            let itemButton = JFCategoryButton(type: UIButtonType.Custom)
            itemButton.setImage(UIImage(named: item.iconName!), forState: UIControlState.Normal)
            itemButton.title = item.title
            itemButton.url = item.url
            itemButton.tag = index + 10
            itemButton.alpha = 0.0
            itemButton.layer.cornerRadius = 25
            itemButton.layer.masksToBounds = true
            itemButton.addTarget(self, action: #selector(didTappedItemButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            itemButton.backgroundColor = UIColor(white: 0.4, alpha: 0.95)
            itemButton.frame = CGRect(x: 22.5, y: CGFloat(index) * (height + margin) + margin, width: width, height: height)
            menuScrollView.addSubview(itemButton)
        }
        
        UIApplication.sharedApplication().keyWindow?.addSubview(menuScrollView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     分类按钮点击事件、回调被点击的分类模型
     */
    func didTappedItemButton(button: JFCategoryButton) -> Void {
        delegate?.didTappedItem(items[button.tag - 10])
        dismiss()
    }
    
    /**
     显示
     */
    func show() -> Void {
        UIView.animateWithDuration(0.25, animations: {
            self.menuScrollView.transform = CGAffineTransformTranslate(self.menuScrollView.transform, self.menuScrollView.frame.width, 0)
        }) { (_) in
            for index in 0..<self.items.count {
                UIView.animateWithDuration(0.25, animations: {
                    let button = self.menuScrollView.viewWithTag(index + 10) as? JFCategoryButton
                    button?.alpha = 1.0
                })
            }
            
        }
    }
    
    /**
     隐藏
     */
    func dismiss() -> Void {
        UIView.animateWithDuration(0.25, animations: {
            self.menuScrollView.transform = CGAffineTransformTranslate(self.menuScrollView.transform, -self.menuScrollView.frame.width, 0)
        }) { (_) in
            self.removeFromSuperview()
            self.menuScrollView.removeFromSuperview()
        }
    }
    
    /**
     点击了透明背景
     */
    func didTappedShadowView(tap: UITapGestureRecognizer) -> Void {
        dismiss()
    }
    
    // MARK: - 懒加载
    /// 菜单滚动条
    lazy var menuScrollView: UIScrollView = {
        let menuScrollView = UIScrollView(frame: CGRect(x: -95, y: 0, width: 95, height: SCREEN_HEIGHT))
        menuScrollView.showsVerticalScrollIndicator = false
        return menuScrollView
    }()
    
}
