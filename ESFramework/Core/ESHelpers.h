//
//  ESHelpers.h
//  ESFramework
//
//  Created by Elf Sundae on 2019/04/23.
//  Copyright © 2019 https://0x123.com. All rights reserved.
//

#import <TargetConditionals.h>
#if TARGET_OS_IOS || TARGET_OS_TV
#import <UIKit/UIKit.h>
#endif
#import <CoreGraphics/CoreGraphics.h>
#import <objc/runtime.h>
#import "ESMacros.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Extract Numeric Values

/**
 * Gets value from an NSNumber or NSString object safely.
 */

FOUNDATION_EXPORT char ESCharValue(id _Nullable obj);
FOUNDATION_EXPORT unsigned char ESUCharValue(id _Nullable obj);
FOUNDATION_EXPORT short ESShortValue(id _Nullable obj);
FOUNDATION_EXPORT unsigned short ESUShortValue(id _Nullable obj);
FOUNDATION_EXPORT int ESIntValue(id _Nullable obj);
FOUNDATION_EXPORT unsigned int ESUIntValue(id _Nullable obj);
FOUNDATION_EXPORT long ESLongValue(id _Nullable obj);
FOUNDATION_EXPORT unsigned long ESULongValue(id _Nullable obj);
FOUNDATION_EXPORT long long ESLongLongValue(id _Nullable obj);
FOUNDATION_EXPORT unsigned long long ESULongLongValue(id _Nullable obj);
FOUNDATION_EXPORT float ESFloatValue(id _Nullable obj);
FOUNDATION_EXPORT double ESDoubleValue(id _Nullable obj);
FOUNDATION_EXPORT BOOL ESBoolValue(id _Nullable obj);
FOUNDATION_EXPORT NSInteger ESIntegerValue(id _Nullable obj);
FOUNDATION_EXPORT NSUInteger ESUIntegerValue(id _Nullable obj);
/// Attempts convert a NSString/NSNumber object to a NSString object.
FOUNDATION_EXPORT NSString * _Nullable ESStringValue(id _Nullable obj);

#pragma mark - Utilities

/**
 * Returns a boolean value indicating whether the version of the operating system
 * on which the process is executing is the same or later than the given version.
 */
FOUNDATION_EXPORT BOOL ESOSVersionIsAtLeast(NSInteger majorVersion, NSInteger minorVersion);

/**
 * Measures the execution time.
 */
FOUNDATION_EXPORT void ESMeasureExecution(NS_NOESCAPE void (^block)(void), NS_NOESCAPE void (^ _Nullable completion)(NSTimeInterval elapsedMillisecond));

/**
 * Generates a random number between min and max.
 */
FOUNDATION_EXPORT uint32_t ESRandomNumber(uint32_t min, uint32_t max);

/**
 * Generates a new UUID string conforms to RFC 4122 version 4,
 * e.g. "E621E1F8-C36C-495A-93FC-0C247A3E6E5F".
 */
FOUNDATION_EXPORT NSString *ESUUIDString(void);

/**
 * Generates a time based unique numeric identifier.
 * e.g. "586063599884852".
 */
FOUNDATION_EXPORT NSString *ESUniqueNumericIdentifier(void);

/**
 * Generates a random alphanumeric string that contains a-zA-Z0-9.
 */
FOUNDATION_EXPORT NSString * _Nullable ESRandomString(NSUInteger length);

/**
 * Generates a random data using `SecRandomCopyBytes`.
 */
FOUNDATION_EXPORT NSData * _Nullable ESRandomData(NSUInteger length);

/**
 * Converts degrees to radians.
 */
FOUNDATION_EXPORT CGFloat ESDegreesToRadians(CGFloat degrees);

/**
 * Converts radians to degrees.
 */
FOUNDATION_EXPORT CGFloat ESRadiansToDegrees(CGFloat radians);

#pragma mark - App Store Links

/**
 * e.g. "https://apps.apple.com/app/id12345678"
 */
FOUNDATION_EXPORT NSURL *ESAppLink(NSInteger appIdentifier);

/**
 * e.g. "itms-apps://apps.apple.com/app/id12345678"
 */
FOUNDATION_EXPORT NSURL *ESAppStoreLink(NSInteger appIdentifier);

/**
 * e.g. "itms-apps://apps.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=12345678"
 */
FOUNDATION_EXPORT NSURL *ESAppStoreReviewLink(NSInteger appIdentifier);

