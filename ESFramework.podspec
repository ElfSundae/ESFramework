Pod::Spec.new do |s|
  s.name              = "ESFramework"
  s.version           = "2.2.1"
  s.license           = "MIT"
  s.summary           = "An Effective & Swing Framework for iOS."
  s.homepage          = "https://github.com/ESFramework/ESFramework"
  s.authors           = { "Elf Sundae" => "http://0x123.com" }
  s.source            = { :git => "https://github.com/ESFramework/ESFramework.git", :tag => s.version, :submodules => true }
  s.social_media_url  = "https://twitter.com/ElfSundae"

  s.platform              = :ios
  s.ios.deployment_target = "7.0"

  s.requires_arc      = true
  s.frameworks        = "Foundation", "CoreFoundation", "UIKit", "CoreGraphics", "Security", "SystemConfiguration", "CoreTelephony"
  s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-ObjC' }

  s.source_files      = "ESFramework/**/*.{h,m}"
  s.private_header_files = "ESFramework/**/*Private.h"
end
