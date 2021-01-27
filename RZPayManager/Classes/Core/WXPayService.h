//
//  WXPayService.h
//
//  Created by reyzhang on 2020/5/25.
//  Copyright © 2020. All rights reserved.
//  对微信支付的简单封装

#import <Foundation/Foundation.h>
#import "WXApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface WXPayService : NSObject <WXApiDelegate>
///单例来接收微信请求的回调
+ (instancetype)sharedInstance;

// -- 根据接口返回的预支付信息，构造支付请求
+ (PayReq *)getPayRequest:(NSDictionary *)prepayData;


///处理非支付请求的回调
- (void)onRespCallBack:(void(^)(BaseResp * resp))callback;

///从服务器端获取到微信返回的支付请求用到的参数来发起支付请求
- (void)startPayWithReq:(PayReq *)req callback:(void(^)(BaseResp * resp))callback;

@end

NS_ASSUME_NONNULL_END
