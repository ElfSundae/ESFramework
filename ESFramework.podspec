Pod::Spec.new do |s|
  s.name              = "ESFramework"
  s.version           = "2.4.16"
  s.license           = "MIT"
  s.summary           = "An Effective & Swing Framework for iOS."
  s.homepage          = "https://github.com/ElfSundae/ESFramework"
  s.authors           = { "Elf Sundae" => "http://0x123.com" }
  s.source            = { :git => "https://github.com/ElfSundae/ESFramework.git", :tag => s.version, :submodules => true }
  s.social_media_url  = "https://twitter.com/ElfSundae"

  s.platform              = :ios, "7.0"
  s.requires_arc          = true
  s.source_files          = "ESFramework/ESFramework.h"

  s.subspec "Core" do |ss|
    ss.source_files         = "ESFramework/Core/**/*.{h,m}"
    ss.private_header_files = "ESFramework/Core/**/*+Private.h"
    ss.frameworks           = "Security", "CoreTelephony", "SystemConfiguration"
  end

  s.subspec "UIKit" do |ss|
    ss.source_files         = "ESFramework/UIKit/**/*.{h,m}"
    ss.frameworks           = "QuartzCore", "StoreKit", "MediaPlayer"
    ss.dependency           "ESFramework/Core"
  end
end
