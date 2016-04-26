//
//  UIImage+WallPaper.m
//  JianSan Wallpaper
//
//  Created by zhoujianfeng on 16/4/26.
//  Copyright © 2016年 六阿哥. All rights reserved.
//

#import "UIImage+WallPaper.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface UIImage ()

@end

@implementation UIImage (WallPaper)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

/*
 *  保存为桌面壁纸和锁屏壁纸
 */
- (BOOL)saveAsHomeScreenAndLockScreen
{
    [self saveToPhotos];
    
    id wallPaperVc = self.wallPaperVC;
    if (wallPaperVc) {
        [wallPaperVc performSelector:@selector(setImageAsHomeScreenAndLockScreenClicked:) withObject:nil];
        return YES;
    } else {
        return NO;
    }
    
}

/*
 *  保存为桌面壁纸
 */
- (BOOL)saveAsHomeScreen
{
    [self saveToPhotos];
    
    id wallPaperVc = self.wallPaperVC;
    if (wallPaperVc) {
        [wallPaperVc performSelector:@selector(setImageAsHomeScreenClicked:) withObject:nil];
        return YES;
    } else {
        return NO;
    }
    
}

/*
 *  保存为锁屏壁纸
 */
- (BOOL)saveAsLockScreen
{
    [self saveToPhotos];
    
    id wallPaperVc = self.wallPaperVC;
    if (wallPaperVc) {
        [wallPaperVc performSelector:@selector(setImageAsLockScreenClicked:) withObject:nil];
        return YES;
    } else {
        return NO;
    }
}

/*
 *  保存到照片库
 */
- (void)saveToPhotos
{
    UIImageWriteToSavedPhotosAlbum(self, nil,nil, NULL);
}

#pragma clang diagnostic pop
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
- (id)wallPaperVC {
    Class wallPaperClass = NSClassFromString(@"PLStaticWallpaperImageViewController");
    id wallPaperInstance = [[wallPaperClass alloc] performSelector:NSSelectorFromString(@"initWithUIImage:") withObject:self];
    [wallPaperInstance setValue:@(YES) forKeyPath:@"allowsEditing"];
    [wallPaperInstance  setValue:@(YES) forKeyPath:@"saveWallpaperData"];
    NSLog(@"wallPaperInstance = %@", wallPaperInstance);
    return wallPaperInstance;
}
#pragma clang diagnostic pop

@end
