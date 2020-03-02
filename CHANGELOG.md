# Changelog

## 3.19.0 (2020-03-03)

- Updated iOS minimum deployment target to 8.0
- Moved `Core` pod subspec to `Foundation`
- Moved numeric value related APIs to new file `ESNumericValue.h`, including:
    + ESHelpers.h: `ES***Value()` functions
    + NSNumber+ESExtension.h: `+[NSNumber numberWithString:]`
    + NSString+ESExtension.h: `-[NSString numberValue]`, `-[NSString charValue]` etc
- Renamed methods of getting unsigned value from `ESU***Value` to `ESUnsigned***Value`, e.g. `ESUCharValue` to `ESUnsignedCharValue()`
- Removed AFNetworking dependency
- Removed `network` key from `-[UIApplication analyticsInfo]`
- Removed NSString methods `-contains:`, `-containsCaseInsensitive:`, `-contains:options:`
- Removed `ESScreenSizeString(CGSize size)` function
- Removed `screen_size` from `-[UIApplication analyticsInfo]`, added `screen_width` and `screen_height`
- Removed `Screen` from `-[UIApplication userAgentForHTTPRequest]`
- Removed `ESUUIDString()`
- Generate Xcode projects through XcodeGen

## 3.18.12 (2019-11-10)

- Added `-[NSObject observeNotification:selector:]`
- Added `-[NSArray groupedDictionaryUsingBlock:]`, `-[NSArray groupedDictionaryByKeyPath:]`

## 3.18.10 (2019-09-25)

- Added iPad 7 for `-[UIDevice modelName]`
- Improved `ESRandomData()`

## 3.18.9 (2019-09-24)

- Added Apple Watch Series 5 for `-[UIDevice modelName]`

## 3.18.8 (2019-09-20)

- Update `-[UIDevice modelName]` for iPhone 11, iPod touch 7. Unify `i386` and `x86_64` model name to "Simulator".

## 3.18.7 (2019-09-13)

- Refactor `ESMeasureExecution()` to `ESBenchmark()`

## 3.18.6 (2019-09-04)

- Fixed podspec: 'Security' framework should be linked in the Core subspec

## 3.18.5 (2019-09-02)

- Added AES Encryption methods to NSData and NSString extensions
- Improved `ESUniqueNumericIdentifier()` function.

## 3.18.4 (2019-08-30)

- Improved `ESUniqueNumericIdentifier()` function.

## 3.18.3 (2019-08-30)

- Improved `ESUniqueNumericIdentifier()` function.

## 3.18.2 (2019-08-21)

- Removed `ESDefineAssociatedObjectKey()`
- Removed semaphore lock macros `ESNewLock()`, `ESLock(lock)`, `ESUnlock(lock)`

## 3.18.1 (2019-08-20)

- Added semaphore lock macros `ESNewLock()`, `ESLock(lock)`, `ESUnlock(lock)`
- Added macro `ESAssertOnMainThread()`

## 3.18.0 (2019-08-20)

- Added helpers: `es_dispatch_is_queue()`, `es_dispatch_async()`, `es_dispatch_sync()`
- Removed `es_dispatch_async_main()`, use `es_dispatch_async(dispatch_get_main_queue(), block)` instead
- Removed `es_dispatch_sync_main()`, use `es_dispatch_sync(dispatch_get_main_queue(), block)` instead
- Removed unnecessary imports `<objc/runtime.h>`, `"ESMacros.h"` from ESHelpers.h

## 3.17.3 (2019-08-02)

- Remove comma for ESMaskSet, ESMaskUnset

## 3.17.2 (2019-08-02)

- Restore bits-mask helpers macros: `ESMaskIsSet`, `ESMaskSet`, `ESMaskUnset`

## 3.17.1 (2019-07-29)

- Added `ESUniqueNumericIdentifier()` helper

## 3.17.0 (2019-07-29)

- Moved `-[NSString UUIDString]` to `ESUUIDString()` helper
- Moved `-[NSString randomStringWithLength:]` to `ESRandomString()` helper
- Moved `-[NSData randomDataWithLength:]` to `ESRandomData()` helper
- Moved `-[UIColor randomColor]` to `ESRandomColor()` helper
- Make `ESIsPadUI()`, `ESIsPadDevice()`, `ESIsRetinaScreen()` etc public for tvOS

