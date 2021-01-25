
Pod::Spec.new do |s|
  s.name             = 'RZPayManager'
  s.version          = '0.1.0'
  s.summary          = 'A short description of RZPayManager.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/ReyZhang'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'reyzhang' => '27196849@qq.com' }
  s.source           = { :git => 'https://github.com/ReyZhang/RZPayManager.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'RZPayManager/Classes/**/*'
  
  s.dependency 'AlipaySDK-iOS', '~> 15.7.4'
  s.static_framework = true
  s.vendored_libraries = 'RZPayManager/Classes/WeChatSDKFull/*.a'
end
