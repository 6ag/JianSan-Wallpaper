//
//  UIImage+ZJWallPaper.h
//  ZJWallPaperDemo
//
//  Created by onebyte on 15/7/17.
//  Copyright (c) 2015年 onebyte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WallPaper)

/*!
 *  保存为桌面壁纸和锁屏壁纸
 */
- (BOOL)saveAsHomeScreenAndLockScreen;

/*!
 *  保存为桌面壁纸
 */
- (BOOL)saveAsHomeScreen;

/*!
 *  保存为锁屏壁纸
 */
- (BOOL)saveAsLockScreen;

/*!
 *  保存到照片库
 */
- (void)saveToPhotos;

@end
