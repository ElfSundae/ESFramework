//
//  ESDefines.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-2.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#ifndef ESFramework_ESDefines_H
#define ESFramework_ESDefines_H

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

#if defined(__cplusplus)
#define ES_EXTERN       extern "C" __attribute__((visibility ("default")))
#else
#define ES_EXTERN       extern __attribute__((visibility ("default")))
#endif


///=============================================
/// @name Log
///=============================================
#pragma mark - Log

#undef NSLogIf

#ifdef DEBUG
#define NSLog(fmt, ...)                 NSLog((@"%@:%d %s " fmt), [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__)
#define NSLogIf(condition, fmt, ...)    if((condition)) { NSLog(fmt, ##__VA_ARGS__); }
#else
#define NSLog(fmt, ...)
#define NSLogIf(condition, fmt, ...)
#endif


/**
 * Log the execution time.
 */
#include <mach/mach_time.h>
ES_EXTERN mach_timebase_info_data_t __es_timebase_info;

#if DEBUG
#define ES_STOPWATCH_BEGIN(stopwatch_begin_var)  \
        uint64_t stopwatch_begin_var = mach_absolute_time();
#define ES_STOPWATCH_END(stopwatch_begin_var) \
        uint64_t end_##stopwatch_begin_var = mach_absolute_time() - stopwatch_begin_var; \
        if (__es_timebase_info.denom == 0) { (void) mach_timebase_info(&__es_timebase_info); } \
        end_##stopwatch_begin_var = end_##stopwatch_begin_var * __es_timebase_info.numer / __es_timebase_info.denom; \
        double ms_end_##stopwatch_begin_var = (double)end_##stopwatch_begin_var / 1000000; \
        printf("‼️STOPWATCH‼️[%s:%d] %s %fms\n", [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, ms_end_##stopwatch_begin_var);
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

#import <Availability.h>

#ifndef __IPHONE_8_0
#define __IPHONE_8_0    80000
#endif
#ifndef __IPHONE_8_1
#define __IPHONE_8_1    80100
#endif
#ifndef __IPHONE_8_2
#define __IPHONE_8_2     80200
#endif

#ifndef NSFoundationVersionNumber_iOS_7_1
#define NSFoundationVersionNumber_iOS_7_1 1047.25
#endif
#ifndef NSFoundationVersionNumber_iOS_8_0
#define NSFoundationVersionNumber_iOS_8_0 1140.11
#endif

/**
 * Returns the device's OS version.
 * e.g. @"6.1"
 */
ES_EXTERN NSString *ESOSVersion(void);

ES_EXTERN BOOL ESOSVersionIsAtLeast(double NSFoundationVersionNumber_);
ES_EXTERN BOOL ESOSVersionIsAbove(double NSFoundationVersionNumber_);
ES_EXTERN BOOL ESOSVersionIsAbove7(void);
ES_EXTERN BOOL ESOSVersionIsAbove8(void);

///=============================================
/// @name Helper Macros
///=============================================
#pragma mark - Helper Macros

/**
 * Make weak references to break "retain cycles".
 */
#define ESWeak(var, weakVar) __weak __typeof(&*var) weakVar = var
#define ESWeak_(var) ESWeak(var, weak_##var);
#define ESWeakSelf      ESWeak(self, __weakSelf);

#define ESStrong_DoNotCheckNil(weakVar, _var) __typeof(&*weakVar) _var = weakVar
#define ESStrong(weakVar, _var) ESStrong_DoNotCheckNil(weakVar, _var); if (!_var) return;
#define ESStrong_(var) ESStrong(weak_##var, _##var);
#define ESStrongSelf    ESStrong(__weakSelf, _self);

/**
 * Force a category to be loaded when an app starts up.
 *
 * Add this macro before each category implementation, so we don't have to use
 * -all_load or -force_load to load object files from static libraries that only contain
 * categories and no classes.
 * See http://developer.apple.com/library/mac/#qa/qa2006/qa1490.html for more info.
 *
 * https://github.com/NimbusKit/basics#avoid-requiring-the--all_load-and--force_load-flags
 *
 * @code
 * // In the category .m file
 * ES_CATEGORY_FIX(NSString_ESAdditions)
 *
 * @implementation NSString (ESAdditions)
 * ...
 * @end
 * @endcode
 */
#define ES_CATEGORY_FIX(name) @interface _ES_CATEGORY_FIX_##name : NSObject @end \
@implementation _ES_CATEGORY_FIX_##name @end

#define ES_IMPLEMENTATION_CATEGORY_FIX(class_name, category_name) \
ES_CATEGORY_FIX(class_name##_##category_name)     \
@implementation class_name (category_name)


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
/**/    static dispatch_once_t onceToken; \
/**/    dispatch_once(&onceToken, ^{ sharedInstanceVariableName = [[[self class] alloc] init]; }); \
/**/    return sharedInstanceVariableName; \
}
#define ES_SINGLETON_IMP(sharedInstance)        ES_SINGLETON_IMP_AS(sharedInstance, __gSharedInstance)


#define CFReleaseSafely(var)   if(var){ CFRelease(var); var = NULL; }


#define ESMaskIsSet(value, flag)        (((value) & (flag)) == (flag))
#define ESMaskSet(value, flag)          ((value) |= (flag));
#define ESMaskUnset(value, flag)        ((value) &= ~(flag));

/** 
 * Localized string.
 */
#define ESLocalizedString(key)          NSLocalizedString(key,nil)
#define ESLocalizedStringWithFormat(key, ...)   [NSString stringWithFormat:NSLocalizedString(key,nil),##__VA_ARGS__]
/** 
 * Shortcut for ESLocalizedString(key)
 */
#ifndef _e
#define _e(key) ESLocalizedString(key)
#endif


///=============================================
/// @name Helper Functions
///=============================================
#pragma mark - Functions
/**
 * UIColorWithRGBA(123.f, 255.f, 200.f, 1.f);
 */
ES_EXTERN UIColor *UIColorWithRGBA(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha);
ES_EXTERN UIColor *UIColorWithRGB(CGFloat red, CGFloat green, CGFloat blue);

/**
 * UIColorWithRGBAHex(0x7bffc8, 1.f);
 */
ES_EXTERN UIColor *UIColorWithRGBAHex(NSInteger rgbValue, CGFloat alpha);
ES_EXTERN UIColor *UIColorWithRGBHex(NSInteger rgbValue);

/**
 * UIColorWithRGBHexString(@"#33AF00", 1.f);
 * UIColorWithRGBHexString(@"0x33AF00", 0.3f);
 * UIColorWithRGBHexString(@"33AF00", 0.9);
 * 接受6-8位十六进制，取最后6位。
 */
ES_EXTERN UIColor *UIColorWithRGBAHexString(NSString *hexString, CGFloat alpha);


NS_INLINE BOOL ESIsStringWithAnyText(id object) {
        return ([object isKindOfClass:[NSString class]] && ![(NSString *)object isEqualToString:@""]);
}

NS_INLINE BOOL ESIsArrayWithItems(id object) {
        return ([object isKindOfClass:[NSArray class]] && [(NSArray *)object count] > 0);
}

NS_INLINE BOOL ESIsDictionaryWithItems(id object) {
        return ([object isKindOfClass:[NSDictionary class]] && [(NSDictionary *)object count] > 0);
}

NS_INLINE BOOL ESIsSetWithItems(id object) {
        return ([object isKindOfClass:[NSSet class]] && [(NSSet *)object count] > 0);
}

/**
 * Creates a mutable set which does not retain references to the objects it contains.
 */
ES_EXTERN NSMutableSet *ESCreateNonretainedMutableSet(void);
ES_EXTERN NSMutableArray *ESCreateNonretainedMutableArray(void);
ES_EXTERN NSMutableDictionary *ESCreateNonretainedMutableDictionary(void);

/**
 * Generate random number, (min, max]
 */
ES_EXTERN u_int32_t ESRandomNumber(u_int32_t min, u_int32_t max /*upper_bound*/);
/**
 * Generate random data using `SecRandomCopyBytes`
 */
ES_EXTERN NSData *ESRandomDataOfLength(NSUInteger length);
/**
 * Generate random string, contains 0-9a-zA-Z.
 */
ES_EXTERN NSString *ESRandomStringOfLength(NSUInteger length);

/**
 * Specifies a "zeroing weak reference" to the associated object.
 */
#define OBJC_ASSOCIATION_WEAK (0100000)
/**
 * Returns the value associated with a given object for a given key.
 */
ES_EXTERN id es_objc_getAssociatedObject(id target, const void *key);
/**
 * Sets an associated value for a given object using a given key and association policy.
 */
ES_EXTERN void es_objc_setAssociatedObject(id target, const void *key, id value, objc_AssociationPolicy policy);

/**
 * Returns the current statusBar's height, in any orientation.
 */
NS_INLINE CGFloat ESStatusBarHeight(void) {
        CGRect frame = [UIApplication sharedApplication].statusBarFrame;
        return fminf(frame.size.width, frame.size.height);
};

/**
 * Returns the application's current interface orientation.
 */
NS_INLINE UIInterfaceOrientation ESInterfaceOrientation(void) {
        return [UIApplication sharedApplication].statusBarOrientation;
}

/**
 * Returns current device orientation.  this will return UIDeviceOrientationUnknown unless device orientation notifications are being generated.
 */
NS_INLINE UIDeviceOrientation ESDeviceOrientation(void) {
        return [UIDevice currentDevice].orientation;
}

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

NS_INLINE CGFloat ESDegreesToRadians(CGFloat degrees) {
        return (degrees * M_PI / 180.0);
}

NS_INLINE CGFloat ESRadiansToDegrees(CGFloat radians) {
        return (radians * 180.0 / M_PI);
}

NS_INLINE BOOL ESIsPadUI(void) {
        return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
}

/// Checks whether the device is a iPad/iPad Mini/iPad Air.
NS_INLINE BOOL ESIsPadDevice(void) {
        return ([[UIDevice currentDevice].model rangeOfString:@"iPad" options:NSCaseInsensitiveSearch].location != NSNotFound);
}

NS_INLINE BOOL ESIsPhoneUI(void) {
        return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone);
}

NS_INLINE BOOL ESIsPhoneDevice(void) {
        return ([[UIDevice currentDevice].model rangeOfString:@"iPhone" options:NSCaseInsensitiveSearch].location != NSNotFound ||
                [[UIDevice currentDevice].model rangeOfString:@"iPod" options:NSCaseInsensitiveSearch].location != NSNotFound);
}

NS_INLINE BOOL UIScreenIsRetina(void) {
        return [UIScreen mainScreen].scale >= 2.0;
}

ES_EXTERN NSString *NSStringWith(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);

ES_EXTERN NSURL *NSURLWith(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);

/**
 * Formats a number of bytes in a human-readable format. e.g. @"12.34 Bytes", @"123 GB"
 *
 * **Note**: NSByteCountFormatter uses 1000 step length.
 *
 * Returns a string showing the size in Bytes, KBs, MBs, or GBs, with 1024 bytes step.
 */
ES_EXTERN NSString *NSStringFromBytesSizeWithStep(unsigned long long bytesSize, int step);
/**
 * With 1024b step.
 */
ES_EXTERN NSString *NSStringFromBytesSize(unsigned long long bytesSize);


/**
 * Returns an `UIImage` instance using `+[UIImage imageNamed:]` method.
 * App bundle could only include `@2x` high resolution images, this method will
 * return correct `scaled` image for normal resolution device such as iPad mini 1th.
 * 
 * + Standard: `<ImageName><device_modifier>.<filename_extension>`
 * + High resolution: `<ImageName>@2x<device_modifier>.<filename_extension>`
 *
 * The `<device_modifier>` portion is optional and contains either the string `~ipad` or `~iphone`
 *
 * @see Updating Your Image Resource Files https://developer.apple.com/library/ios/documentation/2DDrawing/Conceptual/DrawingPrintingiOS/SupportingHiResScreensInViews/SupportingHiResScreensInViews.html#//apple_ref/doc/uid/TP40010156-CH15-SW8
 */
ES_EXTERN UIImage *UIImageFromCache(NSString *filePath);

/**
 * Returns a new `UIImage` instance, using `[UIImage imageWithContentsOfFile:]` method.
 *
 * The `filePath` specification is the same as `UIImageFromCache(NSString *)`.
 */
ES_EXTERN UIImage *UIImageFrom(NSString *filePath);


ES_EXTERN NSBundle *ESBundleWithName(NSString *bundleName);

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
 * Creates the `directoryPath`  if it doesn't exist.
 */
ES_EXTERN BOOL ESTouchDirectory(NSString *directoryPath);
ES_EXTERN BOOL ESTouchDirectoryAtFilePath(NSString *filePath);

///=============================================
/// @name Dispatch & Block
///=============================================
#pragma mark - Dispatch & Block

typedef void (^ESBasicBlock)(void);
typedef void (^ESHandlerBlock)(id sender);

ES_EXTERN void ESDispatchOnMainThreadSynchrony(dispatch_block_t block);
ES_EXTERN void ESDispatchOnMainThreadAsynchrony(dispatch_block_t block);
ES_EXTERN void ESDispatchOnGlobalQueue(dispatch_queue_priority_t priority, dispatch_block_t block);
ES_EXTERN void ESDispatchOnDefaultQueue(dispatch_block_t block);
ES_EXTERN void ESDispatchOnHighQueue(dispatch_block_t block);
ES_EXTERN void ESDispatchOnLowQueue(dispatch_block_t block);
ES_EXTERN void ESDispatchOnBackgroundQueue(dispatch_block_t block);
/**
 * After `delayTime`, dispatch `block` on the main thread.
 */
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
 * // trun off compiler warning if there are some.
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
 * **Note**: selector的返回值为BOOL时，请定义result类型为char或者int.
 * **Note**: 如果取result时crash了，可以尝试定义result为void*, 执行完ESInvokeSelector后用__bridge关键字转换对象。
 */
ES_EXTERN BOOL ESInvokeSelector(id target, SEL selector, void *result, ...);


#endif // ESFramework_ESDefines_H
