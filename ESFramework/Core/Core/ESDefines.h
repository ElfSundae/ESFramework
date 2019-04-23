//
//  ESDefines.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-2.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#ifndef ESFrameworkCore_ESDefines_H
#define ESFrameworkCore_ESDefines_H

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#import <Availability.h>
#import <objc/runtime.h>
#import <mach/mach_time.h>

/// =============================================
/// @name Log
/// =============================================
#pragma mark - Log

#if (!defined(NSLog))
#if DEBUG
#define NSLog(fmt, ...) NSLog((@"%@:%d %s " fmt), [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__)
#else
#define NSLog(fmt, ...)
#endif
#endif


#if (!defined(NSLogIf))
#if DEBUG
#define NSLogIf(condition, fmt, ...) if ((condition)) { NSLog(fmt, ##__VA_ARGS__); }
#else
#define NSLogIf(condition, fmt, ...)
#endif
#endif

/**
 * Log the execution time.
 */

#if DEBUG
#define ES_STOPWATCH_BEGIN(stopwatch_begin_var) uint64_t stopwatch_begin_var = mach_absolute_time();
#define ES_STOPWATCH_END(stopwatch_begin_var) { \
        uint64_t end = mach_absolute_time(); \
        mach_timebase_info_data_t timebaseInfo; \
        (void)mach_timebase_info(&timebaseInfo); \
        uint64_t elapsedNano = (end - stopwatch_begin_var) * timebaseInfo.numer / timebaseInfo.denom; \
        double_t elapsedMillisecond = (double_t)elapsedNano / 1000000.0; \
        printf("‼️STOPWATCH‼️ [%s:%d] %s %fms\n", [NSString stringWithUTF8String:__FILE__].lastPathComponent.UTF8String, __LINE__, __PRETTY_FUNCTION__, elapsedMillisecond); \
}
#else
#define ES_STOPWATCH_BEGIN(stopwatch_begin_var)
#define ES_STOPWATCH_END(stopwatch_begin_var)
#endif

/// =============================================
/// @name Constants
/// =============================================
#pragma mark - Constants

#define ES_MINUTE   (60)
#define ES_HOUR     (3600)
#define ES_DAY      (86400)
#define ES_5_DAYS   (432000)
#define ES_WEEK     (604800)
#define ES_MONTH    (2635200) /* 30.5 days */
#define ES_YEAR     (31536000) /* 365 days */

/// =============================================
/// @name Helper Macros
/// =============================================
#pragma mark - Helper Macros

/**
 * Make weak references to break "retain cycles".
 */
#define ESWeak_(var, weakVar)                   __weak __typeof(&*var) weakVar = var;
#define ESWeak(var)                             ESWeak_(var, weak_##var);
#define ESWeakSelf                              ESWeak(self);

#define ESStrong_DoNotCheckNil(weakVar, var)    __typeof(&*weakVar) var = weakVar;
#define ESStrong_(weakVar, var)                 ESStrong_DoNotCheckNil(weakVar, var); if (!var) return;
#define ESStrong(var)                           ESStrong_(weak_##var, _##var);
#define ESStrongSelf                            ESStrong(self);

/**
 * Declare singleton `+sharedInstance` method.
 */
#define ES_SINGLETON_DEC(sharedInstance)        + (instancetype)sharedInstance;

/**
 * Implement singleton `+sharedInstance` method.
 *
 * @warning If you are subclassing a signleton class, make sure overwrite the `+sharedInstance` method to
 * provide a different local variable name.
 */
