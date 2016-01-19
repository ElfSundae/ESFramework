# ESFramework

[![Build Status](https://travis-ci.org/ESFramework/ESFramework.svg)](https://travis-ci.org/ESFramework/ESFramework)
[![Pod Version](http://img.shields.io/cocoapods/v/ESFramework.svg)](http://cocoadocs.org/docsets/ESFramework)

An **E**ffective & **S**wing **Framework** for iOS.

## Requirements

* Xcode 7.0 or later
* iOS deployment target >= 7.0
* ARC

## Installation

There are two ways to use ESFramework in your project:

* Use [CocoaPods](http://cocoapods.org) **(Recommended)**

```ruby
pod "ESFramework", "~> 2.0"
```

Subspecs:

```ruby
pod "ESFramework/Core", "~> 2.0"
pod "ESFramework/Additions", "~> 2.0"
pod "ESFramework/App", "~> 2.0"
```

* Copy `ESFramework` directory into your project.

## Contribute Notes

* Get started

```shell
git clone -b develop https://github.com/ESFramework/ESFramework.git
pod install --no-repo-update
open ESFramework.xcworkspace
```

If you added/moved/removed files in ESFramework directory, clean `Pods` and run `pod install` before building.

```shell
rm -rf Pods
pod install --no-repo-update
```

* Submit pull request to **develop** branch.
* Set text indent of the `Pods` project to **use Spaces with 8 widths**.

## License

ESFramework is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
