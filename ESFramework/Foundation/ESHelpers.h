//
//  ESHelpers.h
//  ESFramework
//
//  Created by Elf Sundae on 2019/04/23.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Returns a boolean value indicating whether the version of the operating system
 * on which the process is executing is the same or later than the given version.
 */
FOUNDATION_EXTERN BOOL ESOSVersionIsAtLeast(NSInteger majorVersion);

/**
 * Creates an UIColor instance from RGB values.
 * RGB numbers are between 0 - 255.
 * @code
 * UIColorWithRGBA(123, 255, 200, 0.8);
 * @endcode
 */
FOUNDATION_EXTERN UIColor *UIColorWithRGBA(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha);

/**
 * Creates an UIColor instance from RGB values.
 * RGB numbers are between 0 - 255.
 * @code
 * UIColorWithRGB(123, 255, 200);
 * @endcode
 */
FOUNDATION_EXTERN UIColor *UIColorWithRGB(CGFloat red, CGFloat green, CGFloat blue);

/**
 * Creates an UIColor instance from a hexadecimal RGB number.
 * @code
 * UIColorWithHexRGB(0x7bffc8, 0.8);
 * @endcode
 */
FOUNDATION_EXTERN UIColor *UIColorWithRGBHex(NSUInteger hex, CGFloat alpha);

/**
 * Creates an UIColor instance from a hexadecimal RGB string.
 *
 * @code
 * UIColorWithHexRGBString(@"#33AF00", 1);
 * UIColorWithHexRGBString(@"0x33AF00", 0.3);
 * UIColorWithHexRGBString(@"33AF00", 0.9);
 * @endcode
 */
FOUNDATION_EXTERN UIColor *UIColorWithRGBHexString(NSString *hexString, CGFloat alpha);

/**
 * Profiles the execution time.
 */
FOUNDATION_EXTERN void ESBenchmark(NS_NOESCAPE void (^block)(void), NS_NOESCAPE void (^completion)(double elapsedMillisecond));

#pragma mark - Foundation

/**
 * Gets value from an NSNumber or NSString object safely.
 */

FOUNDATION_EXTERN int ESIntValue(id _Nullable obj);
FOUNDATION_EXTERN unsigned int ESUIntValue(id _Nullable obj);
FOUNDATION_EXTERN long ESLongValue(id _Nullable obj);
FOUNDATION_EXTERN unsigned long ESULongValue(id _Nullable obj);
FOUNDATION_EXTERN long long ESLongLongValue(id _Nullable obj);
FOUNDATION_EXTERN unsigned long long ESULongLongValue(id _Nullable obj);
FOUNDATION_EXTERN float ESFloatValue(id _Nullable obj);
FOUNDATION_EXTERN double ESDoubleValue(id _Nullable obj);
FOUNDATION_EXTERN BOOL ESBoolValue(id _Nullable obj);
FOUNDATION_EXTERN NSInteger ESIntegerValue(id _Nullable obj);
FOUNDATION_EXTERN NSUInteger ESUIntegerValue(id _Nullable obj);
FOUNDATION_EXTERN NSString * _Nullable ESStringValue(id _Nullable obj);

/**
 * Checks whether the given object is a non-empty string.
 */
FOUNDATION_EXTERN BOOL ESIsStringWithAnyText(id _Nullable object);

/**
 * Checks whether the given object is a non-empty array.
 */
FOUNDATION_EXTERN BOOL ESIsArrayWithItems(id _Nullable object);

/**
 * Checks whether the given object is a non-empty dictionary.
 */
FOUNDATION_EXTERN BOOL ESIsDictionaryWithItems(id _Nullable object);

/**
 * Checks whether the given object is a non-empty set.
 */
FOUNDATION_EXTERN BOOL ESIsSetWithItems(id _Nullable object);

/**
 * Checks whether the given object is a non-empty ordered set.
 */
FOUNDATION_EXTERN BOOL ESIsOrderedSetWithItems(id _Nullable object);

