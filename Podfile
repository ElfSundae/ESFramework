workspace 'ESFramework.xcworkspace'

abstract_target 'Example' do
    project 'Example/Example.xcodeproj'

    pod 'ESFramework', :path => '.'

    target 'iOS Example' do
        platform :ios, '9.0'
        pod 'ESFrameworkUI', :path => '.'
    end

    target 'macOS Example' do
        platform :osx, '10.11'
    end

    target 'tvOS Example' do
        platform :tvos, '9.0'
    end
end
