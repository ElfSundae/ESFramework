source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '6.0'

workspace 'ESFramework.xcworkspace'

xcodeproj 'Example.xcodeproj'

target 'Example', :exclusive => true do
    pod "ESFramework", :path => "./"
end

post_install do |installer|

    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|

            if config.name.include?("Debug")
                # Add DEBUG to custom configurations containing 'Debug'
                config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)']
                if !config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'].include? 'DEBUG=1'
                    config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] << 'DEBUG=1'
                end
                config.build_settings['GCC_OPTIMIZATION_LEVEL'] = '0'
                config.build_settings['ENABLE_NS_ASSERTIONS'] = 'YES'
                config.build_settings['OTHER_CFLAGS'] ||= ['$(inherited)']
                if config.build_settings['OTHER_CFLAGS'].include? '-DNS_BLOCK_ASSERTIONS=1'
                    config.build_settings['OTHER_CFLAGS'].delete('-DNS_BLOCK_ASSERTIONS=1')
                end
            end # Debug

        end
    end
end