/**
 * Creates a mutable set which does not retain references to the objects it contains.
 */
FOUNDATION_EXTERN NSMutableSet *ESCreateNonretainedMutableSet(void);

/**
 * Creates a mutable array which does not retain references to the objects it contains.
 */
FOUNDATION_EXTERN NSMutableArray *ESCreateNonretainedMutableArray(void);

/**
 * Creates a mutable dictionary which does not retain references to the objects it contains.
 */
FOUNDATION_EXTERN NSMutableDictionary *ESCreateNonretainedMutableDictionary(void);

/**
 * Generates an UUID string, e.g. "E621E1F8-C36C-495A-93FC-0C247A3E6E5F".
 */
FOUNDATION_EXTERN NSString *ESUUIDString(void);

/**
 * Generates a random number between min and max.
 */
FOUNDATION_EXTERN uint32_t ESRandomNumber(uint32_t min, uint32_t max);

/**
 * Generates a random data using `SecRandomCopyBytes`.
 */
FOUNDATION_EXTERN NSData *ESRandomDataOfLength(NSUInteger length);

/**
 * Generates a random string that contains 0-9a-zA-Z.
 */
FOUNDATION_EXTERN NSString *ESRandomStringOfLength(NSUInteger length);

/**
 * Generates a random color.
 */
FOUNDATION_EXTERN UIColor *ESRandomColor(void);

/**
 * Converts degrees to radians.
 */
FOUNDATION_EXTERN CGFloat ESDegreesToRadians(CGFloat degrees);

/**
 * Converts radians to degrees.
 */
FOUNDATION_EXTERN CGFloat ESRadiansToDegrees(CGFloat radians);

#pragma mark - User Interface

/**
 * Returns the current statusBar's height, in any orientation.
 */
FOUNDATION_EXTERN CGFloat ESStatusBarHeight(void);

/**
 * Returns the current orientation of your application’s user interface.
 */
FOUNDATION_EXTERN UIInterfaceOrientation ESInterfaceOrientation(void);

/**
 * Returns the physical orientation of the device.
 * This will return UIDeviceOrientationUnknown unless device orientation notifications are being generated.
 */
FOUNDATION_EXTERN UIDeviceOrientation ESDeviceOrientation(void);

/**
 * Returns a recommended rotating transform for the given interface orientation.
 */
FOUNDATION_EXTERN CGAffineTransform ESRotateTransformForOrientation(UIInterfaceOrientation orientation);

/**
 * Checks whether the current user interface is iPad style.
 */
FOUNDATION_EXTERN BOOL ESIsPadUI(void);

/**
 * Checks whether the device is an iPad/iPad Mini/iPad Air.
 */
FOUNDATION_EXTERN BOOL ESIsPadDevice(void);

/**
 * Checks whether the current user interface is iPhone or iPod touch style.
 */
FOUNDATION_EXTERN BOOL ESIsPhoneUI(void);

/**
 * Checks whether the device is an iPhone or iPod touch.
 */
FOUNDATION_EXTERN BOOL ESIsPhoneDevice(void);

/**
 * Checks whether the device has retina screen.
 */
FOUNDATION_EXTERN BOOL ESIsRetinaScreen(void);

/**
 * Converts a screen size to a string.
 * e.g. "414x736", the width always be less than the height.
 */
FOUNDATION_EXTERN NSString *ESScreenSizeString(CGSize size);

#pragma mark - File System

/**
 * Returns the path of the Documents directory.
 */
FOUNDATION_EXTERN NSString *ESDocumentDirectory(void);

/**
 * Returns the path made by appending the path component to the Documents directory.
 */
FOUNDATION_EXTERN NSString *ESDocumentPath(NSString *pathComponent);

/**
 * Returns the URL of the Documents directory.
 */
FOUNDATION_EXTERN NSURL *ESDocumentDirectoryURL(void);

/**
 * Returns the URL made by appending the path component to the Documents directory.
 */
