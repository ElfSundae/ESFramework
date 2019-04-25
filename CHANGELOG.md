# Changelog

## Unreleased

- Updated iOS deployment target to 9.0.
- Replaced `ESFramework/Reachability` with `AFNetworking/Reachability`.
- Made the main queue dispatching functions safer.
- Added:
    + `ESWeakProxy`
    + `es_dispatch_is_main_queue()`
    + `+[NSCharacterSet URLEncodingAllowedCharacterSet]`
    + `NSURLComponents (ESAdditions)` category
    + `-[NSURL URLByAddingQueryDictionary:]`
    + `+[NSDate dateFromHTTPDateString:]`
    + `NSDateFormatter (ESAdditions)` category
    + `-[NSUserDefaults setObject:forKeyPath:]`
    + `-[UIDevice carrierNames]`
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
    + `ESTouchDirectoryAtURL()` => `ESTouchDirectoryAtFileURL()`
    + NSObject methods: `+es_codableProperties` => `+codableProperties`, `-es_codableProperties` => `-codableProperties`, `-es_dictionaryRepresentation` => `-dictionaryRepresentation`
    + `ESSharedNumberFormatter` => `+[NSNumberFormatter defaultFormatter]`
    + `-[NSString stringByAppendingQueryDictionary:]` => `-stringByAddingQueryDictionary:`
    + NSString methods: `-URLEncode` => `-URLEncoded`, `-URLDecode` => `-URLDecoded`
    + NSString, NSData methods: `-base64Encoded` => `-base64EncodedData`
    + `-[NSString stringByEncodingHTMLEntitiesUsingTable:]` => `-es_gtm_stringByEscapingHTMLUsingTable:`
    + `-[NSString stringByEncodingHTMLEntitiesForASCII]` => `-es_gtm_stringByEscapingForAsciiHTML`
    + `-[NSString stringByEncodingHTMLEntitiesForUnicode]` => `-stringByEncodingHTMLEntities`
    + NSMutableString methods: `replace:to:options:` => `replaceOccurrencesOfString:withString:options:`
    + NSArray methods: `matchObject:` => `objectPassingTest`, `matchesObjects` => `objectsPassingTest`
    + `-[NSDictionary queryString]` => `-URLQueryString`
    + `-[NSDictionary matchesDictionary:]` => `entriesPassingTest:`
    + `-[NSMutableDictionary es_setValue:forKeyPath:]` => `-setObject:forKeyPath:`
    + NSOrderedSet methods: `matchObject:` => `objectPassingTest`, `matchesObjects` => `objectsPassingTest`, `matchesOrderedSets` => `orderedSetPassingTest`
    + Add `es_` prefix for NSTimer methods: `-es_timerWithTimeInterval:`, `-es_scheduledTimerWithTimeInterval:`
    + NSUserDefaults methods: `+registeredDefaults` => `-registeredDefaults`, `+registerDefaults:` => `-setRegisteredDefaults:`, `+unregisterDefaultsForKeys:` => `-removeRegisteredObjectsForKeys:`, `+replaceRegisteredObject:forKey:` => `-setRegisteredObject:forKey:`
    + UIDevice class methods to instance methods: `+platform` => `-platform`, `+carrierString` => `-carrierName`, `+currentWiFiSSID` => `-WiFiSSID`
- Removed:
    + `ESLocalizedString()`, `_e()`, `ESLocalizedStringWithFormat()`
    + `ES_SINGLETON_DEC`, `ES_SINGLETON_IMP_AS`, `ES_SINGLETON_IMP`, `CFReleaseSafely`
    + `ESOSVersion`
    + `ESGetAssociatedObject()`, `ESSetAssociatedObject()`, `OBJC_ASSOCIATION_WEAK`, use `objc_getAssociatedObject`, `objc_setAssociatedObject` directly
    + `ESOSVersionIsAbove*()`, `ESStringFromSize()`, `NSStringWith()`, `UIImageFromCache()`, `UIImageFrom()`
    + `NSNumberFromString()`
    + `NSObject (ESAssociatedObjectHelper)` category
    + `NSRegularExpression (ESAdditions)` category
    + `UIAlertView+ESBlock`, `UIActionSheet+ESBlock`
    + NSString methods: `-match:`, `-match:caseInsensitive:`, `-isMatch:`, `-isMatch:caseInsensitive:`
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
    + NSOrderedSet methods: `-each:`, `-each:option:`, `-match:`, `matchWith:`
    + NSSet methods: `each`, `match`, `matches`, `matchWith`
    + `-isEmpty` on NSString, NSArray, NSDictionary, NSOrderedSet, NSSet
    + `+[NSDate timeIntervalSince1970]`
    + Quick methods for NSUserDefaults.standardUserDefaults, such as `+[NSUserDefaults objectForKey:]`, `+setObject:forKey:`, `+registerDefaults:`
    + UIAlertController methods: `-addTextFieldWithPlaceholder:configurationHandler:`, `-addSecureTextFieldWithPlaceholder:configurationHandler:`, property `defaultAction`
    + UIDevice methods: `+name`, `+systemName`, `+systemVersion`, `+model`, `+systemBuildIdentifier`,
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
