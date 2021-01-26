//
//  PaySDKRegister.h
//  RZPayManager
//
//  Created by rey zhang on 2021/1/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PaySDKRegister : NSObject

@property (strong, nonatomic, readonly) NSMutableDictionary *platformsInfo;

/**
 设置微信支付信息
 
 @param appId 应用标识
 @param appSecret 应用密钥
 @param universalLink 应用深度连接
 */
- (void)setupWeChatWithAppId:(NSString *)appId
                   appSecret:(NSString *)appSecret
               universalLink:(NSString *)universalLink;

@end

NS_ASSUME_NONNULL_END