## 3.16.1 (2019-07-25)

- Replaced `makeObjectsPerformSelector:` with for-in fast loop

## 3.16.0 (2019-07-23)

- Added `-JSONObject`, `-JSONObjectWithOptions:` to `NSString`.

## 3.15.4 (2019-07-23)

- Check if it is a valid JSON object in `-JSONString`.
- Added `-JSONData`, `-JSONDataWithOptions:` to `NSArray`, `NSDictionary`.
- Added `-JSONObject`, `-JSONObjectWithOptions:` to `NSData`.

## 3.15.3 (2019-07-22)

- Added `-JSONString`, `-JSONStringWithOptions:` to `NSArray`, `NSDictionary` category.

## 3.15.2 (2019-07-17)

- Added UIAlertController methods: `+actionSheetWithTitle:`, `+alertWithTitle:`.

## 3.15.1 (2019-06-24)

- Rename NSDate `-dateFromHTTPDateString:` to `-dateWithHTTPDateString:`.
- Added `-[NSHTTPURLResponse date]`.

## 3.15.0 (2019-06-23)

- Support Carthage.
- Split `ESFrameworkUI` to [a separate git repo](https://github.com/ElfSundae/ESFrameworkUI).

## 3.14.2 (2019-06-22)

- Updated domain of [App Store Links](https://developer.apple.com/news/?id=06142019a) from `itunes.apple.com` to `apps.apple.com` for `ESAppLink()`, `ESAppStoreLink()`, `ESAppStoreReviewLink()`.
- Make `ESAppLink()`, `ESAppStoreLink()`, `ESAppStoreReviewLink()` available for all platforms.

## 3.14.0 (2019-06-19)

- Add support for multi platforms: macOS, tvOS, watchOS.

## 3.13.0 (2019-06-18)

- Remove `AFNetworkingExtension` dependency to fix "Cycle in dependencies" issue on the new Xcode build system.

## 3.12.0 (2019-06-18)

- Create pod subspecs: `Core`, `Foundation`, `Network`, `UIKit`.
- Move `#import <objc/runtime.h>`, `#import "ESMacros.h"` to `ESHelpers.h` for convenience.

## 3.10.0 (2019-06-17)

- Changed the default value of `-[UIApplication appChannel]` to `"AppStore"`, before is `"App Store"`.
- Replace whitespace to `"-"` for the default value of `-[UIApplication appName]`.
- Removed `"Network"` from `-[UIApplication userAgentForHTTPRequest]`.
- Renamed NSURLComponents `-queryItemsDictionary` to `-queryParameters`, `-addQueryItemsDictionary:` to `-addQueryParameters:`.
- Renamed NSURL `-queryDictionary` to `-queryParameters`, `-URLByAddingQueryDictionary:` to `-URLByAddingQueryParameters:`.
- Renamed NSString `-queryDictionary` to `-URLQueryParameters`, `-stringByAddingQueryDictionary:` to `-stringByAddingURLQueryParameters:`
- Sort URL query keys alphabetically.
- Removed `ESAppPreviousVersionUserDefaultsKey` defination.
- Added `ESStringFromNetworkReachabilityStatus(AFNetworkReachabilityStatus status)` function.

## 3.9.0 (2019-06-05)

- Removed param `retainArguments:(BOOL)` for `+[NSInvocation invocationWithTarget:selector: ,...]`.
- Changed: `ESInvokeSelector()` now retains arguments for NSInvocation object.

## 3.8.0 (2019-06-05)

- Added `NSMapTable (ESExtension)` category.

## 3.7.0 (2019-06-04)

- Renamed `-[UIApplication registerForRemoteNotificationsWithCompletion:]` to `-registerForRemoteNotificationsWithSuccess:failure:`.

## 3.6.0 (2019-05-30)

- Added UIAlertController methods: `-actionSheetWithTitle:cancelActionTitle:`, `-alertWithTitle:cancelActionTitle:`, `+showAlertWithTitle:cancelActionTitle:`.
- Added param `minorVersion` to `ESOSVersionIsAtLeast()`: `BOOL ESOSVersionIsAtLeast(NSInteger majorVersion, NSInteger minorVersion)`.
- Renamed `ESBenchmark()` to `ESMeasureExecution()`.
- Renamed `ESRandomColor()` to `+[UIColor randomColor]`.
- Renamed `ESRandomDataOfLength()` to `+[NSData randomDataWithLength:]`.
- Renamed `ESRandomStringOfLength()` to `+[NSString randomStringWithLength:]`.
- Renamed `ESUUIDString()` to `+[NSString UUIDString]`.
- Removed `ESIsStringWithAnyText()`, `ESIsArrayWithItems()`, `ESIsDictionaryWithItems()`, `ESIsSetWithItems()`, `ESIsOrderedSetWithItems()` [a3b80c](https://github.com/ElfSundae/ESFramework/commit/a3b80c33164a314a62cb09860bc1c144c13b0c9e)
- Removed `ESCreateNonretainedMutableSet()`, `ESCreateNonretainedMutableArray()`, `ESCreateNonretainedMutableDictionary()` [d237e3](https://github.com/ElfSundae/ESFramework/commit/d237e3267a130eefd2ae35c081b11687ff3b17e2)
- Removed named color methods: `+es_redNavigationBarColor`, `+es_primaryButtonColor`, `+es_twitterColor` etc, you may use [Chameleon](https://github.com/viccalexander/Chameleon) instead. [094cc70](https://github.com/ElfSundae/ESFramework/commit/094cc70ab39b9b272d333287a2ef72eecb08952a)
- Removed utilities methods from [BButton](https://github.com/jessesquires/BButton). [6dbb2db](https://github.com/ElfSundae/ESFramework/commit/6dbb2dbf4e10d5fcfda67b1e85c5ca95a6106f58)
- Removed `ESButton`, you may use [TORoundedButton](https://github.com/TimOliver/TORoundedButton) or [BButton](https://github.com/jessesquires/BButton) instead.
- Improved `+[NSString randomStringWithLength:]`.
- Renamed files from "ESAdditions" to "ESExtension".
- Add `module_name` for podspec files.

## 3.5.1 (2019-05-29)

- Improved generic support.
- Renamed NSArray `-reversedArray` to `-arrayByReversingObjects`.

## 3.5.0 (2019-05-29)

- Renamed UIView `-findSuperviewOf:` => `-findSuperviewOfClass:`, `-findSubviewOf:` => `-findSubviewOfClass:`.
- Swizzled NSString numeric methods like `-doubleValue`, `-boolValue`.
- Added missing numeric methods for NSString: `-charValue`, `-longValue`, etc.
- Added `ESCharValue(id)`, `ESUCharValue(id)`, `ESShortValue(id)`, `ESUShortValue(id)`.

## 3.4.1 (2019-05-28)

- Removed `es_dispatch_is_main_queue()`.

## 3.4.0 (2019-05-28)

- Renamed UIView `-snapshotViewAfterScreenUpdates` to `-snapshotImageAfterScreenUpdates`.
- Added UIView `-addTapGestureRecognizerWithBlock:`.

## 3.3.0 (2019-05-27)

- Added UIView `-moveSubviewToCenter:`.
- Renamed UIView `-moveToCenterOfSuperview` to `-moveToCenter`.
- Renamed UIView `-setLayerShadowWithColor:offset:radius:` to `-setLayerShadowWithColor:offset:radius:opacity:` (add `opacity` param).

## 3.2.0 (2019-05-25)

- Added `ESActionBlockContainer` class.
- Added action block methods for `UIBarButtonItem`, `UIGestureRecognizer`, `UIControl`.
- Removed bitmask helper macros:
    ```objc
    #define ESMaskIsSet(value, flag)    (((value) & (flag)) == (flag))
    #define ESMaskSet(value, flag)      ((value) |= (flag));
    #define ESMaskUnset(value, flag)    ((value) &= ~(flag));
    ```
- Removed `-[UIApplication isUIViewControllerBasedStatusBarAppearance]`.
- Renamed UIApplication `-appIconFile` to `-appIconFilename`.
- Cache value for `-appBundleIdentifier`, `-appVersion`, `-appBuildVersion`.

## 3.1.0 (2019-05-23)

- Fixed C++ compiler error

## 3.0.0 (2019-05-22)

- :warning: Updated iOS deployment target to 9.0.
- Split UI components to separate pod `ESFrameworkUI`.
- Replaced `ESFramework/Reachability` with `AFNetworking/Reachability`.
- Made the main queue dispatching functions safer.
- :warning: Moved ESApp+AppInfo methods to UIApplication category: `-appName`, `-appVersion`, `-appChannel`, `-isFreshLaunch`, `-appPreviousVersion`, `-analyticsInfo`, `-userAgentForHTTPRequest`, `-allURLSchemes`, `-URLSchemesForIdentifier:` etc.
- :warning: Removed automatically multitasking background task and related methods such as `-enableMultitasking`. If you want to do some background tasks, call `-beginBackgroundTask...` in `-applicationDidEnterBackground:`, or use the `NSURLSession` background networking transfer, see https://developer.apple.com/library/archive/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/BackgroundExecution/BackgroundExecution.html
- :warning: Moved ESApp+Helper methods to UIApplication category: `-appWindow`, `-rootViewController`, `-rootViewControllerForPresenting` => `-topmostViewController`, `-presentViewController:`, `-dismissViewControllersAnimated:`, `-dismissKeyboard`, `-simulateMemoryWarning`, `-canMakePhoneCalls`, `-makePhoneCall:` etc.
- `-[UIApplication analyticsInfo]` changes:
    + Added: `model_name`, `device_token`, `wwan`, `bssid`, `wwan_ip`, `wwan_ipv6`
    + Renamed keys: `platform` => `model_identifier`, `name` => `device_name`, `app_launch` => `app_uptime`
    + `timezone_gmt` returns "seconds from GMT" now, previously returns "hours from GMT"
- Added:
    + `BOOL es_dispatch_is_main_queue(void)`
    + `BOOL ESIsOrderedSetWithItems(id)`
    + `NSURL *ESDocumentDirectoryURL()`, `NSURL *ESDocumentURL(NSString *pathComponent)`, `ESLibraryDirectoryURL()`, `ESLibraryURL(NSString *)`, `ESCachesDirectoryURL()`, `ESCachesURL(NSString *)`, `ESTemporaryDirectoryURL()`, `ESTemporaryURL(NSString *)`
    + `ESAppLink(NSInteger appIdentifier)`, `ESAppStoreLink(NSInteger appIdentifier)`, `ESAppStoreReviewLink(NSInteger appIdentifier)`
    + `ESWeakProxy` class
    + `+[NSCharacterSet URLEncodingAllowedCharacterSet]`
    + `+[NSNumber numberWithString:]`
    + NSString methods: `-numberValue`, `-dataValue`
    + `NSURLComponents (ESAdditions)` category
    + NSURL methods: `-URLByAddingQueryDictionary:`
    + NSData methods: `+dataWithHexString:`, `-uppercaseHexString`, `-lowercaseHexString`
    + NSDate methods: `+dateFromHTTPDateString:`, `-isInWeekend`, `-isInWorkday`, `-isToday`, `-isYesterday`, `-isTomorrow`, `-isThisWeek`, `-isThisMonth`, `-isThisYear`, `-isInPast`, `-isInFuture`
    + NSDateFormatter additions: `+RFC1123DateFormatter`, `+RFC1036DateFormatter`, `+ANSIDateFormatter`
    + NSArray methods: `-objectOrNilAtIndex:`, `-reversedArray`, `-previousObjectToIndex:`, `-previousObjectToObject:`, `-nextObjectToIndex:`, `-nextObjectToObject:`
    + NSDictionary methods: `-entriesForKeys:`
    + NSMutableArray methods: `-removeFirstObject`, `-shiftFirstObject`, `-popLastObject`, `-reverseObjects`, `-shuffleObjects`
    + NSOrderedSet methods: `objectOrNilAtIndex:`
    + UIApplication methods: `-appWindow`, `-registerForRemoteNotificationsWithCompletion:`, `-appIconFile`, `-appIconImage`
    + UIDevice methods: `-modelName`, `-deviceToken`, `-deviceTokenString`
    + `ESNetworkHelper` class
    + `-[UIView snapshotViewAfterScreenUpdates:]`
    + UIScrollView methods: `-scrollToTop`, `-scrollToBottom`, `-scrollToLeft`, `-scrollToRight`
    + `-[UITableView performBatchUpdates:]`
    + UIWindow methods: `-topMostViewController`
- Renamed:
    + `ES_STOPWATCH_BEGIN` `ES_STOPWATCH_END` => `ESBenchmark()`
    + `ESDispatchOnMainThreadAsynchrony` => `es_dispatch_async_main`
    + `ESDispatchOnMainThreadSynchrony` => `es_dispatch_sync_main`
    + `ESDispatchOnGlobalQueue` => `es_dispatch_async_global_queue`
    + `ESDispatchOnHighQueue` => `es_dispatch_async_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, block)`
    + `ESDispatchOnDefaultQueue` => `es_dispatch_async_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, block)`
    + `ESDispatchOnLowQueue` => `es_dispatch_async_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, block)`
    + `ESDispatchOnBackgroundQueue` => `es_dispatch_async_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, block)`
    + `ESDispatchAfter` => `es_dispatch_after`
    + `ESPathForDocuments` => `ESDocumentDirectory`, `ESPathForDocumentsResource` => `ESDocumentPath`, `ESPathForLibrary` => `ESLibraryDirectory`, `ESPathForLibraryResource` => `ESLibraryPath`, `ESPathForCaches` => `ESCachesDirectory`, `ESPathForCachesResource` => `ESCachesPath`, `ESPathForTemporary` => `ESTemporaryDirectory`, `ESPathForTemporaryResource` => `ESTemporaryPath`
    + `UIScreenIsRetina()` => `ESIsRetinaScreen()`
    + `ESUUID()` => `ESUUIDString()`
    + NSObject methods: `+es_codableProperties` => `+codableProperties`, `-es_codableProperties` => `-codableProperties`, `-es_dictionaryRepresentation` => `-dictionaryRepresentation`
    + `-[NSString stringByAppendingQueryDictionary:]` => `-stringByAddingQueryDictionary:`
    + NSString methods: `-trim` => `trimmedString`, `-URLEncode` => `-URLEncodedString`, `-URLDecode` => `-URLDecodedString`
    + NSString, NSData methods: `-base64Encoded` => `-base64EncodedData`
    + NSData methods: `-stringValue` => `-UTF8String`, `-hexStringValue` => `-lowercaseHexString`
    + `-[NSString stringByEncodingHTMLEntitiesUsingTable:]` => `-stringByEscapingHTMLUsingTable:`
    + `-[NSString stringByEncodingHTMLEntitiesForUnicode]` => `-stringByEscapingHTML`
    + `-[NSString stringByEncodingHTMLEntitiesForASCII]` => `-stringByEscapingAsciiHTML`
    + `-[NSString stringByDecodingHTMLEntities]` => `-stringByUnescapingHTML`
    + NSMutableString methods: `replace:to:options:` => `replaceOccurrencesOfString:withString:options:`
    + NSArray methods: `matchObject:` => `objectPassingTest`, `matchesObjects` => `objectsPassingTest`
    + `-[NSDictionary queryString]` => `-URLQueryString`
    + `-[NSDictionary matchesDictionary:]` => `entriesPassingTest:`
    + `-[NSMutableDictionary es_setValue:forKeyPath:]` => `-setObject:forKeyPath:`
    + NSOrderedSet methods: `matchObject:` => `objectPassingTest`, `matchesObjects` => `objectsPassingTest`, `matchesOrderedSets` => `orderedSetPassingTest`
    + Add `es_` prefix for NSTimer methods: `-es_timerWithTimeInterval:`, `-es_scheduledTimerWithTimeInterval:`
    + NSUserDefaults methods: `+registeredDefaults` => `-registrationDictionary`, `+registerDefaults:` => `-setRegistrationDictionary:`, `+unregisterDefaultsForKeys:` => `-removeRegistrationObjectsForKeys:`, `+replaceRegisteredObject:forKey:` => `-setRegistrationObject:forKey:`
    + UIDevice class methods to instance methods: `+platform` => `-modelIdentifier`, `+carrierString` => `-carrierName`, `+currentWiFiSSID` => `-WiFiSSID`, `+isJailbroken` => `-isJailbroken`, `+diskTotalSize` => `-diskTotalSpace`, `+diskFreeSize` => `-diskFreeSpace`, `+screenSizeString:` => `ESScreenSizeString()`
    + UIColor methods: `-es_RGBAString` => `-RGBAString`, `-es_HexString` => `-RGBHexString`
    + UIView methods: `-findViewWithClassInSuperviews:` => `-findSuperviewOf:`, `-findViewWithClassInSubviews:` => `-findSubviewOf:`, `-setShadowOffset:` => `-setLayerShadowWithColor:`, `-setBackgroundGradientColor:` => `setGradientBackgroundColor:`
    + `-[UIToolbar replaceItemWithTag:withItem:]` => `-replaceItemWithTag:toItem:animated:`
    + `+[ESApp deleteHTTPCookiesForURL:]` => `-[NSHTTPCookieStorage deleteCookiesForURL:]`
    + `+[ESApp deleteAllHTTPCookies]` => `-[NSHTTPCookieStorage deleteAllCookies]`
- Removed:
    + :warning: `ESApp` class, use `UIApplication+ESAdditions` and the original `AppDelegate` directly
    + :warning: `ESStoreProductViewControllerManager` class, use `StoreProductViewController` directly
    + :warning: `ESMoviePlayerViewController` class, use `AVPlayerViewController` instead
    + Seconds constants: ES_MINUTE, ES_HOUR, ES_DAY, ES_5_DAYS, ES_WEEK, ES_MONTH, ES_YEAR
    + `ESStoreHelper` class
    + `UIProgressView+ESStyle` category
    + `ESLocalizedString()`, `_e()`, `ESLocalizedStringWithFormat()`
    + `ES_SINGLETON_DEC`, `ES_SINGLETON_IMP_AS`, `ES_SINGLETON_IMP`, `CFReleaseSafely`
    + `ESOSVersion`, `ESBundleWithName()`
    + `ESGetAssociatedObject()`, `ESSetAssociatedObject()`, `OBJC_ASSOCIATION_WEAK`, use `objc_getAssociatedObject`, `objc_setAssociatedObject` directly
    + `ESOSVersionIsAbove*()`, `ESStringFromSize()`, `NSStringWith()`, `UIImageFromCache()`, `UIImageFrom()`
    + `ESPathForBundleResource()`, `ESPathForMainBundleResource()`
    + `ESTouchDirectory()`, `ESTouchDirectoryAtFilePath`, `ESTouchDirectoryAtFileURL()`: use `-[NSFileManager createDirectoryAtPath:]` or `-[NSFileManager createDirectoryAtURL:]` instead before writing to the filesystem
    + `ESSharedNumberFormatter`, `NSNumberFromString(id)`, `ES...ValueWithDefault(id)`, `ES...Val(... *, id)`
    + `-[NSObject es_description]`
    + `NSObject (ESAssociatedObjectHelper)` category
    + `NSRegularExpression (ESAdditions)` category
    + `UIAlertView+ESBlock`, `UIActionSheet+ESBlock`
    + NSString methods: `-isEqualToStringCaseInsensitive`, `-match:`, `-match:caseInsensitive:`, `-isMatch:`, `-isMatch:caseInsensitive:`
    + NSString methods: `-trimWithCharactersInString:`, `-stringByReplacing:`, `-stringByReplacingCaseInsensitive:`, `-stringByReplacing:with:options:`, `-stringByReplacingInRange:with:`, `-stringByReplacingRegex:with:caseInsensitive`, `-splitWith:`, `-splitWithCharacterSet:`
    + NSMutableString methods: `replaceCaseInsensitive:to:`, `replaceInRange:to:`, `replaceRegex:to:caseInsensitive:`
    + `-[NSString writeToFile:::]`, `-[NSString writeToURL:::]`
    + NSString methods: `-URLSafeBase64String:`, `-base64StringFromURLSafeString:`
    + `es_` prefix for `NSString` and `NSData` hashing methods
    + `-[NSData writeToFile:atomically:completion]`
    + NSArray methods: `-each:` `-each:option:`, use `enumerateObjectsUsingBlock:` instead
    + NSArray methods: `-match:` `matches:`, use `indexOfObjectPassingTest:` instead
    + `-[NSArray writeToFile:atomically:completion]`
    + `-[NSMutableArray matchWith:]`
    + NSDictionary methods: `-esObjectForKey`, `-each:`, `-each:option:`, `match:`, `matchDictionary:`, `matches:`, `matches:option:`, `matchWith:`, `writeToFile:atomically:completion:`
    + `-[NSError isLocalNetworkError]`
    + NSOrderedSet methods: `-each:`, `-each:option:`, `-match:`, `matchWith:`
    + NSSet methods: `each`, `match`, `matches`, `matchWith`
    + `-isEmpty` on NSString, NSArray, NSDictionary, NSOrderedSet, NSSet
    + `+[NSDate timeIntervalSince1970]`
    + `-[NSURL isEqualToURL:]`
    + Quick methods for NSUserDefaults.standardUserDefaults, such as `+[NSUserDefaults objectForKey:]`, `+setObject:forKey:`, `+registerDefaults:`
    + UIAlertController methods: `-addTextFieldWithPlaceholder:configurationHandler:`, `-addSecureTextFieldWithPlaceholder:configurationHandler:`, property `defaultAction`
    + UIDevice methods: `+name`, `+systemName`, `+systemVersion`, `+model`, `+systemBuildIdentifier`, `+isPhoneDevice`, `+isPadDevice`, `+isRetinaScreen`, `+isIPhoneRetina35InchScreen`, `+isIPhoneRetina4InchScreen`, `+isIPhoneRetina47InchScreen`, `+isIPhoneRetina55InchScreen`, `+localTimeZone`, `+localTimeZoneFromGMT`, `+currentLocale`, `+currentLocaleLanguageCode`, `+currentLocaleCountryCode`, `+currentLocaleIdentifier`, `+getNetworkInterfacesIncludesLoopback:`, `+localIPv4Address`, `+localIPv6Address`
    + UIColor methods: `+es_iOS6GroupTableViewBackgroundColor`, `+es_viewBackgroundColor`
    + UIGestureRecognizer block methods: `-initWithHandler:`, `+recognizerWithHandler:`
    + UIControl block methods: `-addEventHandler:forControlEvents:`, `-removeEventHandlersForControlEvents:`, `-removeAllEventHandlersAndTargetsActions`, `existsEventHandlersForControlEvents:`
    + UIView methods: `-addTapGestureHandler:`, `-addLongPressGestureHandler:`, `-all...GestureRecognizers`, `-removeAll...GestureRecognizers`, `-setCornerRadius:borderWidth:borderColor:`
    + UITableView methods: `-scrollToFirstRow:`, `-scrollToLastRow:`
    + UIBarButtonItem block methods
    + `-[UIViewController currentVisibleViewController]`
    + `-[UITabBarController setBadgeValue:forTabBarItemAtIndex:]`
    + `+[NSDateFormatter appServerDateFormatterWith...Style]`
    + ESApp methods: `-appWebServerTimeZone`, `+defaultUserAgentOfWebView`, `-userAgentForWebView`, `+clearApplicationIconBadgeNumber`, `+loadPreferencesDefaultsFromSettingsPlistAtURL:`, `+registerPreferencesDefaultsWithDefaultValues:`, `+registerPreferencesDefaultsWithDefaultValuesForAppDefaultRootSettingsPlist:`
- Refactored:
    + `NSObject (ESAutoCoding)`
    + `-queryDictionary` of `NSURL`/`NSString` to use the `NSURLComponents` API

## 2.6.2

- Add `-[UIAlertController defaultAction]` to access the preferred alert action.
- Add `UIAlertController` creation methods that without any parameters.

## 2.6.1

- Add `UIAlertController` additions.

## 2.6.0

- Rename method `-[UIScrollView refreshControl]` to `es_refreshControl` [1907d6d](https://github.com/ElfSundae/ESFramework/commit/1907d6dfa707b61849a55ef4616bd119958538bc)
- Add `UNUserNotificationCenter` support for `-[ESApp registerForRemoteNotificationsWithTypes:...]`, make it compatible with iOS 10.
- Minor refactor ESApp private methods.
- Fix callback of failed registering remote notification. [6a3afb6](https://github.com/ElfSundae/ESFramework/commit/6a3afb664cf4c1e686f6bf981db7999ae658948f)
- Add function `ESOSVersionIsAbove10()`[c894ba8](https://github.com/ElfSundae/ESFramework/commit/c894ba87a0af29cde81373590b4918323f3bd1dd)