FOUNDATION_EXTERN NSURL *ESDocumentURL(NSString *pathComponent, BOOL isDirectory);

/**
 * Returns the path of the Library directory.
 */
FOUNDATION_EXTERN NSString *ESLibraryDirectory(void);

/**
 * Returns the path made by appending the path component to the Library directory.
 */
FOUNDATION_EXTERN NSString *ESLibraryPath(NSString *pathComponent);

/**
 * Returns the URL of the Library directory.
 */
FOUNDATION_EXTERN NSURL *ESLibraryDirectoryURL(void);

/**
 * Returns the URL made by appending the path component to the Library directory.
 */
FOUNDATION_EXTERN NSURL *ESLibraryURL(NSString *pathComponent, BOOL isDirectory);

/**
 * Returns the path of the Caches directory.
 */
FOUNDATION_EXTERN NSString *ESCachesDirectory(void);

/**
 * Returns the path made by appending the path component to the Caches directory.
 */
FOUNDATION_EXTERN NSString *ESCachesPath(NSString *pathComponent);

/**
 * Returns the URL of the Caches directory.
 */
FOUNDATION_EXTERN NSURL *ESCachesDirectoryURL(void);

/**
 * Returns the URL made by appending the path component to the Caches directory.
 */
FOUNDATION_EXTERN NSURL *ESCachesURL(NSString *pathComponent, BOOL isDirectory);

/**
 * Returns the path of the temporary directory.
 */
FOUNDATION_EXTERN NSString *ESTemporaryDirectory(void);

/**
 * Returns the path made by appending the path component to the temporary directory.
 */
FOUNDATION_EXTERN NSString *ESTemporaryPath(NSString *pathComponent);

/**
 * Returns the URL of the temporary directory.
 */
FOUNDATION_EXTERN NSURL *ESTemporaryDirectoryURL(void);

/**
 * Returns the URL made by appending the path component to the temporary directory.
 */
FOUNDATION_EXTERN NSURL *ESTemporaryURL(NSString *pathComponent, BOOL isDirectory);

#pragma mark - GCD

NS_INLINE BOOL es_dispatch_is_main_queue(void) {
    return 0 == strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue()));
}

NS_INLINE void es_dispatch_async_main(dispatch_block_t block) {
    if (es_dispatch_is_main_queue()) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

NS_INLINE void es_dispatch_sync_main(NS_NOESCAPE dispatch_block_t block) {
    if (es_dispatch_is_main_queue()) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

NS_INLINE void es_dispatch_async_global_queue(dispatch_queue_priority_t priority, dispatch_block_t block) {
    dispatch_async(dispatch_get_global_queue(priority, 0), block);
}

NS_INLINE void es_dispatch_after(NSTimeInterval delayInSeconds, dispatch_block_t block) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

#pragma mark - ObjC Runtime

/**
 * Swizzle instance methods.
 * @code
 * + (void)load {
 *      ESSwizzleInstanceMethod(self, @selector(method:), @selector(newMethod:));
 * }
 * @endcode
 */
FOUNDATION_EXTERN void ESSwizzleInstanceMethod(Class c, SEL orig, SEL new_sel);

/**
 * Swizzle class methods.
 * @code
 * + (void)load {
 *      ESSwizzleInstanceMethod(self, @selector(method:), @selector(newMethod:));
 * }
 * @endcode
 */
FOUNDATION_EXTERN void ESSwizzleClassMethod(Class c, SEL orig, SEL new_sel);

/**
 * Invokes the given selector on the given target.
 * @code
 * NSString *result = nil;
 * if (ESInvokeSelector(self, @selector(foo:), &result, @"arg")) {
 *     NSLog(@"%@", result);
 * }
 * @endcode
 * @return YES if invoked successfully, otherwise NO.
 */
FOUNDATION_EXTERN BOOL ESInvokeSelector(id target, SEL selector, void * _Nullable result, ...);

NS_ASSUME_NONNULL_END
