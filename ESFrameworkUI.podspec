Pod::Spec.new do |s|
  s.name        = 'ESFrameworkUI'
  s.version     = '3.7.0'
  s.license     = { :type => 'MIT', :file => 'LICENSE' }
  s.summary     = 'ESFramework UI Components.'
  s.homepage    = 'https://github.com/ElfSundae/ESFramework'
  s.authors     = { 'Elf Sundae' => 'https://0x123.com' }
  s.source      = { :git => 'https://github.com/ElfSundae/ESFramework.git', :tag => s.version }

  s.ios.deployment_target = '9.0'
  s.module_name = 'ESFrameworkUI'
  s.source_files = 'ESFrameworkUI/**/*.{h,m}'
  s.dependency 'ESFramework', '>= 3.0'
end
