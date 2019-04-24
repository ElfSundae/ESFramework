Pod::Spec.new do |s|
  s.name        = 'ESFramework'
  s.version     = '2.6.2'
  s.license     = { :type => 'MIT', :file => 'LICENSE' }
  s.summary     = 'An Effective & Swingy Framework for iOS.'
  s.homepage    = 'https://github.com/ElfSundae/ESFramework'
  s.authors     = { 'Elf Sundae' => 'https://0x123.com' }
  s.source      = { :git => 'https://github.com/ElfSundae/ESFramework.git', :tag => s.version.to_s, :submodules => true }

  s.ios.deployment_target = '9.0'
  s.source_files = 'ESFramework/**/*.{h,m}'
  s.private_header_files = 'ESFramework/**/_*.h'
  s.frameworks = 'QuartzCore', 'Security', 'SystemConfiguration', 'CoreTelephony', 'StoreKit', 'MediaPlayer'
  s.weak_frameworks = 'UserNotifications'
  s.dependency 'AFNetworking/Reachability'
  s.dependency 'NestedObjectSetters'
end
