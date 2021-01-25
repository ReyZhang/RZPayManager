//
//  UIViewController+Extension.m
//
//  Created by reyzhang on 2020/5/14.
//  Copyright © 2020. All rights reserved.
//

#import "UIViewController+Extension.h"

@implementation UIViewController (Extension)


/*!
 获取当前控制器 reyzhang
 */
+ (UIViewController *)currentViewController {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    
    return currentVC;
}

+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
  UIViewController *currentVC;
  
  if ([rootVC presentedViewController]) {
    // 视图是被presented出来的
    rootVC = [rootVC presentedViewController];
  }
  
  if ([rootVC isKindOfClass:[UITabBarController class]]) {
    // 根视图为UITabBarController
    
    currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
    
  } else if ([rootVC isKindOfClass:[UINavigationController class]]){
    // 根视图为UINavigationController
    
    currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    
  } else {
    // 根视图为非导航类
    
    currentVC = rootVC;
  }
  
  return currentVC;
}


@end
