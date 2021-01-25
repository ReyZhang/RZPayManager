//
//  PayConfig.m
//
//  Created by reyzhang on 2020/5/25.
//  Copyright © 2020. All rights reserved.
//

#import "PayConfig.h"

@interface PayConfig ()
@property (nonatomic,strong) NSMutableDictionary *strategyMap;
@end

@implementation PayConfig

//单例对象
+ (instancetype)config {
    static PayConfig *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_instance) {
           _instance = [[PayConfig alloc] init];
        }
    });
    return _instance;
}

//添加获取预支付信息对应的策略类， 没有传递实例对象，避免未使用而造成的内存浪费
- (void)appendPrepayDataStrategy:(Class)strategyClass
                     withPayType:(RZPayType)payType {
    if (!strategyClass) {
        return;
    }

    //判断是否实现了协议
    if (![strategyClass conformsToProtocol:@protocol(PayDataPrepareProtocol)]) {
        return;
    }
    
    NSString *payTypeKey = [self convertPayTypeToString:payType]; //将枚举转成字符串
    [self.strategyMap setObject:strategyClass forKey:payTypeKey];

}

- (NSString *)convertPayTypeToString:(RZPayType)payType {
    NSString *payTypeKey = @"pay";
    if (payType == PayTypeForAlipay) {
        payTypeKey =  @"Alipay";
    }else if (payType == PayTypeForWXPay) {
        payTypeKey = @"WXPay";
    }
    return payTypeKey;
}

//判断是否存在指定类型对应的实现策略
- (BOOL)containsPrepayDataStrategyWithPayType:(RZPayType)payType {
    NSString *payTypeKey = [self convertPayTypeToString:payType]; //将枚举转成字符串
    BOOL isContains =   ![self.strategyMap[payTypeKey] isNull];
    return isContains;
}

//根据支付的枚举类型，获取预支付信息处理对象
- (id<PayDataPrepareProtocol>)getPrepayDataStrategyWithPayType:(RZPayType)payType {

    if (![self containsPrepayDataStrategyWithPayType:payType]) {
        return nil;
    }

    NSString *payTypeKey = [self convertPayTypeToString:payType]; //将枚举转成字符串
    Class cls = self.strategyMap[payTypeKey];

    return [[cls alloc] init]; //在需要时才返回创建的对象
}

//懒加载，需要时创建
- (NSMutableDictionary *)strategyMap {
    if (!_strategyMap) {
        _strategyMap = @{}.mutableCopy;
    }
    return _strategyMap;
}
@end
