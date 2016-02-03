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
#import <UIKit/UIKit.h>
#import <Availability.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Security/Security.h>
#import <objc/runtime.h>
#import <mach/mach_time.h>

#if defined(__cplusplus)
#define ES_EXTERN       extern "C" __attribute__((visibility ("default")))
#else
#define ES_EXTERN       extern __attribute__((visibility ("default")))
#endif


///=============================================
/// @name Log
///=============================================
#pragma mark - Log

#if (!defined(NSLog) && !defined(NSLogIf))
#if DEBUG
#define NSLog(fmt, ...)                 NSLog((@"%@:%d %s " fmt), [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__)
#define NSLogIf(condition, fmt, ...)    if((condition)) { NSLog(fmt, ##__VA_ARGS__); }
#else
#define NSLog(fmt, ...)
#define NSLogIf(condition, fmt, ...)
#endif
#endif

/**
 * Log the execution time.
 */

#if DEBUG
#define ES_STOPWATCH_BEGIN(stopwatch_begin_var) uint64_t stopwatch_begin_var = mach_absolute_time();
#define ES_STOPWATCH_END(stopwatch_begin_var)   { \
uint64_t end = mach_absolute_time(); \
mach_timebase_info_data_t timebaseInfo; \
(void) mach_timebase_info(&timebaseInfo); \
uint64_t elapsedNano = (end - stopwatch_begin_var) * timebaseInfo.numer / timebaseInfo.denom; \
double_t elapsedMillisecond = (double_t)elapsedNano / 1000000.0; \
printf("‼️STOPWATCH‼️ [%s:%d] %s %fms\n", [NSString stringWithUTF8String:__FILE__].lastPathComponent.UTF8String, __LINE__, __PRETTY_FUNCTION__, elapsedMillisecond); \
}
#else
#define ES_STOPWATCH_BEGIN(stopwatch_begin_var)
#define ES_STOPWATCH_END(stopwatch_begin_var)
#endif

///=============================================
/// @name Constants
///=============================================
#pragma mark - Constants

#define ES_MINUTE (60)
#define ES_HOUR   (3600)
#define ES_DAY    (86400)
#define ES_5_DAYS (432000)
#define ES_WEEK   (604800)
#define ES_MONTH  (2635200) /* 30.5 days */
#define ES_YEAR   (31536000) /* 365 days */


///=============================================
/// @name SDK Compatibility
///=============================================
#pragma mark - SDK Compatibility

#ifndef __IPHONE_9_0
#define __IPHONE_9_0     90000
#endif
#ifndef __IPHONE_9_1
#define __IPHONE_9_1     90100
#endif
#ifndef __IPHONE_9_2
#define __IPHONE_9_2     90200
#endif

#ifndef NSFoundationVersionNumber_iOS_8_4
#define NSFoundationVersionNumber_iOS_8_4 1144.17
#endif


NS_INLINE NSString *ESOSVersion(void) {
        return [[UIDevice currentDevice] systemVersion];
}

NS_INLINE BOOL ESOSVersionIsAtLeast(double versionNumber) {
        return (NSFoundationVersionNumber >= versionNumber);
}

NS_INLINE BOOL ESOSVersionIsAbove(double versionNumber) {
        return (NSFoundationVersionNumber > versionNumber);
}

NS_INLINE BOOL ESOSVersionIsAbove7(void) {
        return ESOSVersionIsAbove(NSFoundationVersionNumber_iOS_6_1);
}

NS_INLINE BOOL ESOSVersionIsAbove8(void) {
        return ESOSVersionIsAbove(NSFoundationVersionNumber_iOS_7_1);
}

NS_INLINE BOOL ESOSVersionIsAbove9(void) {
        return ESOSVersionIsAbove(NSFoundationVersionNumber_iOS_8_4);
}


///=============================================
/// @name Helper Macros
///=============================================
#pragma mark - Helper Macros

/**
 * Make weak references to break "retain cycles".
 */
