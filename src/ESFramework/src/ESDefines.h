//
//  ESDefines.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-2.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#ifndef ESFramework_ESDefines_h
#define ESFramework_ESDefines_h

@import Foundation;
@import UIKit;

#if defined(__cplusplus)
        #define ES_EXTERN extern "C"
        #define ES_EXTERN_C_BEGIN extern "C" {
        #define ES_EXTERN_C_END }
#else
        #define ES_EXTERN extern
        #define ES_EXTERN_C_BEGIN
        #define ES_EXTERN_C_END
#endif

/**
 * ESFramework version.
 */
ES_EXTERN NSString *const ESFrameworkVersion;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Log
/**
 * A better NSLog.
 */
#ifdef DEBUG
#define NSLog(fmt, ...)		NSLog((@"%@:%d %s " fmt),[[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__)
#else
#define NSLog(fmt, ...)
#endif

/**
 * Log level.
 */
#define ESLOGLEVEL_INFO     8
#define ESLOGLEVEL_WARNING  4
#define ESLOGLEVEL_ERROR    1
/**
 * The maximum log level, can be changed at runtime.
 *
 * The default value is ESLOGLEVEL_INFO.
 */
ES_EXTERN NSInteger ESMaxLogLevel;

#undef NSLogCondition
#ifdef DEBUG
/**
 * Only writes log if condition is satisfied.
 */
#define NSLogCondition(condition, fmt, ...)     do { if((condition)){ NSLog(fmt, ##__VA_ARGS__); } } while(0)
/**
 * Writes log with a prefix, used to debug a specially module.
 * example:
 @code
 NSLogPrefix(@"<Socket> ", @"Connected to host %@", host);
 @endcode
 */
#define NSLogPrefix(prefixString, fmt, ...)     do { NSLog(@""prefixString fmt, ##__VA_ARGS__); } while(0)
#define NSLogInfo(fmt, ...)     do { if(ESLOGLEVEL_INFO <= ESMaxLogLevel){ NSLogPrefix(@"<Info> ", fmt, ##__VA_ARGS__); } } while(0)
#define NSLogWarning(fmt, ...)  do { if(ESLOGLEVEL_WARNING <= ESMaxLogLevel){ NSLogPrefix(@"❗<Warning> ", fmt, ##__VA_ARGS__); } } while(0)
#define NSLogError(fmt, ...)    do { if(ESLOGLEVEL_ERROR <= ESMaxLogLevel){ NSLogPrefix(@"❌<Error> ", fmt, ##__VA_ARGS__); } } while(0)
#else
#define NSLogCondition(condition, fmt, ...)
#define NSLogPrefix(prefixString, fmt, ...)
#define NSLogInfo(fmt, ...)
#define NSLogWarning(fmt, ...)
#define NSLogError(fmt, ...)
#endif // #ifdef DEBUG

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ARC
/**
 * ARC
 */
#if __has_feature(objc_arc)
        #define __es_arc_enabled        1
        #define ES_STRONG       strong
        #define ES_AUTORELEASE(exp)
        #define ES_RELEASE(exp)
        #define ES_RETAIN(exp)
#else
        #define __es_arc_enabled        0
        #define ES_STRONG       retain
        #define ES_AUTORELEASE(exp) [exp autorelease]
        #define ES_RELEASE(exp)  do { [exp release]; exp = nil; } while(0)
        #define ES_RETAIN(exp) [exp retain]
#endif

/**
 * Release a CoreFoundation object safely.
 */
#define ES_RELEASE_CF_SAFELY(__REF)             do { if (nil != (__REF)) { CFRelease(__REF); __REF = nil; } } while(0)

/**
 * Weak property.
 *
 @code
 @property (nonatomic, es_weak_property) __es_weak id<SomeDelegate> delegate;
 @endcode
 */
#if TARGET_OS_IPHONE && defined(__IPHONE_5_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0) && __clang__ && (__clang_major__ >= 3)
        #define ES_SDK_SUPPORTS_WEAK 1
#elif TARGET_OS_MAC && defined(__MAC_10_7) && (MAC_OS_X_VERSION_MIN_REQUIRED >= __MAC_10_7) && __clang__ && (__clang_major__ >= 3)
        #define ES_SDK_SUPPORTS_WEAK 1
#else
        #define ES_SDK_SUPPORTS_WEAK 0
#endif

#if ES_SDK_SUPPORTS_WEAK
        #define __es_weak        __weak
        #define es_weak_property weak
#else
        #if __clang__ && (__clang_major__ >= 3)
                #define __es_weak __unsafe_unretained
        #else
                #define __es_weak
        #endif
        #define es_weak_property assign
#endif

/**
 * Get the var's type
 */
#define __es_typeof(var)         __typeof(&*var)

