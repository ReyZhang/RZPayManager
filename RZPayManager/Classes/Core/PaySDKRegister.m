//
//  PaySDKRegister.m
//  RZPayManager
//
//  Created by rey zhang on 2021/1/26.
//

#import "PaySDKRegister.h"
#import <WXApi.h>

@implementation PaySDKRegister

- (id)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _platformsInfo = @{}.mutableCopy;
}


/**
 设置微信支付信息
 
 @param appId 应用标识
 @param appSecret 应用密钥
 @param universalLink 应用深度连接
 */
- (void)setupWeChatWithAppId:(NSString *)appId
                   appSecret:(NSString *)appSecret
               universalLink:(NSString *)universalLink {
    NSAssert(appId.length > 0, @"未配置微信支付的appId");
    NSAssert(universalLink.length > 0, @"未配置微信支付的universalLink");
    [WXApi registerApp:appId universalLink:universalLink];
    
    //存储注册的平台信息
    NSMutableDictionary *info = @{}.mutableCopy;
    info[@"appId"] = appId;
    info[@"appSecret"] = appSecret;
    info[@"universalLink"] = universalLink;
    
    _platformsInfo[@"wechat"] = info;
}



@end
