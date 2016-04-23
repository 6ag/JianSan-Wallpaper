//
//  JFContextSheet.swift
//  JianSan Wallpaper
//
//  Created by zhoujianfeng on 16/4/22.
//  Copyright © 2016年 六阿哥. All rights reserved.
//

import UIKit

protocol JFContextSheetDelegate {
    func contextSheet(contextSheet: JFContextSheet, didSelectItemWithItemName itemName: String)
}

class JFContextSheet: UIView {
    
    var delegate: JFContextSheetDelegate?
    
    // MARK: - 初始化
    init(items: Array<JFContextItem>) {
        super.init(frame: SCREEN_BOUNDS)
        
        for itemView in items {
            itemView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedItemWithItemName(_:))))
            addSubview(itemView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     item触摸手势
     */
    func didTappedItemWithItemName(tap: UITapGestureRecognizer) -> Void {
        let itemView = tap.view as! JFContextItem
        
        // 回调触摸itemName
        delegate?.contextSheet(self, didSelectItemWithItemName: itemView.itemLabel.text!)
        
        self.removeFromSuperview()
        centerView.removeFromSuperview()
    }
    
    /**
     根据手势弹出sheet
     
     - parameter gestureRecognizer: 手势
     - parameter inView:            手势所在视图
     */
    func startWithGestureRecognizer(gestureRecognizer: UIGestureRecognizer, inView: UIView) -> Void {
        
        // 添加弹出视图
        inView.addSubview(self)
        
        // 遮罩用当前view
        backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        
        // 触摸圆点
        let center = gestureRecognizer.locationInView(inView)
        
        // 圆点视图
        centerView.frame = CGRect(x: center.x - 20, y: center.y - 20, width: 40, height: 40)
        inView.addSubview(centerView)
        
        // item布局
        let itemWidth: CGFloat = 40
        let itemHeight: CGFloat = 50
        
        // 把所有item都以触摸点为原点
        for (index, item) in subviews.enumerate() {
            let itemView = item as! JFContextItem
            itemView.frame = CGRect(x: center.x - itemWidth * 0.5, y: center.y - itemHeight * 0.5, width: itemWidth, height: itemHeight)
            
            // 左上
            if center.x <= 70 && center.y <= 150 {
                UIView.animateWithDuration(0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                    switch index {
                    case 0:
                        itemView.transform = CGAffineTransformTranslate(itemView.transform, 80, 0)
                        break
                    case 1:
                        itemView.transform = CGAffineTransformTranslate(itemView.transform, 60, 60)
                        break
                    case 2:
                        itemView.transform = CGAffineTransformTranslate(itemView.transform, 0, 80)
                        break
                    default:
                        break
                    }
                    }, completion: { (_) in
                        
                })
            }
            
            // 上
            if center.x > 70 && center.x <= SCREEN_WIDTH - 70 && center.y <= 150 {
                UIView.animateWithDuration(0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                    switch index {
                    case 0:
                        itemView.transform = CGAffineTransformTranslate(itemView.transform, 50, 80)
                        break
                    case 1:
                        itemView.transform = CGAffineTransformTranslate(itemView.transform, 0, 100)
                        break
                    case 2:
                        itemView.transform = CGAffineTransformTranslate(itemView.transform, -50, 80)
                        break
                    default:
                        break
                    }
                    }, completion: { (_) in
                        
                })
            }
            
            // 右上角
            if center.x > SCREEN_WIDTH - 70 && center.y <= 150 {
                UIView.animateWithDuration(0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                    switch index {
                    case 0:
                        itemView.transform = CGAffineTransformTranslate(itemView.transform, -10, 80)
                        break
                    case 1:
                        itemView.transform = CGAffineTransformTranslate(itemView.transform, -60, 60)
                        break
                    case 2:
                        itemView.transform = CGAffineTransformTranslate(itemView.transform, -80, 0)
                        break
                    default:
                        break
                    }
                    }, completion: { (_) in
                        
                })
            }
            
            // 左/左下
            if center.x <= 70 && center.y > 150{
                UIView.animateWithDuration(0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                    switch index {
                    case 0:
                        itemView.transform = CGAffineTransformTranslate(itemView.transform, 0, -80)
                        break
                    case 1:
                        itemView.transform = CGAffineTransformTranslate(itemView.transform, 60, -60)
                        break
                    case 2:
                        itemView.transform = CGAffineTransformTranslate(itemView.transform, 80, 0)
                        break
                    default:
                        break
                    }
                    }, completion: { (_) in
                        
                })
            }
            
            // 中间区域/下
            if center.x > 70 && center.x < SCREEN_WIDTH - 70 && center.y > 150 {
                UIView.animateWithDuration(0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                    switch index {
                    case 0:
                        itemView.transform = CGAffineTransformTranslate(itemView.transform, -50, -80)
                        break
                    case 1:
                        itemView.transform = CGAffineTransformTranslate(itemView.transform, 0, -100)
                        break
                    case 2:
                        itemView.transform = CGAffineTransformTranslate(itemView.transform, 50, -80)
                        break
                    default:
                        break
                    }
                    }, completion: { (_) in
                        
                })
            }
            
            // 右/右下
            if center.x > SCREEN_WIDTH - 70 && center.y > 150 {
                UIView.animateWithDuration(0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                    switch index {
                    case 0:
                        itemView.transform = CGAffineTransformTranslate(itemView.transform, -80, 0)
                        break
                    case 1:
                        itemView.transform = CGAffineTransformTranslate(itemView.transform, -60, -60)
                        break
                    case 2:
                        itemView.transform = CGAffineTransformTranslate(itemView.transform, 0, -80)
                        break
                    default:
                        break
                    }
                    }, completion: { (_) in
                        
                })
            }
            
        }
        
    }
    
    // MARK: - 懒加载
    lazy var centerView: UIView = {
        let centerView = UIView()
        centerView.backgroundColor = UIColor(white: 0, alpha: 0.1)
        centerView.layer.cornerRadius = 20
        centerView.layer.masksToBounds = true
        centerView.layer.borderColor = UIColor(red:0.502,  green:0.502,  blue:0.502, alpha:0.5).CGColor
        centerView.layer.borderWidth = 2.0
        return centerView
    }()
    
    
}
