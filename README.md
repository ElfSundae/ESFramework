ESFramework
===========

**Just developing...**


Requirements
============
* Xcode 5.0 or later
* iOS deployment target >= 5.0
* ARC

Install Documentation
=====================
	cd ~/Library/Developer/Shared/Documentation/DocSets; \
	rm -f "com.0x123.ESFramework-1.0.xar" \
	rm -rf "com.0x123.ESFramework.docset" \
	curl -O "https://raw.githubusercontent.com/ElfSundae/ESFramework/master/docs/docset/publish/com.0x123.ESFramework-1.0.xar"; \
	xar -x -f "com.0x123.ESFramework-1.0.xar"; \
	rm "com.0x123.ESFramework-1.0.xar"


