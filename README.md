ESFramework
---

[![Build Status](https://travis-ci.org/ElfSundae/ESFramework.svg)](https://travis-ci.org/ElfSundae/ESFramework)
[![Pod Version](http://img.shields.io/cocoapods/v/ESFramework.svg)](http://cocoadocs.org/docsets/ESFramework)

An **E**ffective & **S**wing **Framework** for iOS.

## Requirements

* Xcode 7.0 or later
* iOS deployment target >= 7.0
* ARC

## Installation

* Via [CocoaPods](http://cocoapods.org) **(Recommended)**

  ```
  pod "ESFramework", "~> 2.4"
  ```
  **Subspecs:**

  ```
  ESFramework/Core
  ESFramework/UIKit
  ```

* **Manually:**

  + Add `ESFramework` directory into your project, except `ESFramework.xcodeproj` file.
  + Regex replace angle brackets in project to fix "header file not found".  
    The regular expression is from `#import\s+[<"]ESFramework/([^>"]+)[>"]` to `#import "$1"`.  
    [![replace-angle-brackets](https://raw.githubusercontent.com/ElfSundae/ESFramework/master/screenshots/replace-angle-brackets.png)](https://raw.githubusercontent.com/ElfSundae/ESFramework/master/screenshots/replace-angle-brackets.png)


## Contribute Notes

```shell
git clone -b develop https://github.com/ESFramework/ESFramework.git
cd ESFramework/Example
pod install --no-repo-update
open ../ESFramework.xcworkspace
```

## License

ESFramework is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
