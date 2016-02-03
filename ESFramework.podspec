Pod::Spec.new do |s|
  s.name              = "ESFramework"
  s.version           = "2.3.3"
  s.license           = "MIT"
  s.summary           = "An Effective & Swing Framework for iOS."
  s.homepage          = "https://github.com/ESFramework/ESFramework"
  s.authors           = { "Elf Sundae" => "http://0x123.com" }
  s.source            = { :git => "https://github.com/ESFramework/ESFramework.git", :tag => s.version, :submodules => true }
  s.social_media_url  = "https://twitter.com/ElfSundae"

  s.platform              = :ios
  s.ios.deployment_target = "7.0"
  s.requires_arc          = true
  s.source_files          = "ESFramework/ESFramework.h"

  s.subspec "Core" do |ss|
    ss.source_files         = "ESFramework/Core/**/*.{h,m}"
    ss.frameworks           = "CoreGraphics"
  end

  s.subspec "Additions" do |ss|
    ss.source_files         = "ESFramework/Additions/**/*.{h,m}"
    ss.frameworks           = "CoreTelephony", "SystemConfiguration"
    ss.dependency           "ESFramework/Core"
  end

  s.subspec "App" do |ss|
    ss.source_files         = "ESFramework/App/**/*.{h,m}"
    ss.private_header_files = "ESFramework/App/**/*+Private.h"
    ss.dependency             "ESFramework/Core"
    ss.dependency             "ESFramework/Additions"
  end

  s.subspec "StoreKit" do |ss|
    ss.source_files         = "ESFramework/StoreKit/**/*.{h,m}"
    ss.frameworks           = "StoreKit"
    ss.dependency           "ESFramework/Core"
    ss.dependency           "ESFramework/Additions"
    ss.dependency           "ESFramework/App"
  end

  s.subspec "UIKit" do |ss|
    ss.source_files         = "ESFramework/UIKit/ESFrameworkUIKit.h"
    ss.frameworks           = "QuartzCore"

    ss.subspec "Animation" do |sss|
      sss.source_files      = "ESFramework/UIKit/Animation/**/*.{h,m}"
    end
    ss.subspec "View" do |sss|
      sss.source_files      = "ESFramework/UIKit/View/**/*.{h,m}"
      sss.dependency          "ESFramework/Core"
      sss.dependency          "ESFramework/Additions"
    end
    ss.subspec "RefreshControl" do |sss|
      sss.source_files      = "ESFramework/UIKit/RefreshControl/**/*.{h,m}"
      sss.dependency          "ESFramework/UIKit/View"
    end
    ss.subspec "Controller" do |sss|
      sss.source_files      = "ESFramework/UIKit/Controller/**/*.{h,m}"
      sss.frameworks        = "MediaPlayer"
      sss.dependency          "ESFramework/App"
      sss.dependency          "ESFramework/UIKit/View"
      sss.dependency          "ESFramework/UIKit/RefreshControl"
    end
  end

end
