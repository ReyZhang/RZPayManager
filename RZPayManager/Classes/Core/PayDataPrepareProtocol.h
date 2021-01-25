//
//  PayDataPrepareProtocol.h
//
//  Created by reyzhang on 2020/5/25.
//  Copyright © 2020. All rights reserved.
//  支付组件 - 支付前的数据准备协议  reyzhang

#ifndef PayDataPrepareProtocol_h
#define PayDataPrepareProtocol_h

@protocol PayDataPrepareProtocol <NSObject>
@property (nonatomic,strong) NSDictionary *requestParams;
@required
- (void)getPayData:(void(^)(id result, NSError *error))block;

@end

#endif /* PayDataPrepareProtocol_h */