#define ESWeak_(var, weakVar)                   __weak __typeof(&*var) weakVar = var;
#define ESWeak(var)                             ESWeak_(var, weak_##var);
#define ESWeakSelf                              ESWeak(self);

#define ESStrong_DoNotCheckNil(weakVar, var)    __typeof(&*weakVar) var = weakVar;
#define ESStrong_(weakVar, var)                 ESStrong_DoNotCheckNil(weakVar, var); if (!var) return;
#define ESStrong(var)                           ESStrong_(weak_##var, var);
#define ESStrongSelf                            ESStrong(self);

/**
 * Declare singleton `+sharedInstance` method.
 */
#define ES_SINGLETON_DEC(sharedInstance)        + (instancetype)sharedInstance;

/**
 * Implement singleton `+sharedInstance` method.
 *
 * If you are subclassing a signleton class, make sure overwrite the `+sharedInstance` method to
 * provide a different variable name.
 */
#define ES_SINGLETON_IMP_AS(sharedInstance, sharedInstanceVariableName) \
+ (instancetype)sharedInstance \
{ \
/**/    static id sharedInstanceVariableName = nil; \
/**/    static dispatch_once_t onceToken_##sharedInstanceVariableName; \
/**/    dispatch_once(&onceToken_##sharedInstanceVariableName, ^{ sharedInstanceVariableName = [[[self class] alloc] init]; }); \
/**/    return sharedInstanceVariableName; \
}
#define ES_SINGLETON_IMP(sharedInstance)        ES_SINGLETON_IMP_AS(sharedInstance, __gSharedInstance)

/**
 * Safely release CF instance.
 */
#define CFReleaseSafely(var)   if(var){ CFRelease(var); var = NULL; }

/**
 * Bits-mask helper.
 */
#define ESMaskIsSet(value, flag)        (((value) & (flag)) == (flag))
#define ESMaskSet(value, flag)          ((value) |= (flag));
#define ESMaskUnset(value, flag)        ((value) &= ~(flag));

/** 
 * Localized string.
 */
#define ESLocalizedString(key)                  NSLocalizedString(key,nil)
#ifndef _e
#define _e(key) NSLocalizedString(key,nil)
#endif
#define ESLocalizedStringWithFormat(key, ...)   [NSString stringWithFormat:NSLocalizedString(key,nil),##__VA_ARGS__]

///=============================================
/// @name Helper Functions
///=============================================
#pragma mark - Functions

/**
 * Creates UIColor from RGB values.
 *
 * e.g. `UIColorWithRGBA(123.f, 255.f, 200.f, 1.f);`
 */
ES_EXTERN UIColor *UIColorWithRGBA(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha);
ES_EXTERN UIColor *UIColorWithRGB(CGFloat red, CGFloat green, CGFloat blue);

/**
 * Creates UIColor from RGB Hex number.
 *
 * e.g. `UIColorWithRGBAHex(0x7bffc8, 1.f);`
 */
ES_EXTERN UIColor *UIColorWithRGBAHex(NSInteger rgbValue, CGFloat alpha);
ES_EXTERN UIColor *UIColorWithRGBHex(NSInteger rgbValue);

/**
 * Creates UIColor from the last six characters of a hex string.
 *
 * e.g.
 * @code
 * UIColorWithRGBHexString(@"#33AF00", 1.f);
 * UIColorWithRGBHexString(@"0x33AF00", 0.3f);
 * UIColorWithRGBHexString(@"33AF00", 0.9);
 * @endcode
 */
ES_EXTERN UIColor *UIColorWithRGBAHexString(NSString *hexString, CGFloat alpha);

/**
 * Checks whether the given object is a non-empty string.
 */
NS_INLINE BOOL ESIsStringWithAnyText(id object) {
        return ([object isKindOfClass:[NSString class]] && [(NSString *)object length] > 0);
}

/**
 * Checks whether the given object is a non-empty array.
 */
NS_INLINE BOOL ESIsArrayWithItems(id object) {
        return ([object isKindOfClass:[NSArray class]] && [(NSArray *)object count] > 0);
}

/**
 * Checks whether the given object is a non-empty dictionary.
 */
NS_INLINE BOOL ESIsDictionaryWithItems(id object) {
        return ([object isKindOfClass:[NSDictionary class]] && [(NSDictionary *)object count] > 0);
}

/**
 * Checks whether the given object is a non-empty set.
 */
NS_INLINE BOOL ESIsSetWithItems(id object) {
        return ([object isKindOfClass:[NSSet class]] && [(NSSet *)object count] > 0);
}

/**
 * Creates a mutable set which does not retain references to the objects it contains.
 */
ES_EXTERN NSMutableSet *ESCreateNonretainedMutableSet(void);

/**
 * Creates a mutable array which does not retain references to the objects it contains.
 */
ES_EXTERN NSMutableArray *ESCreateNonretainedMutableArray(void);

/**
 * Creates a mutable dictionary which does not retain references to the objects it contains.
 */
ES_EXTERN NSMutableDictionary *ESCreateNonretainedMutableDictionary(void);

/**
 * Generates a random number between min and max.
 */
ES_EXTERN uint32_t ESRandomNumber(uint32_t min, uint32_t max);

/**
 * Generates a random data using `SecRandomCopyBytes`.
 */
ES_EXTERN NSData *ESRandomDataOfLength(NSUInteger length);

/**
 * Generates a random string that contains 0-9a-zA-Z.
 */
ES_EXTERN NSString *ESRandomStringOfLength(NSUInteger length);

/**
 * Generates a random color.
 */
ES_EXTERN UIColor *ESRandomColor(void);

/**
 * Generates an UUID string, 36bits, e.g. @"B743154C-087E-4E7C-84AC-2573AAB940AD"
 */
ES_EXTERN NSString *ESUUID(void);

/**
 * Specifies a "zeroing weak reference" to the associated object.
 */
ES_EXTERN const objc_AssociationPolicy OBJC_ASSOCIATION_WEAK;

/**
 * Defines a key for the Associcated Object.
 */
#define ESDefineAssociatedObjectKey(name)       static const void * name##Key = & name##Key

/**
 * Returns the value associated with a given object for a given key.
 */
ES_EXTERN id ESGetAssociatedObject(id target, const void *key);

/**
 * Sets an associated value for a given object using a given key and association policy.
 */
ES_EXTERN void ESSetAssociatedObject(id target, const void *key, id value, objc_AssociationPolicy policy);

/**
 * Returns the current statusBar's height, in any orientation.
 */
NS_INLINE CGFloat ESStatusBarHeight(void) {
        return fminf([UIApplication sharedApplication].statusBarFrame.size.width, [UIApplication sharedApplication].statusBarFrame.size.height);
};

/**
 * Returns the application's current interface orientation.
 */
NS_INLINE UIInterfaceOrientation ESInterfaceOrientation(void) {
        return [UIApplication sharedApplication].statusBarOrientation;
}

/**
 * Returns current device orientation.
 * This will return UIDeviceOrientationUnknown unless device orientation notifications are being generated.
 */
NS_INLINE UIDeviceOrientation ESDeviceOrientation(void) {
        return [UIDevice currentDevice].orientation;
}

/**
 * Returns a recommended rotating transform for the given interface orientation.
 */
NS_INLINE CGAffineTransform ESRotateTransformForOrientation(UIInterfaceOrientation orientation) {
        if (UIInterfaceOrientationLandscapeLeft == orientation) {
                return CGAffineTransformMakeRotation((CGFloat)(M_PI * 1.5));
        } else if (UIInterfaceOrientationLandscapeRight == orientation) {
                return CGAffineTransformMakeRotation((CGFloat)(M_PI / 2.0));
        } else if (UIInterfaceOrientationPortraitUpsideDown == orientation) {
                return CGAffineTransformMakeRotation((CGFloat)(-M_PI));
        } else {
                return CGAffineTransformIdentity;
        }
}

/**
 * Converts degrees to radians.
 */
NS_INLINE CGFloat ESDegreesToRadians(CGFloat degrees) {
        return (degrees * M_PI / 180.0);
}

/**
 * Converts radians to degrees.
 */
NS_INLINE CGFloat ESRadiansToDegrees(CGFloat radians) {
        return (radians * 180.0 / M_PI);
}

/**
 * Checks whether the current User Interface is Pad type.
 */
NS_INLINE BOOL ESIsPadUI(void) {
        return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
}

/**
 * Checks whether the device is an iPad/iPad Mini/iPad Air.
 */
NS_INLINE BOOL ESIsPadDevice(void) {
        return ([[UIDevice currentDevice].model rangeOfString:@"iPad" options:NSCaseInsensitiveSearch].location != NSNotFound);
}

/**
 * Checks whether the current User Interface is Phone type.
 */
NS_INLINE BOOL ESIsPhoneUI(void) {
        return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone);
}

