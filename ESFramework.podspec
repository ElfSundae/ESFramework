Pod::Spec.new do |s|
  s.name        = 'ESFramework'
  s.version     = '3.5.1'
  s.license     = { :type => 'MIT', :file => 'LICENSE' }
  s.summary     = 'ESFramework is an efficient, small framework for iOS.'
  s.homepage    = 'https://github.com/ElfSundae/ESFramework'
  s.authors     = { 'Elf Sundae' => 'https://0x123.com' }
  s.source      = { :git => 'https://github.com/ElfSundae/ESFramework.git', :tag => s.version.to_s, :submodules => true }

  s.ios.deployment_target = '9.0'
  s.module_name = 'ESFramework'
  s.source_files = 'ESFramework/**/*.{h,m}'
  s.frameworks = 'UIKit', 'Security', 'SystemConfiguration', 'CoreTelephony'
  s.dependency 'AFNetworking/Reachability'
end
