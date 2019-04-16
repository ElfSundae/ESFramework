# Changelog

## Unreleased

- Updated iOS deployment target to 9.0.
- Replaced `ESFramework/Reachability` with `AFNetworking/Reachability`.
- Made the main queue dispatching functions safer.
- Renamed GCD dispatch functions:
    + `ESDispatchOnMainThreadAsynchrony` => `es_dispatch_async_main`
    + `ESDispatchOnMainThreadSynchrony` => `es_dispatch_sync_main`
    + `ESDispatchOnGlobalQueue` => `es_dispatch_async_global_queue`
    + `ESDispatchOnHighQueue` => `es_dispatch_async_high`
    + `ESDispatchOnDefaultQueue` => `es_dispatch_async_default`
    + `ESDispatchOnLowQueue` => `es_dispatch_async_low`
    + `ESDispatchOnBackgroundQueue` => `es_dispatch_async_background`
    + `ESDispatchAfter` => `es_dispatch_after`
- Removed `-[NSString queryDictionary]`.
- Removed `ESOSVersionIsAbove*()`, `ESStringFromSize()`, `NSStringWith()`, `UIImageFromCache()`, `UIImageFrom()` functions.
- Removed `UIAlertView+ESBlock`, `UIActionSheet+ESBlock`.
- Renamed `ESTouchDirectoryAtURL()` to `ESTouchDirectoryAtFileURL()`.
- Renamed `-[NSString stringByAppendingQueryDictionary]` to `-stringByAppendingQueryComponents`.
- Added `+[NSCharacterSet URLEncodingAllowedCharacterSet]`.
- Added `NSURLComponents (ESAdditions)` category.
- Refactored `NSObject (ESAutoCoding)`.
- Refactored `-[NSURL queryDictionary]` to use the `NSURLComponents` API.

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