/**
 * Checks whether the device is an iPhone/iPod Touch.
 */
NS_INLINE BOOL ESIsPhoneDevice(void) {
        return ([[UIDevice currentDevice].model rangeOfString:@"iPhone" options:NSCaseInsensitiveSearch].location != NSNotFound ||
                [[UIDevice currentDevice].model rangeOfString:@"iPod" options:NSCaseInsensitiveSearch].location != NSNotFound);
}

/**
 * Checks whether the device has retina screen.
 */
NS_INLINE BOOL UIScreenIsRetina(void) {
        return [UIScreen mainScreen].scale >= 2.0;
}

/**
 * Creates NSString with the given format and arguments.
 */
ES_EXTERN NSString *NSStringWith(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);

/**
 * Formats a bytes number in a human-readable format. e.g. @"12.34 Bytes", @"123 GB".
 * Returns a string that showing the size in Bytes, KBs, MBs, or GBs, with the given step length.
 */
ES_EXTERN NSString *NSStringFromBytesSizeWithStep(unsigned long long bytesSize, int step);

/**
 * Formats a bytes number in a human-readable format with 1024b step length.
 *
 * @warning `NSByteCountFormatter` uses 1000 step length.
 */
ES_EXTERN NSString *NSStringFromBytesSize(unsigned long long bytesSize);

