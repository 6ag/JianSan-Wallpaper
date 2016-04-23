//
//  JFCategoriesMenuView.swift
//  JianSan Wallpaper
//
//  Created by zhoujianfeng on 16/4/23.
//  Copyright © 2016年 六阿哥. All rights reserved.
//

import UIKit

class JFCategoriesMenuView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     布局视图
     */
    func prepareUI() -> Void {
        self.alpha = 0.02
        UIApplication.sharedApplication().keyWindow?.addSubview(shadowView)
        UIApplication.sharedApplication().keyWindow?.addSubview(menuScrollView)
        UIApplication.sharedApplication().keyWindow?.addSubview(self)
    }
    
    /**
     显示
     */
    func show() -> Void {
        UIView.animateWithDuration(0.25, animations: { 
            self.menuScrollView.transform = CGAffineTransformTranslate(self.menuScrollView.transform, self.menuScrollView.frame.width, 0)
            }) { (_) in
                // 动画弹出分类按钮
                
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
                self.shadowView.removeFromSuperview()
        }
    }
    
    /**
     点击了透明背景
     */
    func didTappedShadowView(tap: UITapGestureRecognizer) -> Void {
        dismiss()
    }
    
    // MARK: - 懒加载
    /// 透明背景遮罩
    lazy var shadowView: UIView = {
        let shadowView = UIView(frame: SCREEN_BOUNDS)
        shadowView.backgroundColor = UIColor(white: 0.0, alpha: 0.02)
        shadowView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedShadowView(_:))))
        return shadowView
    }()
    
    /// 菜单滚动条
    lazy var menuScrollView: UIView = {
        let menuScrollView = UIScrollView(frame: CGRect(x: -95, y: 0, width: 95, height: SCREEN_HEIGHT))
        
        // 添加毛玻璃效果
        let blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let effectView = UIVisualEffectView(effect: blur)
        effectView.frame = CGRect(x: 0, y: 0, width: 95, height: SCREEN_HEIGHT)
        menuScrollView.addSubview(effectView)
        
        menuScrollView.showsVerticalScrollIndicator = false
        return menuScrollView
    }()
    
}
