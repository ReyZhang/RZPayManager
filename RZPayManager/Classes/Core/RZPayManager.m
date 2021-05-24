//
//  RZPayManager.m
//
//  Created by reyzhang on 2020/5/25.
//  Copyright © 2020. All rights reserved.
//

#import "RZPayManager.h"
#import "WXPayService.h"


NSString *ALIPAY_CALLBACK_NOTIFICATION = @"Notification_Alipay_CallBack";
NSString *UPPAY_CALLBACK_NOTIFICATION = @"Notification_UPPay_CallBack";


@implementation RZPayManager {
    id prepareData;
}

/*!
 根据支付类型，回调来创建实例
 */
- (instancetype)initWithPayType:(RZPayType)payType
                       delegate:(id<RZPayManagerDelegate>)delegate {
    if (self = [super init]) {
        self.payType = payType;
        self.delegate = delegate;
        [self commonInit];
    }
    return self;
}


- (id)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}


- (void)commonInit {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayCallBackHandler:) name:ALIPAY_CALLBACK_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uppayCallBackHandler:) name:UPPAY_CALLBACK_NOTIFICATION object:nil];
}

//开始支付
- (void)startPay {
    
    //1. 根据支付类型，判断支付配置中是否有需要请求服务API的处理类
    if ([[PayConfig config] containsPrepayDataStrategyWithPayType:self.payType]) {
        id strategy = [[PayConfig config] getPrepayDataStrategyWithPayType:self.payType];
        
        //向请求API接口的策略类传递请求参数
        [strategy setValue:self.requestParams forKey:@"requestParams"];
        //准备好请求数据后，开始调用接口API获取所需要的预支付信息
        [strategy getPayData:^(id result, NSError *error ) {
            //拿到需要的预支付信息后，再调起第三方支付组件
            if (!error) {
                if ([result isKindOfClass:[NSString class]]) { //如果是字符串的情况 银联取TN，支付宝取url
                    if (self.payType == PayTypeForAlipay ||
                        self.payType == PayTypeForUPPay) {
                        self->prepareData  = [NSString stringWithFormat:@"%@",data];
                    }else if (self.payType == PayTypeForWXPay){ //微信的话，需要转成字典
                        NSString *jsonStr = [NSString stringWithFormat:@"%@",data];
                        self->prepareData = [jsonStr jsonValueDecoded];
                    }
                }else if ([data isKindOfClass:[NSDictionary class]]) {
                    self->prepareData = (NSDictionary *)data;
                }
                
                [self beginToPay];
            }
        }];
    
    }else {
        // 调起第三方支付组件
        [self beginToPay];
    }
}



- (void)beginToPay {
    if (self.payType == PayTypeForAlipay) {
        [self doAlipay];
    }else if (self.payType == PayTypeForWXPay) {
        [self doWXPay];
    }else if (self.payType == PayTypeForUPPay) {
        [self doUPPay];
    }
}



#pragma mark -===============Alipay===================-
- (void)doAlipay {
    NSAssert(![[PayConfig config].appScheme isNull], @"未配置应用URL Scheme");
    [[AlipaySDK defaultService]
     payOrder:self->prepareData
     fromScheme:[PayConfig config].appScheme
     callback:^(NSDictionary *resultDic) {
                    [self handerAlipayResult:resultDic];
                }];
}


#pragma mark ==========NotificationHandler======================
- (void)alipayCallBackHandler:(NSNotification *)notif {
    NSDictionary *resultDic = (NSDictionary *)notif.object;
    [self handerAlipayResult:resultDic];
}

- (void)handerAlipayResult:(NSDictionary  *)resultDic {
    NSInteger resultStatus = [resultDic[@"resultStatus"] integerValue];
    NSString *showMessage = nil;
    switch (resultStatus) {
        case 9000:
            showMessage = @"订单支付成功";
            break;
        case 8000:
            showMessage = @"支付正在处理中";
            break;
        case 4000:
            showMessage = @"订单支付失败";
            break;
        case 6001:
            showMessage = @"支付已取消";
            break;
        case 6002:
            showMessage = @"网络连接出错";
            break;
        default:
            break;
    }
//    [self.fromVC showMessage:showMessage];
    
    NSDictionary *dic = @{@"message":(showMessage ?: @"")};
    
    if (resultStatus == 9000) { //支付成功
        if ([self.delegate respondsToSelector:@selector(paymanager:paySuccess:)]) {
            [self.delegate paymanager:self paySuccess:resultDic];
        }
    }else{ //支付失败
        if ([self.delegate respondsToSelector:@selector(paymanager:payFailure:)]) {
            NSError *error = [NSError errorWithDomain:@"com.haoda" code:500 userInfo:dic];
            [self.delegate paymanager:self payFailure:error];
        }
    }
    
}