/**
 * Returns an `UIImage` instance using `+[UIImage imageNamed:]` method.
 *
 * Image files within App bundle can contain only high resolution images like `@2x`,`@3x`,
 * this function can return the correct "down-scaled" image for the device which has normal 
 * resolution such as iPad mini 1th.
 * 
 * The naming conventions for each pair of image files is as follows:
 *
 * + Standard: `<ImageName><device_modifier>.<filename_extension>`
 * + High resolution: `<ImageName>@2x<device_modifier>.<filename_extension>`
 *
 * The `<device_modifier>` portion is optional and contains either the string `~ipad` or `~iphone`.
 *
 * @see [Updating Your Image Resource Files](https://developer.apple.com/library/ios/documentation/2DDrawing/Conceptual/DrawingPrintingiOS/SupportingHiResScreensInViews/SupportingHiResScreensInViews.html#//apple_ref/doc/uid/TP40010156-CH15-SW8)
 */
ES_EXTERN UIImage *UIImageFromCache(NSString *filePath);

/**
 * Returns a new `UIImage` instance, using `[UIImage imageWithContentsOfFile:]` method.
 *
 * The `filePath` specification is the same as `UIImageFromCache(NSString *)`.
 */
ES_EXTERN UIImage *UIImageFrom(NSString *filePath);

/**
 * Returns the bundle for the given name.
 */
ES_EXTERN NSBundle *ESBundleWithName(NSString *bundleName);

/**
 * Returns a full file path for the Sandbox.
 */
