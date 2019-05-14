# Changelog

## Unreleased

- Updated iOS deployment target to 9.0.
- Replaced `ESFramework/Reachability` with `AFNetworking/Reachability`.
- Made the main queue dispatching functions safer.
- Moved ESApp+AppInfo methods to UIApplication category, such as `+appName`, `+appVersion`, `-analyticsInformation` etc.
- Changed keys for `-[UIApplication analyticsInfo]`: `platform` => `model_identifier`, `name` => `device_name`.
- Added:
    + `BOOL es_dispatch_is_main_queue(void)`
    + `BOOL ESIsOrderedSetWithItems(id)`
    + `NSURL *ESDocumentDirectoryURL()`, `NSURL *ESDocumentURL(NSString *pathComponent)`, `ESLibraryDirectoryURL()`, `ESLibraryURL(NSString *)`, `ESCachesDirectoryURL()`, `ESCachesURL(NSString *)`, `ESTemporaryDirectoryURL()`, `ESTemporaryURL(NSString *)`
    + `ESWeakProxy` class
    + `+[NSCharacterSet URLEncodingAllowedCharacterSet]`
    + `NSURLComponents (ESAdditions)` category
    + `-[NSURL URLByAddingQueryDictionary:]`
    + NSData methods: `-uppercaseHexString`, `lowercaseHexString`
    + `+[NSDate dateFromHTTPDateString:]`
    + `NSDateFormatter (ESAdditions)` category
    + NSArray methods: `-objectOrNilAtIndex:`, `-previousObjectToIndex:`, `-previousObjectToObject:`, `-nextObjectToIndex:`, `-nextObjectToObject:`
    + NSDictionary methods: `-entriesForKeys:`
    + NSMutableArray methods: `-removeFirstObject`, `-shiftFirstObject`, `-popLastObject`
    + NSOrderedSet methods: `objectOrNilAtIndex:`
    + `-[UIDevice modelName]`
    + `ESNetworkHelper` class
    + `-[UIView snapshotViewAfterScreenUpdates:]`
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
    + NSObject methods: `+es_codableProperties` => `+codableProperties`, `-es_codableProperties` => `-codableProperties`, `-es_dictionaryRepresentation` => `-dictionaryRepresentation`
    + `ESSharedNumberFormatter` => `+[NSNumberFormatter defaultFormatter]`
    + `-[NSString stringByAppendingQueryDictionary:]` => `-stringByAddingQueryDictionary:`
    + NSString methods: `-URLEncode` => `-URLEncoded`, `-URLDecode` => `-URLDecoded`
    + NSString, NSData methods: `-base64Encoded` => `-base64EncodedData`
    + NSData methods: `-stringValue` => `-UTF8String`, `-hexStringValue` => `-lowercaseHexString`
    + `-[NSString stringByEncodingHTMLEntitiesUsingTable:]` => `-stringByEscapingHTMLUsingTable:`
    + `-[NSString stringByEncodingHTMLEntitiesForASCII]` => `-stringByEncodingAsciiHTMLEntities:`
    + `-[NSString stringByEncodingHTMLEntitiesForUnicode]` => `-stringByEncodingHTMLEntities`
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
    + `ESLocalizedString()`, `_e()`, `ESLocalizedStringWithFormat()`
    + `ES_SINGLETON_DEC`, `ES_SINGLETON_IMP_AS`, `ES_SINGLETON_IMP`, `CFReleaseSafely`
    + `ESOSVersion`, `ESBundleWithName()`
    + `ESUUID()`: use `NSUUID.UUID.UUIDString` instead
    + `ESGetAssociatedObject()`, `ESSetAssociatedObject()`, `OBJC_ASSOCIATION_WEAK`, use `objc_getAssociatedObject`, `objc_setAssociatedObject` directly
    + `ESOSVersionIsAbove*()`, `ESStringFromSize()`, `NSStringWith()`, `UIImageFromCache()`, `UIImageFrom()`
    + `ESPathForBundleResource()`, `ESPathForMainBundleResource()`
    + `ESTouchDirectory()`, `ESTouchDirectoryAtFilePath`, `ESTouchDirectoryAtFileURL()`: use `-[NSFileManager createDirectoryAtPath:]` or `-[NSFileManager createDirectoryAtURL:]` instead before writing to the filesystem
    + `NSNumberFromString()`
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
    + UIBarButtonItem block methods
    + `-[UIViewController currentVisibleViewController]`
    + `-[UITabBarController setBadgeValue:forTabBarItemAtIndex:]`
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
