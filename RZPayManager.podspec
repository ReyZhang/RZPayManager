
Pod::Spec.new do |s|
  s.name             = 'RZPayManager'
  s.version          = '0.1.2'
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
  
  s.static_framework = true
  s.vendored_libraries = 'RZPayManager/Classes/WeChatSDKFull/*.a'
end
