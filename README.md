# ESFramework

[![Build Status](https://travis-ci.org/ESFramework/ESFramework.svg)](https://travis-ci.org/ESFramework/ESFramework)
[![Pod Version](http://img.shields.io/cocoapods/v/ESFramework.svg)](http://cocoadocs.org/docsets/ESFramework)

An **E**ffective & **S**wing **Framework** for iOS.

# Requirements

* Xcode 7.0 or later
* iOS deployment target >= 7.0
* ARC

# Installation

* Via [CocoaPods](http://cocoapods.org) **(Recommended)**

```ruby
pod "ESFramework", "~> 2.0"
```

**Subspecs:**

```
ESFramework/Core
ESFramework/Additions
ESFramework/App
ESFramework/StoreKit
ESFramework/UIKit
ESFramework/UIKit/Animation
ESFramework/UIKit/View
ESFramework/UIKit/RefreshControl
ESFramework/UIKit/Controller
```

* Manually: copy `ESFramework` directory into your project.

# Contribute Notes

```shell
git clone -b develop https://github.com/ESFramework/ESFramework.git
cd ESFramework/Example
pod install --no-repo-update
open ../ESFramework.xcworkspace
```

If you added/moved/removed files in ESFramework directory,
before rebuilding you must delete `Pods` directory then run `pod install`.

```shell
rm -rf Pods
pod install --no-repo-update
```

# License

ESFramework is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
