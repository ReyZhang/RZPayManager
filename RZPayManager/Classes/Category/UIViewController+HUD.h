//
//  UIViewController+HUD.h
//  Water
//
//  Created by reyzhang on 2021/2/3.
//  Copyright © 2021 myjs. All rights reserved.
//  MBProgressHUD 在vc下的使用

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (HUD)
@property (nonatomic,strong,nullable) MBProgressHUD * HUD;


/**
 显示菊花及提示信息
 */
- (void)showLoadingInView:(UIView *)view
                     hint:(NSString *)hint;
- (void)showLoadingWithHint:(NSString *)hint;
- (void)showLoading;


/**
 只显示文本
 */
- (void)showHint:(NSString *)hint yOffset:(float)yOffset;
- (void)showHint:(NSString *)hint;

/**
 显示自定义图片
 */
-(void)showImage:(UIImage *)image WithMessage:(NSString *)message;
-(void)showImageInWindow:(UIImage *)image WithMessage:(NSString *)message;
/**
 在window上加载显示
 */
- (void)showLoadingWindow;
- (void)hideWindow;

/**
 隐藏hud
 */
- (void)hideHud;
@end

NS_ASSUME_NONNULL_END
