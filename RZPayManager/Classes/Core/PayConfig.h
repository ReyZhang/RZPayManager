//
//  PayConfig.h
//
//  Created by reyzhang on 2020/5/25.
//  Copyright © 2020. All rights reserved.
//  支付配置 单例 管理各支付项对应的预支付数据 reyzhang

#import <Foundation/Foundation.h>
#import "PayDataPrepareProtocol.h"
#import "NSString+Extension.h"
#import "PaySDKRegister.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,RZPayType) {
    PayTypeForAlipay,
    PayTypeForWXPay,
};

typedef void(^RegisterBlock)(PaySDKRegister *platformsRegister);

@interface PayConfig : NSObject

//配置应用的URL Scheme
@property (nonatomic,strong) NSString *appScheme;

/*!
 单例对象
 */
+ (instancetype)config;

/*!
 支付平台原有API注册
 */
+ (void)registPlatforms:(RegisterBlock)block;


/*!
 添加获取预支付信息对应的策略类， 没有传递实例对象，避免未使用而造成的内存浪费
 */
- (void)appendPrepayDataStrategy:(Class)strategyClass withPayType:(RZPayType)payType;

/*!
 判断是否存在指定类型对应的实现策略
 */
- (BOOL)containsPrepayDataStrategyWithPayType:(RZPayType)payType;

/*!
 根据支付的枚举类型，获取预支付信息处理对象
 */
- (id<PayDataPrepareProtocol>)getPrepayDataStrategyWithPayType:(RZPayType)payType;


@end

NS_ASSUME_NONNULL_END
