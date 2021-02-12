//
//  UIViewController+HUD.m
//  Water
//
//  Created by reyzhang on 2021/2/3.
//  Copyright © 2021 myjs. All rights reserved.
//

#import "UIViewController+HUD.h"
static const void *HttpRequestHUDKey = &HttpRequestHUDKey;

@implementation UIViewController (HUD)

- (MBProgressHUD *)HUD
{
    return objc_getAssociatedObject(self, HttpRequestHUDKey);
}

- (void)setHUD:(MBProgressHUD *)HUD
{
    objc_setAssociatedObject(self, HttpRequestHUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark ==========public======================

/**
 显示菊花及提示信息
 */
- (void)showLoadingInView:(UIView *)view
                     hint:(NSString *)hint {
    UIView *superV = view == nil ? [self getView] : view;
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:superV];
    HUD.tag   = 4008;
    HUD.contentColor=[UIColor whiteColor];
    HUD.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    HUD.label.text = hint;
    HUD.removeFromSuperViewOnHide=YES;
    [view addSubview:HUD];
    [HUD showAnimated:YES];
    self.HUD = HUD; //让vc持有
}



- (void)showLoadingWithHint:(NSString *)hint {
    [self showLoadingInView:[self getView] hint:hint];
}

- (void)showLoading {
    [self showLoadingInView:[self getView] hint:@"正在加载"];
}


/**
 只显示文本
 */
- (void)showHint:(NSString *)hint yOffset:(float)yOffset {
    UIView *superV = [self getView];
    MBProgressHUD *HUD=[[MBProgressHUD alloc] initWithView:superV];
    HUD.contentColor=[UIColor whiteColor];
    HUD.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    HUD.mode=MBProgressHUDModeText;
    HUD.label.text=hint;
    HUD.margin      = 10.f;
    HUD.offset = CGPointMake(0, HUD.offset.y+yOffset);
    HUD.removeFromSuperViewOnHide=YES;
    [superV addSubview:HUD];
    [HUD showAnimated:YES];
    [HUD hideAnimated:YES afterDelay:1];///1秒后消失
}

- (void)showHint:(NSString *)hint {
    [self showHint:hint yOffset:0];
}


-(void)showImage:(UIImage *)image WithMessage:(NSString *)message {
    UIView *superV = [self getView];
    MBProgressHUD *HUD=[[MBProgressHUD alloc]initWithView:superV];
    HUD.mode = MBProgressHUDModeCustomView;
    UIImageView *imagV = [[UIImageView alloc]initWithImage:image];
    HUD.customView = imagV;
    HUD.label.text = message;
    HUD.contentColor=[UIColor whiteColor];
    HUD.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    HUD.removeFromSuperViewOnHide=YES;
    [superV addSubview:HUD];
    [HUD showAnimated:YES];
    [HUD hideAnimated:YES afterDelay:1];///1秒后消失
}

-(void)showImageInWindow:(UIImage *)image WithMessage:(NSString *)message {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *HUD=[[MBProgressHUD alloc]initWithView:keyWindow];
    HUD.mode = MBProgressHUDModeCustomView;
    UIImageView *imagV = [[UIImageView alloc]initWithImage:image];
    HUD.customView = imagV;
    HUD.label.text = message;
    HUD.contentColor=[UIColor whiteColor];
    HUD.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    HUD.removeFromSuperViewOnHide=YES;
    [keyWindow addSubview:HUD];
    [HUD showAnimated:YES];
    [HUD hideAnimated:YES afterDelay:1];///1秒后消失
}

/**
 隐藏hud
 */
- (void)hideHud {
    if ([self HUD]) {
        [MBProgressHUD hideHUDForView:[self getView] animated:YES];
        self.HUD = nil;
    }
}


- (void)showLoadingWindow {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    MBProgressHUD *HUD=[[MBProgressHUD alloc]initWithView:keyWindow];
    HUD.contentColor=[UIColor whiteColor];
    HUD.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    HUD.contentColor=[UIColor clearColor];
    HUD.label.text=@"正在加载";
    HUD.removeFromSuperViewOnHide=YES;
    [keyWindow addSubview:HUD];
    [HUD showAnimated:YES];
}

- (void)hideWindow {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [MBProgressHUD hideHUDForView:keyWindow animated:YES];
}


-(UIView *)getView
{
    UIView *view;
    if (self.navigationController.view) {
        view=self.navigationController.view;
    }else
    {
        view=self.view;
    }
    return view;
}
@end
