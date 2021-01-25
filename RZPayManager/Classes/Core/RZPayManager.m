//
//  RZPayManager.m
//
//  Created by reyzhang on 2020/5/25.
//  Copyright © 2020. All rights reserved.
//

#import "RZPayManager.h"
#import "WXPayService.h"

NSString *kNotification_Alipay_CallBack = @"Notification_Alipay_CallBack";

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayCallBackHandler:) name:kNotification_Alipay_CallBack object:nil];
}

//开始支付
- (void)startPay {
    
    //1. 根据支付类型，判断支付配置中是否有需要请求服务API的处理类
    if ([[PayConfig config] containsPrepayDataStrategyWithPayType:self.payType]) {
        id strategy = [[PayConfig config] getPrepayDataStrategyWithPayType:self.payType];
        
        //向请求API接口的策略类传递请求参数
        [strategy setValue:self.requestParams forKey:@"requestParams"];
        
//        [self.fromVC showLoading];
        //准备好请求数据后，开始调用接口API获取所需要的预支付信息
        [strategy getPayData:^(id result, NSError *error ) {
            //拿到需要的预支付信息后，再调起第三方支付组件
//            [self.fromVC hideHUD];
            if (!error) {
                id data = result[@"data"];
                if ([data isKindOfClass:[NSString class]]) {
                    if (self.payType == PayTypeForAlipay) {
                        self->prepareData  = [NSString stringWithFormat:@"%@",data];
                    }else {
                        NSString *jsonStr = [NSString stringWithFormat:@"%@",data];
                        self->prepareData = [jsonStr jsonValueDecoded];
                    }
                }else if ([data isKindOfClass:[NSDictionary class]]) {
                    self->prepareData = (NSDictionary *)data;
                }
                
                [self beginToPay];
            }else {
//                [self.fromVC showMessage:result[@"message"]];
            }
            
        }];
    
    }else {
        // 调起第三方支付组件
        [self beginToPay];
    }
}

/** 需要传预支付请求返回数据 */
- (void)startPayData:(id)result {
    id data = result[@"data"];
    if ([data isKindOfClass:[NSString class]]) {
        if (self.payType == PayTypeForAlipay) {
            self->prepareData  = [NSString stringWithFormat:@"%@",data];
        }else {
            NSString *jsonStr = [NSString stringWithFormat:@"%@",data];
            self->prepareData = [jsonStr jsonValueDecoded];
        }
    }else if ([data isKindOfClass:[NSDictionary class]]) {
        self->prepareData = (NSDictionary *)data;
    }
    
    [self beginToPay];
}

- (void)beginToPay {
    if (self.payType == PayTypeForAlipay) {
        [self doAlipay];
    }else if (self.payType == PayTypeForWXPay) {
        [self doWXPay];
    }
}

- (void)releasePay {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark -===============Alipay===================-
- (void)doAlipay {
//    [[AlipaySDK defaultService]
//     payOrder:self->prepareData
//     fromScheme:kAppScheme
//     callback:^(NSDictionary *resultDic) {
//                    [self handerAlipayResult:resultDic];
//                }];
}


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


#pragma mark -===============getter===================-
- (UIViewController *)fromVC {
    if (!_fromVC) {
        _fromVC = [UIViewController currentViewController];
    }
    return _fromVC;
}
@end
