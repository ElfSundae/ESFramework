ESFramework
======

A lightweight iOS framework for app development.

**Just working in progress...**


Requirements
======

* Xcode 5.0 or later
* iOS deployment target >= 5.0
* ARC

Install Documentation
======

	cd ~/Library/Developer/Shared/Documentation/DocSets
	rm -f "com.0x123.ESFramework-1.0.xar"
	rm -rf "com.0x123.ESFramework.docset"
	curl -O "https://raw.githubusercontent.com/ElfSundae/ESFramework/master/docs/docset/publish/com.0x123.ESFramework-1.0.xar"
	xar -x -f "com.0x123.ESFramework-1.0.xar"
	rm "com.0x123.ESFramework-1.0.xar"
	
	
Building Frameworks
======

Close `ESFramework.xcworkspace` workspace from Xcode and open `ESFramework.xcodeproj` project, scheme `AllFrameworks` and target `iOS Device`, then clean & build.
After building succeed, right-click one `xxxx.a` under `Products` and "Show in Finder", you will get all Frameworks and `ESFrameworkResources.bundle`.

Add new target
======

1. 创建一个静态库target: xxx, 添加"Headers Phase",并添加xxx.h到public中.
2. 添加xxxDebug.xcconfig和xxxRelease.xcconfig, 配置相应属性
3. 在ESFramework的项目属性中, 配置config文件. 在静态库项目的build setting中删除所有加粗的配置