#define ES_SINGLETON_IMP_AS(sharedInstance, sharedInstanceVariableName) \
    + (instancetype)sharedInstance \
    { \
        static id sharedInstanceVariableName = nil; \
        static dispatch_once_t onceToken_##sharedInstanceVariableName; \
        dispatch_once(&onceToken_##sharedInstanceVariableName, ^{ sharedInstanceVariableName = [[[self class] alloc] init]; }); \
        return sharedInstanceVariableName; \
    }
#define ES_SINGLETON_IMP(sharedInstance)        ES_SINGLETON_IMP_AS(sharedInstance, __gSharedInstance)

/**
 * Safely release CF instance.
 */
#define CFReleaseSafely(var)            if (var) { CFRelease(var); var = NULL; }

/**
 * Bits-mask helper.
 */
#define ESMaskIsSet(value, flag)        (((value) & (flag)) == (flag))
#define ESMaskSet(value, flag)          ((value) |= (flag));
#define ESMaskUnset(value, flag)        ((value) &= ~(flag));

/// =============================================
/// @name Helper Functions
/// =============================================
#pragma mark - Helper Functions

/**
 * The current version of the operating system.
 */
FOUNDATION_EXTERN NSString *ESOSVersion(void);

/**
 * Returns a Boolean value indicating whether the version of the operating system
 * on which the process is executing is the same or later than the given version.
 */
FOUNDATION_EXTERN BOOL ESOSVersionIsAtLeast(NSInteger majorVersion);

/**
 * Creates UIColor from RGB values.
 *
 * e.g. `UIColorWithRGBA(123, 255, 200, 0.8);`
 */
FOUNDATION_EXTERN UIColor *UIColorWithRGBA(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha);

/**
 * Creates UIColor from RGB values.
 *
 * e.g. `UIColorWithRGB(123, 255, 200);`
 */
FOUNDATION_EXTERN UIColor *UIColorWithRGB(CGFloat red, CGFloat green, CGFloat blue);

/**
 * Creates UIColor from RGB Hex number.
 *
 * e.g. `UIColorWithRGBAHex(0x7bffc8, 0.8);`
 */
FOUNDATION_EXTERN UIColor *UIColorWithRGBAHex(NSInteger rgbValue, CGFloat alpha);

/**
 * Creates UIColor from RGB Hex number.
 *
 * e.g. `UIColorWithRGBHex(0x7bffc8);`
 */
FOUNDATION_EXTERN UIColor *UIColorWithRGBHex(NSInteger rgbValue);

/**
 * Creates UIColor from the last six characters on which a hex string.
 *
 * e.g.
 * @code
 * UIColorWithRGBHexString(@"#33AF00", 1);
 * UIColorWithRGBHexString(@"0x33AF00", 0.3);
 * UIColorWithRGBHexString(@"33AF00", 0.9);
 * @endcode
 */
FOUNDATION_EXTERN UIColor *UIColorWithRGBAHexString(NSString *hexString, CGFloat alpha);

/**
 * Checks whether the given object is a non-empty string.
 */
FOUNDATION_EXTERN BOOL ESIsStringWithAnyText(id object);

/**
 * Checks whether the given object is a non-empty array.
 */
FOUNDATION_EXTERN BOOL ESIsArrayWithItems(id object);

/**
 * Checks whether the given object is a non-empty dictionary.
 */
FOUNDATION_EXTERN BOOL ESIsDictionaryWithItems(id object);

/**
 * Checks whether the given object is a non-empty set.
 */
FOUNDATION_EXTERN BOOL ESIsSetWithItems(id object);

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
 * Generates an UUID string, 36bits, e.g. @"B743154C-087E-4E7C-84AC-2573AAB940AD"
 */
FOUNDATION_EXTERN NSString *ESUUID(void);

/**
 * Returns the current statusBar's height, in any orientation.
 */
FOUNDATION_EXTERN CGFloat ESStatusBarHeight(void);

/**
 * Returns the application's current interface orientation.
 */
FOUNDATION_EXTERN UIInterfaceOrientation ESInterfaceOrientation(void);

/**
 * Returns the current device orientation.
 * This will return UIDeviceOrientationUnknown unless device orientation notifications are being generated.
 */
FOUNDATION_EXTERN UIDeviceOrientation ESDeviceOrientation(void);

/**
 * Returns a recommended rotating transform for the given interface orientation.
 */
FOUNDATION_EXTERN CGAffineTransform ESRotateTransformForOrientation(UIInterfaceOrientation orientation);

/**
 * Converts degrees to radians.
 */
FOUNDATION_EXTERN CGFloat ESDegreesToRadians(CGFloat degrees);

/**
 * Converts radians to degrees.
 */
FOUNDATION_EXTERN CGFloat ESRadiansToDegrees(CGFloat radians);

/**
 * Checks whether the current User Interface is Pad type.
 */
FOUNDATION_EXTERN BOOL ESIsPadUI(void);

/**
 * Checks whether the device is an iPad/iPad Mini/iPad Air.
 */
FOUNDATION_EXTERN BOOL ESIsPadDevice(void);

/**
 * Checks whether the current User Interface is Phone type.
 */
FOUNDATION_EXTERN BOOL ESIsPhoneUI(void);

/**
 * Checks whether the device is an iPhone/iPod Touch.
 */
FOUNDATION_EXTERN BOOL ESIsPhoneDevice(void);

/**
 * Checks whether the device has retina screen.
 */
FOUNDATION_EXTERN BOOL UIScreenIsRetina(void);

/**
 * Returns the bundle for the given name.
 */
FOUNDATION_EXTERN NSBundle *ESBundleWithName(NSString *bundleName);

/**
 * Returns the full path relatived to the given bundle's resourcePath and the given relativePath.
 */
FOUNDATION_EXTERN NSString *ESPathForBundleResource(NSBundle *bundle, NSString *relativePath);

/**
 * Returns the full path for the resource path of the main bundle.
 */
FOUNDATION_EXTERN NSString *ESPathForMainBundleResource(NSString *relativePath);

/**
 * Returns the path of the Documents directory.
 */
FOUNDATION_EXTERN NSString *ESPathForDocuments(void);

/**
 * Returns the path relatived to the Documents directory.
 */
FOUNDATION_EXTERN NSString *ESPathForDocumentsResource(NSString *relativePath);

/**
 * Returns the path of the Library directory.
 */
FOUNDATION_EXTERN NSString *ESPathForLibrary(void);

/**
 * Returns the path relatived to the Library directory.
 */
FOUNDATION_EXTERN NSString *ESPathForLibraryResource(NSString *relativePath);

/**
 * Returns the path of the Caches directory.
 */
FOUNDATION_EXTERN NSString *ESPathForCaches(void);

/**
 * Returns the path relatived to the Caches directory.
 */
FOUNDATION_EXTERN NSString *ESPathForCachesResource(NSString *relativePath);

/**
 * Returns the path of the temporary (tmp) directory.
 */
FOUNDATION_EXTERN NSString *ESPathForTemporary(void);

/**
 * Returns the path relatived to the temporary (tmp) directory.
 */
FOUNDATION_EXTERN NSString *ESPathForTemporaryResource(NSString *relativePath);

/**
 * Creates the directory at the given path if the directory does not exist.
 */
FOUNDATION_EXTERN BOOL ESTouchDirectory(NSString *directoryPath);

/**
 * Creates the directory at the given file path if the directory does not exist.
 */
FOUNDATION_EXTERN BOOL ESTouchDirectoryAtFilePath(NSString *filePath);

/**
 * Creates the directory at the given file URL if the directory does not exist.
 */
FOUNDATION_EXTERN BOOL ESTouchDirectoryAtFileURL(NSURL *url);

/// =============================================
/// @name GCD
/// =============================================
#pragma mark - GCD

FOUNDATION_EXTERN void es_dispatch_async_main(dispatch_block_t block);
FOUNDATION_EXTERN void es_dispatch_sync_main(dispatch_block_t block);

FOUNDATION_EXTERN void es_dispatch_async_global_queue(dispatch_queue_priority_t priority, dispatch_block_t block);
FOUNDATION_EXTERN void es_dispatch_async_high(dispatch_block_t block);
FOUNDATION_EXTERN void es_dispatch_async_default(dispatch_block_t block);
FOUNDATION_EXTERN void es_dispatch_async_low(dispatch_block_t block);
FOUNDATION_EXTERN void es_dispatch_async_background(dispatch_block_t block);

FOUNDATION_EXTERN void es_dispatch_after(NSTimeInterval delayInSeconds, dispatch_block_t block);

/// =============================================
/// @name ObjC Runtime
/// =============================================
#pragma mark - ObjC Runtime

/**
 * @code
 * + (void)load {
 *      ESSwizzleInstanceMethod(self, @selector(method:), @selector(method_new:));
 * }
 * @endcode
 */
FOUNDATION_EXTERN void ESSwizzleInstanceMethod(Class c, SEL orig, SEL new_sel);
FOUNDATION_EXTERN void ESSwizzleClassMethod(Class c, SEL orig, SEL new_sel);

/// =============================================
/// @name Invocation
/// =============================================
#pragma mark - Invocation

@interface NSInvocation (_ESHelper)

+ (instancetype)invocationWithTarget:(id)target selector:(SEL)selector;
+ (instancetype)invocationWithTarget:(id)target selector:(SEL)selector retainArguments:(BOOL)retainArguments, ...;
+ (instancetype)invocationWithTarget:(id)target selector:(SEL)selector retainArguments:(BOOL)retainArguments arguments:(va_list)arguments;
- (void)es_getReturnValue:(void *)returnValue;

@end /* NSInvocation (_ESHelper) */

@interface NSObject (_ESInvocationHelper)

/**
 * Invokes selector.
 *
 * @code
 * NSArray *__autoreleasing result;
 * BOOL outSucceed;
 * NSError *__autoreleasing outError;
 *
 * if ([self invokeSelector:@selector(foo:succeed:error:) retainArguments:NO result:&result, @"bar", &outSucceed, &outError]) {
 *      if (outSucceed) {
 *              NSLog(@"result: %@", result);
 *      } else {
 *              NSLog(@"error: %@", outError);
 *      }
 * }
 * @endcode
 *
 * @return YES if invokes successfully, otherwise NO.
 */
- (BOOL)invokeSelector:(SEL)selector result:(void *)result, ...;

/**
 * Invokes selector.
 *
 * @see -[NSObject invokeSelector:retainArguments:result,...]
 * @return YES if invokes successfully, otherwise NO.
 */
+ (BOOL)invokeSelector:(SEL)selector result:(void *)result, ...;

@end /* NSObject (_ESInvocationHelper) */

/**
 * Invokes selector.
 *
 * @code
 * CGRect bounds;
 * if (ESInvokeSelector([UIScreen mainScreen], @selector(bounds), &bounds)) {
 *     NSLog(@"%@", NSStringFromCGRect(bounds));
 * }
 * @endcode
 *
 * @return YES if invokes successfully, otherwise NO.
 */
FOUNDATION_EXTERN BOOL ESInvokeSelector(id target, SEL selector, void *result, ...);

#endif /* ESFrameworkCore_ESDefines_H */
