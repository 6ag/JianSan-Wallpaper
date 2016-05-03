//
//  UIImage+WallPaper.h
//  JianSan Wallpaper
//
//  Created by zhoujianfeng on 16/4/26.
//  Copyright © 2016年 六阿哥. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    UIImageScreenHome,
    UIImageScreenLock,
    UIImageScreenBoth
} UIImageScreen;

@interface UIImage (WallPaper)

/**
 *  一键保存到相册并设置为壁纸
 */
- (void)saveAndAsScreenPhotoWith:(UIImageScreen)imageScreen finished:(void (^)(BOOL success))finished;

@end
