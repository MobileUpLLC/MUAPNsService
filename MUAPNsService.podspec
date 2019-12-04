Pod::Spec.new do |spec|
  
  spec.name          = 'MUAPNsService'
  spec.version       = '0.0.1'
  spec.license       = { :type => 'MIT' }
  spec.homepage      = 'https://github.com/MobileUpLLC/MUAPNsService.git'
  spec.authors       = { 'Edgar Semko' => 'edgar.semko@mobileup.ru' }
  spec.summary       = 'MUAPNsService'
  spec.source        = { :git => 'https://github.com/MobileUpLLC/MUAPNsService.git', :tag => '0.0.1' }
  spec.module_name   = 'MUAPNsService'
  spec.swift_version = '4.2'

  spec.ios.deployment_target  = '9.0'

  spec.source_files       = '*.swift'
  spec.ios.source_files   = '*.swift'

  spec.framework      = 'SystemConfiguration'
  spec.ios.framework  = 'UIKit'

  spec.ios.dependency 'MUPushService', '0.0.1'

end