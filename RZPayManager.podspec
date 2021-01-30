
Pod::Spec.new do |s|
  s.name             = 'RZPayManager'
  s.version          = '0.1.4'
  s.summary          = 'RZPayManager 是整合了微信，支付宝等第三方支付的支付组件'

  s.description      = <<-DESC
  RZPayManager是对时下各第三方支付平台的整合，将支付的调用简单化，组件化。
                       DESC

  s.homepage         = 'https://github.com/ReyZhang'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'reyzhang' => '27196849@qq.com' }
  s.source           = { :git => 'https://github.com/ReyZhang/RZPayManager.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.pod_target_xcconfig = { 'VALID_ARCHS' => 'x86_64 armv7 armv7s arm64' }
  s.source_files = 'RZPayManager/Classes/**/*'
  s.frameworks = "Foundation", "UIKit"
  
  s.dependency 'AlipaySDK-iOS', '~> 15.7.4'
  s.dependency 'WechatOpenSDK', '~> 1.8.7.1'

  
  s.static_framework = true
  
  #如果引入了本地静态库，需要设置静态库的位置
  s.vendored_libraries = 'RZPayManager/Classes/UPPay/*.a'
  
  
  ########## subspec
  s.subspec 'Category' do |category|
    category.source_files = 'RZPayManager/Classes/Category/**/*'
    category.frameworks = 'UIKit','Foundation'
  end
  
  s.subspec 'Core' do |core|
    core.source_files = 'RZPayManager/Classes/Core/**/*'
    core.frameworks = 'UIKit','Foundation'

    #subspec 之间的相互依赖
    core.dependency 'RZPayManager/Category'
    core.dependency 'RZPayManager/UPPay'
  end

  s.subspec 'UPPay' do |uppay|
    #如果引入了本地静态库，需要设置静态库的位置
    uppay.vendored_libraries = 'RZPayManager/Classes/UPPay/*.a'
    uppay.source_files = 'RZPayManager/Classes/UPPay/*.h'
  end
  
end