/**
 * Weak object.
 @code
 ES_WEAK_VAR(self, _self);
 [self someBlock:^{
        ES_STRONG_VAR(_self, _strongSelf);
        if (_strongSelf) {
                // do stuff
        }
 }];
 
 // Or
 
 [self someBlock:^{
        ES_STRONG_VAR_CHECK_NULL(_self, _strongSelf);
        // Now the _strongSelf is not nil.
        // do stuff
 }];
 @endcode
 */
#if __es_arc_enabled
        #define ES_WEAK_VAR(_var, _weak_var)    __es_weak __es_typeof(_var) _weak_var = _var
#else
        #define ES_WEAK_VAR(_var, _weak_var)    __block __es_typeof(_var) _weak_var = _var
#endif
#define ES_STRONG_VAR(_weak_var, _strong_var)        __es_typeof(_weak_var) _strong_var = _weak_var
#define ES_STRONG_VAR_CHECK_NULL(_weak_var, _strong_var)        ES_STRONG_VAR(_weak_var, _strong_var); if(!_strong_var) return;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - SDK Compatibility
/**
 * SDK Compatibility
 */
#import <Availability.h>
/**
 *
 @code
 #if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
 // This code will only compile on versions >= iOS 7.0
 #endif
 #endcode
 */
#ifndef __IPHONE_5_0
#define __IPHONE_5_0     50000
#endif
#ifndef __IPHONE_5_1
#define __IPHONE_5_1     50100
#endif
#ifndef __IPHONE_6_0
#define __IPHONE_6_0     60000
#endif
#ifndef __IPHONE_6_1
#define __IPHONE_6_1     60100
#endif
#ifndef __IPHONE_7_0
#define __IPHONE_7_0     70000
#endif
#ifndef __IPHONE_7_1
#define __IPHONE_7_1     70100
#endif

#ifndef NSFoundationVersionNumber_iOS_5_0
#define NSFoundationVersionNumber_iOS_5_0  881.00
#endif
#ifndef NSFoundationVersionNumber_iOS_5_1
#define NSFoundationVersionNumber_iOS_5_1  890.10
#endif
#ifndef NSFoundationVersionNumber_iOS_6_0
#define NSFoundationVersionNumber_iOS_6_0  993.00
#endif
#ifndef NSFoundationVersionNumber_iOS_6_1
#define NSFoundationVersionNumber_iOS_6_1  993.00
#endif
#ifndef NSFoundationVersionNumber_iOS_7_0
//TODO: Correct _iOS_7_0 value from Apple officer when the next SDK distributed.
#define NSFoundationVersionNumber_iOS_7_0  1047.00
#endif

/**
 * Mark a method or property as deprecated to the compiler.
 */
#define __ES_ATTRIBUTE_DEPRECATED       __attribute__((deprecated))

/**
 * Returns the device's OS version.
 * e.g. @"6.1"
 */
ES_EXTERN NSString *ESDeviceOSVersion(void);

/**
 * Checks whether the device's OS version is at least the given version number.
 *
 * @param versionNumber Any value of NSFoundationVersionNumber_iOS_xxx
 */
ES_EXTERN BOOL ESDeviceOSVersionIsAtLeast(double versionNumber);

/**
 * Checks whether the device's OS version is above the given version number.
 *
 * @param versionNumber Any value of NSFoundationVersionNumber_iOS_xxx
 */
ES_EXTERN BOOL ESDeviceOSVersionIsAbove(double versionNumber);

/**
 * Checks whether the device's OS version is above iOS7.0
 *
 @code
 return ESDeviceOSVersionIsAbove(NSFoundationVersionNumber_iOS_6_1);
 @endcode
 */
ES_EXTERN BOOL ESDeviceOSVersionIsAbove7(void);

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIColor Helper
/**
 @code
 UIColorWithRGBA(123.f, 255.f, 200.f, 1.f);
 @endcode
 */
ES_EXTERN UIColor *UIColorWithRGBA(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha);
/**
 @code
 UIColorWithRGBA(123.f, 255.f, 200.f);
 @endcode
 */
ES_EXTERN UIColor *UIColorWithRGB(CGFloat red, CGFloat green, CGFloat blue);
/**
 @code
 UIColorWithRGBA(0x7bffc8, 1.f);
 @endcode
 */
ES_EXTERN UIColor *UIColorWithRGBAHex(NSInteger rgbValue, CGFloat alpha);
ES_EXTERN UIColor *UIColorWithRGBHex(NSInteger rgbValue);
/**
 @code
 UIColorWithHexString(@"#33AF00", 1.f);
 UIColorWithHexString(@"0x33AF00", 0.3f);
 UIColorWithHexString(@"33AF00", 0.9);
 @endcode
 */