- (void)uppayCallBackHandler:(NSNotification *)notif {
    NSDictionary *resultDic = (NSDictionary *)notif.object;
    [self handerUPPayResult:resultDic];
}

- (void)handerUPPayResult:(NSDictionary *)resultDic {
    NSString *code = [NSString stringWithFormat:@"%@",resultDic[@"code"]];
//    NSDictionary *data = (NSDictionary *)resultDic[@"data"];
    
    NSString *message = @"";
    if([code isEqualToString:@"success"]) {
        //结果code为成功时，去商户后台查询一下确保交易是成功的再展示成功
        //....todo
        message = @"支付成功";
        
        // -- 成功回调
        if ([self.delegate respondsToSelector:@selector(paymanager:paySuccess:)]) {
            [self.delegate paymanager:self paySuccess:@{@"memo":message ?: @""}];
        }
    }
    else if([code isEqualToString:@"fail"]) {
        //交易失败
        message = @"支付失败";
        NSError *error = [NSError errorWithDomain:@"" code:200 userInfo:@{@"memo":message ?: @""}];
        
        // -- 失败回调
        if ([self.delegate respondsToSelector:@selector(paymanager:payFailure:)]) {
            [self.delegate paymanager:self payFailure:error];
        }
    }
    else if([code isEqualToString:@"cancel"]) {
        //交易取消
        message = @"支付取消";
        NSError *error = [NSError errorWithDomain:@"" code:201 userInfo:@{@"memo":message ?: @""}];
        
        // -- 失败回调
        if ([self.delegate respondsToSelector:@selector(paymanager:payFailure:)]) {
            [self.delegate paymanager:self payFailure:error];
        }
    }

}


#pragma mark -===============WXPay===================-
- (void)doWXPay {
    PayReq *payReq =  [WXPayService getPayRequest:self->prepareData];
    [[WXPayService sharedInstance] startPayWithReq:payReq
                                          callback:^(BaseResp * _Nonnull resp) {
        if (!resp) {
            return ;
        }
        
        if (resp.errCode == WXSuccess) {
            if ([self.delegate respondsToSelector:@selector(paymanager:paySuccess:)]) {
                [self.delegate paymanager:self paySuccess:@{@"message":@"支付成功"}];
            }
        }else {
            if ([self.delegate respondsToSelector:@selector(paymanager:payFailure:)]) {
                NSError *error = [NSError errorWithDomain:@"com.haoda" code:resp.errCode userInfo:@{@"message":resp.errStr ?: @"支付已取消"}];
                [self.delegate paymanager:self payFailure:error];
            }
        }
    }];
}

#pragma mark ==========UPPay======================
- (void)doUPPay {
    [[UPPaymentControl defaultControl] startPay:self->prepareData
                                     fromScheme:[PayConfig config].appScheme
                                           mode:@"00"
                                 viewController:self.fromVC];
}


#pragma mark -===============getter===================-
- (UIViewController *)fromVC {
    if (!_fromVC) {
        _fromVC = [UIViewController currentViewController];
    }
    return _fromVC;
}





+ (void)parseCallbackUrl:(NSURL *)url {
    if ([url.host isEqualToString:@"safepay"]) { //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // -- 发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:ALIPAY_CALLBACK_NOTIFICATION object:resultDic];
            
        }];
    }else if ([url.host isEqualToString:@"pay"]) { // -- 微信支付
        [WXApi handleOpenURL:url delegate:[WXPayService sharedInstance]];
    }else if ([url.absoluteString containsString:@"uppayresult"]) { // -- 银联支付
        //处理银联的一个bug, 返回的url如下：hwyapp://paydemo://uppayresult?xxxx rey 2019.10.22
        NSString *absoluteString = url.absoluteString;
        absoluteString = [absoluteString stringByReplacingOccurrencesOfString:@"paydemo://" withString:@""];
        [[UPPaymentControl defaultControl] handlePaymentResult:[NSURL URLWithString:absoluteString] completeBlock:^(NSString *code, NSDictionary *data) {
            // -- 发送通知
            NSMutableDictionary *resultDic = @{}.mutableCopy;
            resultDic[@"code"] = code ?: @"";
            resultDic[@"data"] = data ?: @{};
            [[NSNotificationCenter defaultCenter] postNotificationName:UPPAY_CALLBACK_NOTIFICATION object:resultDic];
        }];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