#pragma mark - File Paths

/**
 * Returns the path of the Documents directory.
 */
FOUNDATION_EXPORT NSString *ESDocumentDirectory(void);

/**
 * Returns the path made by appending the path component to the Documents directory.
 */
FOUNDATION_EXPORT NSString *ESDocumentPath(NSString *pathComponent);

/**
 * Returns the URL of the Documents directory.
 */
FOUNDATION_EXPORT NSURL *ESDocumentDirectoryURL(void);

/**
 * Returns the URL made by appending the path component to the Documents directory.
 */
FOUNDATION_EXPORT NSURL *ESDocumentURL(NSString *pathComponent, BOOL isDirectory);

/**
 * Returns the path of the Library directory.
 */
FOUNDATION_EXPORT NSString *ESLibraryDirectory(void);

/**
 * Returns the path made by appending the path component to the Library directory.
 */
FOUNDATION_EXPORT NSString *ESLibraryPath(NSString *pathComponent);

/**
 * Returns the URL of the Library directory.
 */
FOUNDATION_EXPORT NSURL *ESLibraryDirectoryURL(void);

/**
 * Returns the URL made by appending the path component to the Library directory.
 */
FOUNDATION_EXPORT NSURL *ESLibraryURL(NSString *pathComponent, BOOL isDirectory);

/**
 * Returns the path of the Caches directory.
 */
FOUNDATION_EXPORT NSString *ESCachesDirectory(void);

/**
 * Returns the path made by appending the path component to the Caches directory.
 */
FOUNDATION_EXPORT NSString *ESCachesPath(NSString *pathComponent);

/**
 * Returns the URL of the Caches directory.
 */
FOUNDATION_EXPORT NSURL *ESCachesDirectoryURL(void);

/**
 * Returns the URL made by appending the path component to the Caches directory.
 */
FOUNDATION_EXPORT NSURL *ESCachesURL(NSString *pathComponent, BOOL isDirectory);

/**
 * Returns the path of the temporary directory.
 */
FOUNDATION_EXPORT NSString *ESTemporaryDirectory(void);

/**
 * Returns the path made by appending the path component to the temporary directory.
 */
FOUNDATION_EXPORT NSString *ESTemporaryPath(NSString *pathComponent);

/**
 * Returns the URL of the temporary directory.
 */
FOUNDATION_EXPORT NSURL *ESTemporaryDirectoryURL(void);

/**
 * Returns the URL made by appending the path component to the temporary directory.
 */
FOUNDATION_EXPORT NSURL *ESTemporaryURL(NSString *pathComponent, BOOL isDirectory);

#pragma mark - GCD Helpers

/**
 * Safely submits a block to the main dispatch queue for asynchronous execution
 * and returns immediately.
 */
NS_INLINE void es_dispatch_async_main(dispatch_block_t block)
{
    if (0 == strcmp(dispatch_queue_get_label(dispatch_get_main_queue()), dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL))) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

/**
 * Safely submits a block to the main dispatch queue for synchronous execution
 * and waits until that block completes.
 */
NS_INLINE void es_dispatch_sync_main(DISPATCH_NOESCAPE dispatch_block_t block)
{
    if (0 == strcmp(dispatch_queue_get_label(dispatch_get_main_queue()), dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL))) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

/**
 * Submits a block for asynchronous execution on a system-defined global
 * concurrent queue with the specified quality of service.
 */
NS_INLINE void es_dispatch_async_global_queue(dispatch_queue_priority_t priority, dispatch_block_t block)
{
    dispatch_async(dispatch_get_global_queue(priority, 0), block);
}

/**
 * Enqueue a block for execution on the main dispatch queue after the specified seconds.
 */
NS_INLINE void es_dispatch_after(NSTimeInterval delayInSeconds, dispatch_block_t block)
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

#pragma mark - ObjC Runtime

/**
 * Swizzle instance methods.
 * @code
 * + (void)load
 * {
 *     static dispatch_once_t onceToken;
 *     dispatch_once(&onceToken, ^{
 *         ESSwizzleInstanceMethod(self, @selector(method:), @selector(newMethod:));
 *     });
 * }
 * @endcode
 */
FOUNDATION_EXPORT void ESSwizzleInstanceMethod(Class cls, SEL originalSelector, SEL swizzledSelector);