ES_EXTERN UIColor *UIColorWithHexString(NSString *hexString, CGFloat alpha);

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Singleton
/**
 * Singleton Example:
 @code
 
 @interface MyLocationManager : NSObject
 ES_SINGLETON_DEC(sharedManager);
 ES_SINGLETON_DEC(anotherManager);
 /// Add this line to avoid method #alloc #new being called.
 __ES_ATTRIBUTE_UNAVAILABLE_SINGLETON_ALLOCATION
 /// other methods
 - (void)start;
 @end

 @implementation MyLocationManager
 ES_SINGLETON_IMP(sharedManager);
 ES_SINGLETON_IMP_AS(anotherManager, initAnotherManager);
 
 - (instancetype)init
 {
        self = [super init];
        if (self) NSLog(@"sharedManager init.");
        return self;
 }
 - (instancetype)initAnotherManager;
 {
        self = [super init];
        if (self) NSLog(@"anotherManager init.");
        return self;
 }
 
 - (void)start
 {
        // ...
 }
 @end

 @endcode
 */

/**
 * Declare singleton #sharedInstance# methods.
 * #Option means this class also can be allocated to create a new instance.
 *
 * @param sharedInstance The shared instance's method name.
 */
#define ES_SINGLETON_DEC(sharedInstance)        + (instancetype)sharedInstance;
/**
 * Mark the #alloc #new method as unavailable.
 */
#define __ES_ATTRIBUTE_UNAVAILABLE_SINGLETON_ALLOCATION \
+ (id)alloc __attribute__((unavailable("alloc not available, call the shared instance instead."))); \
+ (id)new __attribute__((unavailable("new not available, call the shared instance instead.")));
/**
 * Implement singleton #sharedInstance# methods.
 *
 * @param sharedInstance The shared instance's method name.
 * @param initMethod Your initiation method.
 */
#define ES_SINGLETON_IMP_AS(sharedInstance, initMethod) \
+ (instancetype)sharedInstance \
{ \
        static id __sharedInstance__ = nil; \
        static dispatch_once_t onceToken; \
        dispatch_once(&onceToken, ^{ __sharedInstance__ = [[super alloc] initMethod]; }); \
        return __sharedInstance__; \
}
/**
 * Implement singleton #sharedInstance# methods.
 *
 * @param sharedInstance The shared instance's method name.
 */
#define ES_SINGLETON_IMP(sharedInstance)        ES_SINGLETON_IMP_AS(sharedInstance, init)


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Helper
/** 
 * Check bit (flag) 
 */
#define ES_IS_MASK_SET(value, flag)     (((value) & (flag)) == (flag))
/** 
 * LocalizedString 
 */
#define ESLocalizedString(key)          NSLocalizedString(key,nil)
#define ESLocalizedStringWithFormat(key, ...)   [NSString stringWithFormat:NSLocalizedString(key,nil),##__VA_ARGS__]
/** 
 * Shortcut for ESLocalizedString(key) 
 */
#ifndef _
#define _(key) ESLocalizedString(key)
#endif

/**
 * Returns the statusBar's height, in any orientation.
 */
ES_EXTERN CGFloat ESStatusBarHeight(void);

/**
 * Returns the current locale.
 */
ES_EXTERN NSLocale *ESCurrentLocale(void);

/** 
 * Checks whether UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad 
 */
ES_EXTERN BOOL ESIsPadUI(void);
/**
 * Checks whether the device is a iPad/iPad Mini.
 */
ES_EXTERN BOOL ESIsPadDevice(void);

/**
 * Checks whether UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone
 */
ES_EXTERN BOOL ESIsPhoneUI(void);
/**
 * Checks whether the device is a iPhone/iPod Touch.
 */
ES_EXTERN BOOL ESIsPhoneDevice(void);

#pragma mark - Path

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

#pragma mark - Dispatch

ES_EXTERN void ESDispatchSyncOnMainThread(dispatch_block_t block);
ES_EXTERN void ESDispatchAsyncOnMainThread(dispatch_block_t block);
ES_EXTERN void ESDispatchAsyncOnGlobalQueue(dispatch_queue_priority_t priority, dispatch_block_t block);

#pragma mark - Selector
/**
 * Swizzle class method.
 */
ES_EXTERN void ESSwizzleClassMethod(Class c, SEL orig, SEL new);
/**
 * Swizzle instance method.
 */
ES_EXTERN void ESSwizzleInstanceMethod(Class c, SEL orig, SEL new);

/**
 * Constructs an NSInvocation for a class target or an instance target.
 *
 @code
 NSInvocation *invocation = ESInvocation(self, @selector(foo:));
 NSInvocation *invocation = ESInvocation([self class], @selector(classMethod:));
 @endcode
 */
ES_EXTERN NSInvocation *ESInvocationWith(id target, SEL selector);

/**
 * Call a selector with multiple arguments.
 * The arguments should be ended with a #nil or #NULL sentinel.
 *
 @code
 id ret = ESInvokeSelector(self, @selector(foo:bar:), @"arg1", @"arg2", nil);
 NSString *ret = ESInvokeSelector([self class], @selector(foo), nil);
 @endcode
 */
ES_EXTERN id ESInvokeSelector(id target, SEL selector, id arguments, ...) NS_REQUIRES_NIL_TERMINATION;

#endif // ESFramework_ESDefines_h