ES_EXTERN NSString *ESPathForBundleResource(NSBundle *bundle, NSString *relativePath);
ES_EXTERN NSString *ESPathForMainBundleResource(NSString *relativePath);
ES_EXTERN NSString *ESPathForDocuments(void);
ES_EXTERN NSString *ESPathForDocumentsResource(NSString *relativePath);
ES_EXTERN NSString *ESPathForLibrary(void);
ES_EXTERN NSString *ESPathForLibraryResource(NSString *relativePath);
ES_EXTERN NSString *ESPathForCaches(void);
ES_EXTERN NSString *ESPathForCachesResource(NSString *relativePath);
ES_EXTERN NSString *ESPathForTemporary(void);
ES_EXTERN NSString *ESPathForTemporaryResource(NSString *relativePath);

/**
 * Creates the directory at the given path if the directory does not exist.
 */
ES_EXTERN BOOL ESTouchDirectory(NSString *directoryPath);

/**
 * Creates the directory at the given file path if the directory does not exist.
 */
ES_EXTERN BOOL ESTouchDirectoryAtFilePath(NSString *filePath);
/**
 * Creates the directory at the given file URL if the directory does not exist.
 */
ES_EXTERN BOOL ESTouchDirectoryAtURL(NSURL *url);

///=============================================
/// @name Dispatch & Block
///=============================================
#pragma mark - Dispatch & Block

ES_EXTERN void ESDispatchOnMainThreadSynchrony(dispatch_block_t block);
ES_EXTERN void ESDispatchOnMainThreadAsynchrony(dispatch_block_t block);
ES_EXTERN void ESDispatchOnGlobalQueue(dispatch_queue_priority_t priority, dispatch_block_t block);
ES_EXTERN void ESDispatchOnDefaultQueue(dispatch_block_t block);
ES_EXTERN void ESDispatchOnHighQueue(dispatch_block_t block);
ES_EXTERN void ESDispatchOnLowQueue(dispatch_block_t block);
ES_EXTERN void ESDispatchOnBackgroundQueue(dispatch_block_t block);
ES_EXTERN void ESDispatchAfter(NSTimeInterval delayTime, dispatch_block_t block);

///=============================================
/// @name Invocation
///=============================================
#pragma mark - Invocation

/**
 * @code
 * + (void)load {
 *        @autoreleasepool {
 *                ESSwizzleInstanceMethod([self class], @selector(viewDidLoad), @selector(viewDidLoad_new));
 *        }
 * }
 * @endcode
 */
ES_EXTERN void ESSwizzleInstanceMethod(Class c, SEL orig, SEL new_sel);
ES_EXTERN void ESSwizzleClassMethod(Class c, SEL orig, SEL new_sel);

/**
 * Constructs an NSInvocation for a class target or an instance target.
 *
 * @code
 * NSInvocation *invocation = ESInvocation(self, @selector(foo:));
 * NSInvocation *invocation = ESInvocation([self class], @selector(classMethod:));
 * @endcode
 *
 */
ES_EXTERN NSInvocation *ESInvocationWith(id target, SEL selector);

/**
 * Invoke a selector.
 *
 * @code
 * // trun off compiler warnings if there are some.
 * #pragma clang diagnostic push
 * #pragma clang diagnostic ignored "-Wundeclared-selector"
 *
 *  ESInvokeSelector(self, NSSelectorFromString(@"test"), NULL);
 *
 *  NSInteger result = 0;
 *  ESInvokeSelector([Foo class], NSSelectorFromString(@"classMethod:"), &result, CGSizeMake(10, 20));
 *
 *  if (ESInvokeSelector(someObject, @selector(someSelector:::), NULL, arg1, arg2, arg3)) {
 *         // Invoked OK
 *  }
 *
 * #pragma clang diagnostic pop
 * @endcode
 *
 * @warning If the return type of selector is BOOL, please define the result as char type or int type.
 * @warning If this code crashes when accessing the returned result, you may try to define the result as `void *` type, and then access it using `__bridge` keyword.
 */
ES_EXTERN BOOL ESInvokeSelector(id target, SEL selector, void *result, ...);


#endif /* ESFramework_ESDefines_H */
