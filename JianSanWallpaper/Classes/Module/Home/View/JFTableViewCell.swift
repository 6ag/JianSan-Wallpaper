//
//  JFHomeCell.swift
//  JianSan Wallpaper
//
//  Created by jianfeng on 16/2/4.
//  Copyright © 2016年 六阿哥. All rights reserved.
//

import UIKit
import YYWebImage

class JFTableViewCell: UITableViewCell {
    
    /// 壁纸模型
    var wallPaperModel: JFWallPaperModel? {
        didSet {
            // 进度圈半径
            let radius: CGFloat = 30.0
            let progressView = JFProgressView(frame: CGRect(x: SCREEN_WIDTH / 2 - radius, y: 250 / 2 - radius, width: radius * 2, height: radius * 2))
            progressView.radius = radius
            progressView.backgroundColor = UIColor.whiteColor()
            
            wallPaperImageView.yy_setImageWithURL(NSURL(string: "\(baseURL)\(wallPaperModel!.path!)"), placeholder: UIImage(named: "temp_image"), options: YYWebImageOptions.SetImageWithFadeAnimation, progress: { (receivedSize, expectedSize) in
                
                self.contentView.addSubview(progressView)
                progressView.progress = CGFloat(receivedSize) / CGFloat(expectedSize)
                
                }, transform: { (image, url) -> UIImage? in
                    return image
                }, completion: { (image, url, type, stage, error) in
                    progressView.removeFromSuperview()
            })
            
        }
    }
    
    /// 壁纸
    lazy var wallPaperImageView: UIImageView = {
        let wallPaperImageView = UIImageView()
        wallPaperImageView.contentMode = .ScaleAspectFill
        return wallPaperImageView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        prepareUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareUI() {
        contentView.addSubview(wallPaperImageView)
        layer.borderColor = UIColor(red:0.063,  green:0.063,  blue:0.063, alpha:1).CGColor
        layer.borderWidth = 3
        layer.masksToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let model = wallPaperModel {
            var rect = bounds
            rect.origin.y += model.offsetY
            wallPaperImageView.frame = rect
        }
        
    }
    
    func cellOffset() -> CGFloat {
        let centerToWindow = convertRect(bounds, toView: window)
        let centerY = CGRectGetMidY(centerToWindow)
        let windowCenter = window!.center
        let cellOffsetY = centerY - windowCenter.y
        let offsetDig = cellOffsetY / SCREEN_HEIGHT * 3
        wallPaperModel!.offsetY = -offsetDig * (SCREEN_HEIGHT / 1.7 - 250) / 2
        wallPaperImageView.transform = CGAffineTransformMakeTranslation(0, wallPaperModel!.offsetY)
        return wallPaperModel!.offsetY
    }

}
