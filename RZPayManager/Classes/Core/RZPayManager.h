//
//  RZPayManager.h
//
//  Created by reyzhang on 2020/5/25.
//  Copyright © 2020. All rights reserved.
//  统一支付管理器  reyzhang

#import <Foundation/Foundation.h>
#import "PayConfig.h"
#import "PayDataPrepareProtocol.h"
#import "UIViewController+Extension.h"
#import <WXPayService.h>
#import <AlipaySDK/AlipaySDK.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString *kNotification_Alipay_CallBack;

typedef NS_ENUM(NSInteger,PayStatus) {
    PaySuccess,
    PayCancel,
    PayFail,
    PayNotInstalled,
};


@class RZPayManager;
@protocol RZPayManagerDelegate <NSObject>

- (void)paymanager:(RZPayManager *)manager paySuccess:(NSDictionary *)result;
- (void)paymanager:(RZPayManager *)manager payFailure:(NSError *)error;

@end


@interface RZPayManager : NSObject
//调用预支付信息API接口，用到的请求参数
@property (nonatomic,strong) NSDictionary *requestParams;
//调用组件来自的控制器
@property (nonatomic,weak) UIViewController *fromVC;
//支付第三方类型
@property (nonatomic,assign) RZPayType payType;
//支付回调
@property (nonatomic,weak) id<RZPayManagerDelegate> delegate;

/*!
 根据支付类型，回调来创建实例
 */
- (instancetype)initWithPayType:(RZPayType)payType
                       delegate:(id<RZPayManagerDelegate>)delegate;


/*
 * 开始支付 订单使用
 * 有预支付请求操作
 */
- (void)startPay;

/** 需要传预支付请求返回数据 */
- (void)startPayData:(id)result;

- (void)releasePay;

@end

NS_ASSUME_NONNULL_END
