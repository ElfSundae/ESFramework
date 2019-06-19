use_frameworks!

workspace 'ESFramework.xcworkspace'
project 'Example/Example.xcodeproj'

abstract_target 'Example' do
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

    target 'watchOS Example' do
        platform :watchos, '2.0'
    end
end
