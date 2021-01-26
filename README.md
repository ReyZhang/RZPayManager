# RZPayManager


####介绍
RZPayManager是对时下各第三方支付平台的整合，将支付的调用简单化，组件化。
目前支持的第三方支付平台有：
1. 微信支付
2. 支付宝支付


####安装
可以通过cocopods来安装，将如下代码加入到你的Podfile文件中
```
pod 'RZPayManager'
```

####使用

```
//1. 设置URL Scheme，用于支付完成后的回调
PayConfig *config = [PayConfig config];
config.appScheme = @"your scheme";

//2. 注册支付平台
[PayConfig registPlatforms:^(PaySDKRegister * _Nonnull platformsRegister) {
    
    //注册微信支付
    [platformsRegister setupWeChatWithAppId:@"wx_appid" appSecret:@"wx_appSecret" universalLink:@"wx_universalLink"];
    
    
}];
```

PayConfig类是支付配置类（单例对象），提供支付需要的配置信息

发起支付请求，离不开去业务方获取支付数据。 为了让组件不藕合获取业务数据的请求处理，在设计时使用了面向协议的方式对块进行隔离。

PayDataPrepareProtocol 协议
```
@protocol PayDataPrepareProtocol <NSObject>
@property (nonatomic,strong) NSDictionary *requestParams;
@required
- (void)getPayData:(void(^)(id result, NSError *error))block;

@end
```
以微信支付为例， 在发起微信支付请求后，需要向服务器端请求支付的数据，再交由支付组件完成支付。所以获取支付数据的类，需要实现PayDataPrepareProtocol这个协议

```
@interface WXPrepareData : NSObject<PayDataPrepareProtocol>

@end


@implementation WXPrepareData
@synthesize requestParams;


- (void)getPayData:(void (^)(id, NSError *))block {
    //发起网络请求，并返回数据
    [[ServerManger getInstance]
     OrderOrderPayOrderId:self.requestParams[@"orderId"]
     payType:@"2"
     payAmount:self.requestParams[@"payAmount"]
     Success:^(BOOL Success,NSDictionary *dic) {
            !block ?: block(dic,nil);
               
        } failure:^(NSError *error) {
           !block ?: block(nil,error);
        }];
}
```

这个获取支付数据的类在添加完以后，需要注册一下才可以被组件使用

```
//添加微信 获取预支付信息的协议
[config appendPrepayDataStrategy:[WXPrepareData class] withPayType:PayTypeForWXPay];

```

如上的处理，都是支付发起前的配置，可以在应用启动后来设置。 完整代码：

```
//1. 设置URL Scheme，用于支付完成后的回调
PayConfig *config = [PayConfig config];
config.appScheme = @"your scheme";

//2. 注册支付平台
[PayConfig registPlatforms:^(PaySDKRegister * _Nonnull platformsRegister) {
    
    //注册微信支付
    [platformsRegister setupWeChatWithAppId:@"wx_appid" appSecret:@"wx_appSecret" universalLink:@"wx_universalLink"];
    
}];

//3. 注册支付数据获取策略
[config appendPrepayDataStrategy:[WXPrepareData class] withPayType:PayTypeForWXPay];
```

支付组件的调用就简单了， 使用代码如下：

```
self.payManager = [[RZPayManager alloc]
                   initWithPayType:self.payType delegate:self];
self.payManager.fromVC = self;
self.payManager.requestParams = @{@"orderId":self.model.orderId,@"payAmount":@"0.0"};

[self.payManager startPay];
```

注意：
RZPayManager对象在使用时，要声明为局部变量或用属性， 不然对象可能会因为被提前释放而接收不到支付回调