/**
 * Swizzle class methods.
 * @code
 * + (void)load
 * {
 *     static dispatch_once_t onceToken;
 *     dispatch_once(&onceToken, ^{
 *         ESSwizzleInstanceMethod(self, @selector(method:), @selector(newMethod:));
 *     });
 * }
 * @endcode
 */
FOUNDATION_EXPORT void ESSwizzleClassMethod(Class cls, SEL originalSelector, SEL swizzledSelector);

/**
 * Invokes the given selector on the given target.
 * @code
 * void *result = NULL;
 * if (ESInvokeSelector(self, @selector(foo:), &result, arg1, arg2)) {
 *     NSLog(@"%@", (__bridge NSString *)result);
 * }
 * @endcode
 * @return YES if invoked successfully, otherwise NO.
 */
FOUNDATION_EXPORT BOOL ESInvokeSelector(id target, SEL selector, void * _Nullable result, ...);

#pragma mark - UI Helpers

#if TARGET_OS_IOS || TARGET_OS_TV

/**
 * Generates a random color.
 */
FOUNDATION_EXPORT UIColor *ESRandomColor(void);

/**
 * Creates an UIColor object from RGB values.
 * RGB numbers are between 0 - 255.
 * @code
 * UIColorWithRGBA(123, 255, 200, 0.8);
 * @endcode
 */
FOUNDATION_EXPORT UIColor *UIColorWithRGBA(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha);

/**
 * Creates an UIColor object from RGB values.
 * RGB numbers are between 0 - 255.
 * @code
 * UIColorWithRGB(123, 255, 200);
 * @endcode
 */
FOUNDATION_EXPORT UIColor *UIColorWithRGB(CGFloat red, CGFloat green, CGFloat blue);

/**
 * Creates an UIColor object from a hexadecimal RGB number.
 * @code
 * UIColorWithHexRGB(0x7bffc8, 0.8);
 * @endcode
 */
FOUNDATION_EXPORT UIColor *UIColorWithRGBHex(NSUInteger hex, CGFloat alpha);

/**
 * Creates an UIColor object from a hexadecimal RGB string.
 *
 * @code
 * UIColorWithHexRGBString(@"#33AF00", 1);
 * UIColorWithHexRGBString(@"0x33AF00", 0.3);
 * UIColorWithHexRGBString(@"33AF00", 0.9);
 * @endcode
 */
FOUNDATION_EXPORT UIColor *UIColorWithRGBHexString(NSString *hexString, CGFloat alpha);

/**
 * Converts a screen size to a string, e.g. "414x736".
 * On iOS the width always be less than the height.
 */
FOUNDATION_EXPORT NSString *ESScreenSizeString(CGSize size);

/**
 * Checks whether the current user interface is iPad style.
 */
FOUNDATION_EXPORT BOOL ESIsPadUI(void);

/**
 * Checks whether the device is an iPad/iPad Mini/iPad Air.
 */
FOUNDATION_EXPORT BOOL ESIsPadDevice(void);

/**
 * Checks whether the current user interface is iPhone or iPod touch style.
 */
FOUNDATION_EXPORT BOOL ESIsPhoneUI(void);

/**
 * Checks whether the device is an iPhone or iPod touch.
 */
FOUNDATION_EXPORT BOOL ESIsPhoneDevice(void);

/**
 * Checks whether the device has retina screen.
 */
FOUNDATION_EXPORT BOOL ESIsRetinaScreen(void);

#endif // TARGET_OS_IOS || TARGET_OS_TV

#if TARGET_OS_IOS

/**
 * Returns the height of the status bar, in any orientation.
 */
FOUNDATION_EXPORT CGFloat ESStatusBarHeight(void) NS_EXTENSION_UNAVAILABLE_IOS("Use view controller based solutions where appropriate instead.");

/**
 * Returns the current interface orientation of the application.
 */
FOUNDATION_EXPORT UIInterfaceOrientation ESInterfaceOrientation(void) NS_EXTENSION_UNAVAILABLE_IOS("Use view controller based solutions where appropriate instead.");

/**
 * Returns the physical orientation of the device.
 * @discussion This will return UIDeviceOrientationUnknown unless device orientation notifications are being generated.
 */
FOUNDATION_EXPORT UIDeviceOrientation ESDeviceOrientation(void);

/**
 * Returns a recommended rotating transform for the given interface orientation.
 */
FOUNDATION_EXPORT CGAffineTransform ESRotateTransformForOrientation(UIInterfaceOrientation orientation);

#endif // TARGET_OS_IOS

NS_ASSUME_NONNULL_END
