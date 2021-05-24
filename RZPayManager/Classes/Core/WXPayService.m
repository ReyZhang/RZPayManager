//
//  WXPayService.m
//
//  Created by reyzhang on 2020/5/25.
//  Copyright © 2020. All rights reserved.
//

#import "WXPayService.h"

@interface WXPayService ()
@property (nonatomic,copy) void(^RespCallBack)(BaseResp *);
@end

@implementation WXPayService


///单例来接收微信请求的回调
+ (instancetype)sharedInstance {
    static WXPayService *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


// -- 根据接口返回的预支付信息，构造支付请求
+ (PayReq *)getPayRequest:(NSDictionary *)prepayData {
    if (prepayData) {
        
        /*
         appId = wx8ae3f5a19880ab27;
         nonceStr = 1590397515731;
         packageValue = "Sign=WXPay";
         partnerId = 1561955001;
         prepayId = wx25170515673491df2a609e551989853100;
         sign = FF5148F4B1B3E800DE488304DF152AD1;
         timeStamp = 1590397515;
         */
        PayReq *req = [[PayReq alloc] init];
        req.partnerId           = prepayData[@"partnerid"];      // -- 商家id
        req.prepayId            = prepayData[@"prepayid"];
        req.nonceStr            = prepayData[@"noncestr"];
        req.timeStamp           = [prepayData[@"timestamp"] intValue];
        req.package             = prepayData[@"package"];
        req.sign                = prepayData[@"sign"];
        
        //日志输出
        NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",prepayData[@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign);
        
        return req;
    }
    return nil;
}


///处理非支付请求的回调
- (void)onRespCallBack:(void(^)(BaseResp * resp))callback {
    self.RespCallBack = callback;
}

///从服务器端获取到微信返回的支付请求用到的参数来发起支付请求
- (void)startPayWithReq:(PayReq *)req callback:(void(^)(BaseResp * resp))callback {
    NSAssert(req !=nil , @"未成功创建微信支付请求");
    self.RespCallBack = callback;
    
    if ([WXApi isWXAppInstalled]) { // -- 判断是否安装微信应用
        //发起微信支付，设置参数
        [WXApi sendReq:req completion:^(BOOL success) {
            NSLog(@"wxpay status:%@",success ? @"success" : @"failure");
        }];
    }else {
        !self.RespCallBack ?: self.RespCallBack(nil);
    }
}



#pragma mark WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[PayResp class]]) { // -- 判断是否为支付的回调
        self.RespCallBack(resp);
    }
}

@end
