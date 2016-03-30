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
#define ESStrong(var)                           ESStrong_(weak_##var, _##var);
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
 * e.g. `UIColorWithRGBA(123., 255., 200., 1.);`
 */
FOUNDATION_EXTERN UIColor *UIColorWithRGBA(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha);
FOUNDATION_EXTERN UIColor *UIColorWithRGB(CGFloat red, CGFloat green, CGFloat blue);

/**
 * Creates UIColor from RGB Hex number.
 *
 * e.g. `UIColorWithRGBAHex(0x7bffc8, 1.);`
 */
FOUNDATION_EXTERN UIColor *UIColorWithRGBAHex(NSInteger rgbValue, CGFloat alpha);
FOUNDATION_EXTERN UIColor *UIColorWithRGBHex(NSInteger rgbValue);

/**
 * Creates UIColor from the last six characters of a hex string.
 *
 * e.g.
 * @code
 * UIColorWithRGBHexString(@"#33AF00", 1.);
 * UIColorWithRGBHexString(@"0x33AF00", 0.3);
 * UIColorWithRGBHexString(@"33AF00", 0.9);
 * @endcode
 */
FOUNDATION_EXTERN UIColor *UIColorWithRGBAHexString(NSString *hexString, CGFloat alpha);

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
 * Specifies a "zeroing weak reference" to the associated object.
 */
FOUNDATION_EXTERN const objc_AssociationPolicy OBJC_ASSOCIATION_WEAK;

/**
 * Defines a key for the Associcated Object.
 */
#define ESDefineAssociatedObjectKey(name)       static const void * name##Key = & name##Key

/**
 * Returns the value associated with a given object for a given key.
 */
FOUNDATION_EXTERN id ESGetAssociatedObject(id target, const void *key);

/**
 * Sets an associated value for a given object using a given key and association policy.
 */
FOUNDATION_EXTERN void ESSetAssociatedObject(id target, const void *key, id value, objc_AssociationPolicy policy);

/**
 * Returns the current statusBar's height, in any orientation.
 */
NS_INLINE CGFloat ESStatusBarHeight(void) {
        return fmin([UIApplication sharedApplication].statusBarFrame.size.width, [UIApplication sharedApplication].statusBarFrame.size.height);
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
 * Returns NSString from CGSize with format `(int)width+"x"+(int)heigth`.
 *
 * @note The height in returned string is always bigger than the width.
 */
FOUNDATION_EXTERN NSString *ESStringFromSize(CGSize size);

/**
 * Creates NSString with the given format and arguments.
 */
FOUNDATION_EXTERN NSString *NSStringWith(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);

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
FOUNDATION_EXTERN UIImage *UIImageFromCache(NSString *filePath);

/**
 * Returns a new `UIImage` instance, using `[UIImage imageWithContentsOfFile:]` method.
 *
 * The `filePath` specification is the same as `UIImageFromCache(NSString *)`.
 */
FOUNDATION_EXTERN UIImage *UIImageFrom(NSString *filePath);

/**
 * Returns the bundle for the given name.
 */
FOUNDATION_EXTERN NSBundle *ESBundleWithName(NSString *bundleName);

/**
 * Returns a full file path for the Sandbox.
 */
FOUNDATION_EXTERN NSString *ESPathForBundleResource(NSBundle *bundle, NSString *relativePath);
FOUNDATION_EXTERN NSString *ESPathForMainBundleResource(NSString *relativePath);
FOUNDATION_EXTERN NSString *ESPathForDocuments(void);
FOUNDATION_EXTERN NSString *ESPathForDocumentsResource(NSString *relativePath);
FOUNDATION_EXTERN NSString *ESPathForLibrary(void);
FOUNDATION_EXTERN NSString *ESPathForLibraryResource(NSString *relativePath);
FOUNDATION_EXTERN NSString *ESPathForCaches(void);
FOUNDATION_EXTERN NSString *ESPathForCachesResource(NSString *relativePath);
FOUNDATION_EXTERN NSString *ESPathForTemporary(void);
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
FOUNDATION_EXTERN BOOL ESTouchDirectoryAtURL(NSURL *url);

///=============================================
/// @name Dispatch & Block
///=============================================
#pragma mark - Dispatch & Block

FOUNDATION_EXTERN void ESDispatchOnMainThreadSynchrony(dispatch_block_t block);
FOUNDATION_EXTERN void ESDispatchOnMainThreadAsynchrony(dispatch_block_t block);
FOUNDATION_EXTERN void ESDispatchOnGlobalQueue(dispatch_queue_priority_t priority, dispatch_block_t block);
FOUNDATION_EXTERN void ESDispatchOnDefaultQueue(dispatch_block_t block);
FOUNDATION_EXTERN void ESDispatchOnHighQueue(dispatch_block_t block);
FOUNDATION_EXTERN void ESDispatchOnLowQueue(dispatch_block_t block);
FOUNDATION_EXTERN void ESDispatchOnBackgroundQueue(dispatch_block_t block);
FOUNDATION_EXTERN void ESDispatchAfter(NSTimeInterval delayTime, dispatch_block_t block);

///=============================================
/// @name ObjC Runtime
///=============================================
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

///=============================================
/// @name Invocation
///=============================================
#pragma mark - Invocation

@interface NSInvocation (_ESHelper)
+ (instancetype)invocationWithTarget:(id)target selector:(SEL)selector;
+ (instancetype)invocationWithTarget:(id)target selector:(SEL)selector retainArguments:(BOOL)retainArguments, ...;
+ (instancetype)invocationWithTarget:(id)target selector:(SEL)selector retainArguments:(BOOL)retainArguments arguments:(va_list)arguments;
- (void)es_getReturnValue:(void *)returnValue;
@end

@interface NSObject (_ESInvoke)
/**
 * Invokes selector.
 * @code
 * NSArray *__autoreleasing result;
 * BOOL outSucceed;
 * NSError *__autoreleasing outError;
 *
 * if ([self invokeSelector:@selector(foo:succeed:error:) retainArguments:NO result:&result, @"bar", &outSucceed, &outError]) {
 *         if (outSucceed) {
 *                 NSLog(@"result: %@", result);
 *         } else {
 *                 NSLog(@"error: %@", outError);
 *         }
 * }
 * @endcode
 *
 * @return YES if invoked successfully, otherwise NO.
 */
- (BOOL)invokeSelector:(SEL)selector result:(void *)result, ...;

/**
 * Invokes selector.
 * @see -[NSObject invokeSelector:retainArguments:result,...]
 * @return YES if invoked successfully, otherwise NO.
 */
+ (BOOL)invokeSelector:(SEL)selector result:(void *)result, ...;
@end

/**
 * Invokes selector.
 * @code
 * CGRect bounds;
 * if (ESInvokeSelector([UIScreen mainScreen], @selector(bounds), &bounds)) {
 *     NSLog(@"%@", NSStringFromCGRect(bounds));
 * }
 * @endcode
 * @return YES if invoked successfully, otherwise NO.
 */
FOUNDATION_EXTERN BOOL ESInvokeSelector(id target, SEL selector, void *result, ...);

#endif /* ESFrameworkCore_ESDefines_H */
