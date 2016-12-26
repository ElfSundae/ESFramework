Pod::Spec.new do |s|
  s.name              = "ESFramework"
  s.version           = "2.6.0"
  s.license           = "MIT"
  s.summary           = "An Effective & Swingy Framework for iOS."
  s.homepage          = "https://github.com/ElfSundae/ESFramework"
  s.authors           = { "Elf Sundae" => "http://0x123.com" }
  s.source            = { :git => "https://github.com/ElfSundae/ESFramework.git", :tag => s.version, :submodules => true }
  s.social_media_url  = "https://twitter.com/ElfSundae"

  s.requires_arc            = true
  s.ios.deployment_target   = "7.0"
  s.source_files            = "ESFramework/ESFramework.h"

  s.subspec "Reachability" do |ss|
    ss.ios.deployment_target  = "7.0"
    ss.osx.deployment_target  = "10.9"

    ss.source_files           = "ESFramework/Reachability/*.{h,m}"
    ss.frameworks             = "SystemConfiguration"
  end

  s.subspec "Core" do |ss|
    ss.dependency             "ESFramework/Reachability"
    ss.source_files           = "ESFramework/Core/**/*.{h,m}"
    ss.private_header_files   = "ESFramework/Core/**/_*.h"
    ss.frameworks             = "Security", "CoreTelephony", "SystemConfiguration"
    ss.weak_frameworks        = "UserNotifications"
  end

  s.subspec "UIKit" do |ss|
    ss.dependency             "ESFramework/Core"
    ss.source_files           = "ESFramework/UIKit/**/*.{h,m}"
    ss.frameworks             = "QuartzCore", "StoreKit", "MediaPlayer"
  end
end
