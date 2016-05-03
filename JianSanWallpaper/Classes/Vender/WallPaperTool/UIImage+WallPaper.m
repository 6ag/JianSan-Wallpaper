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
#import <AssetsLibrary/AssetsLibrary.h>

#import <Photos/Photos.h>

@interface UIImage ()

@end

@implementation UIImage (WallPaper)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

- (void)saveAndAsScreenPhotoWith:(UIImageScreen)imageScreen finished:(void (^)(BOOL success))finished
{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (PHAuthorizationStatusAuthorized == status) {
            
            // 保存需要设置为壁纸的图片到相册
            UIImageWriteToSavedPhotosAlbum(self, nil,nil, NULL);
            
            // 获取壁纸控制器
            id wallPaperVc = self.wallPaperVC;
            if (wallPaperVc) {
                switch (imageScreen) {
                    case UIImageScreenHome:
                        [wallPaperVc performSelector:@selector(setImageAsHomeScreenClicked:) withObject:nil];
                        break;
                    case UIImageScreenLock:
                        [wallPaperVc performSelector:@selector(setImageAsLockScreenClicked:) withObject:nil];
                        break;
                    case UIImageScreenBoth:
                        [wallPaperVc performSelector:@selector(setImageAsHomeScreenAndLockScreenClicked:) withObject:nil];
                        break;
                    default:
                        break;
                }
                finished(YES);
            } else {
                finished(NO);
            }
        } else {
            // 无权限
            finished(NO);
        }
    }];
}

#pragma clang diagnostic pop
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
/**
 *  获取系统壁纸控制器
 */
- (id)wallPaperVC
{
    Class wallPaperClass = NSClassFromString(@"PLStaticWallpaperImageViewController");
    id wallPaperInstance = [[wallPaperClass alloc] performSelector:NSSelectorFromString(@"initWithUIImage:") withObject:self];
    [wallPaperInstance setValue:@(YES) forKeyPath:@"allowsEditing"];
    [wallPaperInstance  setValue:@(YES) forKeyPath:@"saveWallpaperData"];
    return wallPaperInstance;
}
#pragma clang diagnostic pop

@end
