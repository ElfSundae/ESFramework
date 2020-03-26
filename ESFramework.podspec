Pod::Spec.new do |s|
  s.name        = 'ESFramework'
  s.version     = '3.21.1'
  s.license     = { :type => 'MIT', :file => 'LICENSE' }
  s.summary     = 'An efficient, lightweight foundational framework for iOS, macOS, tvOS and watchOS.'
  s.homepage    = 'https://github.com/ElfSundae/ESFramework'
  s.social_media_url = 'https://twitter.com/ElfSundae'
  s.authors     = { 'Elf Sundae' => 'https://0x123.com' }
  s.source      = { :git => 'https://github.com/ElfSundae/ESFramework.git', :tag => s.version }

  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'
  s.osx.deployment_target = '10.11'
  s.watchos.deployment_target = '2.0'

  s.pod_target_xcconfig = {
    'PRODUCT_BUNDLE_IDENTIFIER' => 'com.0x123.ESFramework'
  }

  s.subspec 'Foundation' do |ss|
    ss.source_files = 'ESFramework/ESFramework.h', 'ESFramework/Foundation/*.{h,m}'
    ss.frameworks = 'CoreGraphics', 'Security'
  end

  s.subspec 'Network' do |ss|
    ss.ios.deployment_target = '8.0'
    ss.tvos.deployment_target = '9.0'
    ss.osx.deployment_target = '10.11'

    ss.source_files = 'ESFramework/ESFramework.h', 'ESFramework/Network/*.{h,m}'
    ss.ios.frameworks = 'SystemConfiguration', 'CoreTelephony'
  end

  s.subspec 'UIKit' do |ss|
    ss.ios.deployment_target = '8.0'
    ss.tvos.deployment_target = '9.0'

    ss.source_files = 'ESFramework/UIKit/*.{h,m}'
    ss.dependency 'ESFramework/Foundation'
    ss.dependency 'ESFramework/Network'
  end
end
