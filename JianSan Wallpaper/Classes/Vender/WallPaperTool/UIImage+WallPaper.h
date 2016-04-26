//
//  UIImage+WallPaper.h
//  JianSan Wallpaper
//
//  Created by zhoujianfeng on 16/4/26.
//  Copyright © 2016年 六阿哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WallPaper)

/*
 *  保存为桌面壁纸和锁屏壁纸
 */
- (BOOL)saveAsHomeScreenAndLockScreen;

/*
 *  保存为桌面壁纸
 */
- (BOOL)saveAsHomeScreen;

/*
 *  保存为锁屏壁纸
 */
- (BOOL)saveAsLockScreen;

@end
