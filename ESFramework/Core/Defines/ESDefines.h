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
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

#if defined(__cplusplus)
        #define ES_EXTERN               extern "C" __attribute__((visibility ("default")))
        #define ES_EXTERN_C_BEGIN       extern "C" {
        #define ES_EXTERN_C_END         }
#else
        #define ES_EXTERN               extern
        #define ES_EXTERN_C_BEGIN
        #define ES_EXTERN_C_END
#endif

#define ES_INLINE                       NS_INLINE

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

///=============================================
/// @name Stopwatch
///=============================================
#pragma mark - Stopwatch

// Calc the execution time.
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
/// @name Weak Object
///=============================================
#pragma mark - Weak Object

/**
 * @code
 * ESWeak(imageView, weakImageView);
 * [self testBlock:^(UIImage *image) {
 *         ESStrong(weakImageView, strongImageView);
 *         strongImageView.image = image;
 * }];
 *
 * // `ESWeak_(imageView)` will create a var named `weak_imageView`
 * ESWeak_(imageView);
 * [self testBlock:^(UIImage *image) {
 *         ESStrong_(imageView);
 * 	_imageView.image = image;
 * }];
 *
 * // weak `self` and strong `self`
 * ESWeakSelf;
 * [self testBlock:^(UIImage *image) {
 *         ESStrongSelf;
 *         _self.image = image;
 * }];
 * @endcode
 */

#define ESWeak(var, weakVar) __weak __typeof(&*var) weakVar = var
#define ESStrong_DoNotCheckNil(weakVar, _var) __typeof(&*weakVar) _var = weakVar
#define ESStrong(weakVar, _var) ESStrong_DoNotCheckNil(weakVar, _var); if (!_var) return;

#define ESWeak_(var) ESWeak(var, weak_##var);
#define ESStrong_(var) ESStrong(weak_##var, _##var);

/** defines a weak `self` named `__weakSelf` */
#define ESWeakSelf      ESWeak(self, __weakSelf);
/** defines a strong `self` named `_self` from `__weakSelf` */
#define ESStrongSelf    ESStrong(__weakSelf, _self);

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

/**
 * Checks whether the device's OS version is at least the given version number.
 *
 * @param versionNumber Any value of NSFoundationVersionNumber_iOS_xxx
 *
 * @code
 * return (floor(NSFoundationVersionNumber) >= versionNumber);
 * @endcode
 */
ES_EXTERN BOOL ESOSVersionIsAtLeast(double versionNumber);

/**
 * Checks whether the device's OS version is above the given version number.
 *
 * @param versionNumber Any value of NSFoundationVersionNumber_iOS_xxx
 *
 * @code
 * return (floor(NSFoundationVersionNumber) > versionNumber);
 * @endcode
 */
ES_EXTERN BOOL ESOSVersionIsAbove(double versionNumber);

/**
 * Checks whether the device's OS version is above iOS7.0.
 *
 * @code
 * return ESOSVersionIsAbove(NSFoundationVersionNumber_iOS_6_1);
 * @endcode
 */
ES_EXTERN BOOL ESOSVersionIsAbove7(void);

/**
 * Checks whether the device's OS version is above iOS8.0.
 *
 * @code
 * return ESOSVersionIsAbove(NSFoundationVersionNumber_iOS_7_1);
 * @endcode
 */
ES_EXTERN BOOL ESOSVersionIsAbove8(void);

///=============================================
/// @name UIColor Helper
///=============================================
#pragma mark - UIColor Helper

/// UIColorWithRGBA(123.f, 255.f, 200.f, 1.f);
ES_EXTERN UIColor *UIColorWithRGBA(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha);
/// UIColorWithRGB(123.f, 255.f, 200.f);
ES_EXTERN UIColor *UIColorWithRGB(CGFloat red, CGFloat green, CGFloat blue);
/// UIColorWithRGBA(0x7bffc8, 1.f);
ES_EXTERN UIColor *UIColorWithRGBAHex(NSInteger rgbValue, CGFloat alpha);
ES_EXTERN UIColor *UIColorWithRGBHex(NSInteger rgbValue);
/// UIColorWithRGBHexString(@"#33AF00", 1.f);
/// UIColorWithRGBHexString(@"0x33AF00", 0.3f);
/// UIColorWithRGBHexString(@"33AF00", 0.9);
ES_EXTERN UIColor *UIColorWithRGBAHexString(NSString *hexString, CGFloat alpha);


///=============================================
/// @name Singleton
///=============================================
#pragma mark - Singleton

/**
 * Singleton Example:
 *
 * @code
 *
 * @interface MyLocationManager : NSObject
 * ES_SINGLETON_DEC(sharedManager);
 * ES_SINGLETON_DEC(anotherManager);
 * @end
 *
 * @implementation MyLocationManager
 * ES_SINGLETON_IMP(sharedManager);
 * ES_SINGLETON_IMP_AS(anotherManager, gAnotherManager);
 * @end
 *
 * @interface SubclassManager : MyLocationManager
 * @end
 *
 * @implementation SubclassManager
 *  // Subclasses *MUST* give a different variable name for evey shared instance.
 *  // You can use `ES_SINGLETON_IMP_AS` to overwrite the sharedInstance methods.
 * ES_SINGLETON_IMP_AS(sharedManager, gSharedSubclassManager);
 * ES_SINGLETON_IMP_AS(anotherManager, gSharedAnotherManager);
 * @end
 *
 * @endcode
 */

/**
 * Declare singleton `sharedInstance` methods.
 *
 * @param sharedInstance The shared instance's method name.
 */
#define ES_SINGLETON_DEC(sharedInstance)        + (instancetype)sharedInstance;
/**
 * Implement singleton `sharedInstance` methods.
 *
 * If you are subclassing a signleton class, make sure overwrite the `sharedInstance` method to 
 * give a different variable name.
 */
#define ES_SINGLETON_IMP_AS(sharedInstance, sharedInstanceVariableName) \
+ (instancetype)sharedInstance \
{ \
/**/    static id __##sharedInstanceName = nil; \
/**/    static dispatch_once_t onceToken; \
/**/    dispatch_once(&onceToken, ^{ __##sharedInstanceName = [[[self class] alloc] init]; }); \
/**/    return __##sharedInstanceName; \
}
#define ES_SINGLETON_IMP(sharedInstance)        ES_SINGLETON_IMP_AS(sharedInstance, gSharedInstance)


///=============================================
/// @name Helper
///=============================================
#pragma mark - Helper

#define CFReleaseSafely(_var)   if(_var){ CFRelease(_var); _var = NULL; }

/** Bitmask */
#define ESMaskIsSet(value, flag)        (((value) & (flag)) == (flag))
#define ESMaskSet(value, flag)          ((value) |= (flag));
#define ESMaskUnset(value, flag)        ((value) &= ~(flag));

/** Datetime constants */
#define ES_MINUTE (60)
#define ES_HOUR   (3600)
#define ES_DAY    (86400)
#define ES_5_DAYS (432000)
#define ES_WEEK   (604800)
#define ES_MONTH  (2635200) /* 30.5 days */
#define ES_YEAR   (31536000) /* 365 days */

ES_INLINE BOOL ESIsStringWithAnyText(id object) {
        return ([object isKindOfClass:[NSString class]] && ![(NSString *)object isEqualToString:@""]);
}

ES_INLINE BOOL ESIsArrayWithItems(id object) {
        return ([object isKindOfClass:[NSArray class]] && [(NSArray *)object count] > 0);
}

ES_INLINE BOOL ESIsDictionaryWithItems(id object) {
        return ([object isKindOfClass:[NSDictionary class]] && [(NSDictionary *)object count] > 0);
}

ES_INLINE BOOL ESIsSetWithItems(id object) {
        return ([object isKindOfClass:[NSSet class]] && [(NSSet *)object count] > 0);
}


/** LocalizedString */
#define ESLocalizedString(key)          NSLocalizedString(key,nil)
#define ESLocalizedStringWithFormat(key, ...)   [NSString stringWithFormat:NSLocalizedString(key,nil),##__VA_ARGS__]
/** Shortcut for ESLocalizedString(key) */
#undef _e
#define _e(key) ESLocalizedString(key)

ES_EXTERN NSBundle *ESBundleWithName(NSString *bundleName);

/**
 * Returns the current statusBar's height, in any orientation.
 */
ES_INLINE CGFloat ESStatusBarHeight(void) {
        CGRect frame = [UIApplication sharedApplication].statusBarFrame;
        return fminf(frame.size.width, frame.size.height);
};

/**
 * Returns the application's current interface orientation.
 */
ES_INLINE UIInterfaceOrientation ESInterfaceOrientation(void) {
        return [UIApplication sharedApplication].statusBarOrientation;
}

ES_EXTERN UIDeviceOrientation ESDeviceOrientation(void);

ES_EXTERN CGAffineTransform ESRotateTransformForOrientation(UIInterfaceOrientation orientation);

/**
 * Convert degrees to radians.
 */
ES_INLINE CGFloat ESDegreesToRadians(CGFloat degrees) {
        return (degrees * M_PI / 180.0);
}

/**
 * Convert radians to degrees.
 */
ES_INLINE CGFloat ESRadiansToDegrees(CGFloat radians) {
        return (radians * 180.0 / M_PI);
}

/**
 * Checks whether UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
 */
ES_EXTERN BOOL ESIsPadUI(void);
/**
 * Checks whether the device is a iPad/iPad Mini/iPad Air.
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

/**
 * [UIScreen mainScreen].scale >= 2.0
 */
ES_EXTERN BOOL ESIsRetinaScreen(void);

/**
 * Returns an `UIImage` instance using `+[UIImage imageNamed:]` method.
 * App bundle could only includes `@2x` high resolution images, this method will
 * return correct `scaled` image for normal resolution device such as iPad mini 1th.
 * 
 * + Standard: `<ImageName><device_modifier>.<filename_extension>`
 * + High resolution: `<ImageName>@2x<device_modifier>.<filename_extension>`
 *
 * The `<device_modifier>` portion is optional and contains either the string `~ipad` or `~iphone`
 *
 * @see Updating Your Image Resource Files https://developer.apple.com/library/ios/documentation/2DDrawing/Conceptual/DrawingPrintingiOS/SupportingHiResScreensInViews/SupportingHiResScreensInViews.html#//apple_ref/doc/uid/TP40010156-CH15-SW8
 */
ES_EXTERN UIImage *UIImageFromCache(NSString *path, ...);

/**
 * Returns a new `UIImage` instance.
 *
 * The `path` specification is the same as `UIImageFromCache(NSString *)`, as well as `+[UIImage imageNamed:]`.
 */
ES_EXTERN UIImage *UIImageFrom(NSString *path, ...);

ES_EXTERN NSString *NSStringWith(NSString *format, ...);
ES_EXTERN NSURL *NSURLWith(NSString *format, ...);

/**
 * Formats a number of bytes in a human-readable format. e.g. @"12.34 bytes", @"123 GB"
 * 
 * **Note**: NSByteCountFormatter uses 1000 step length.
 *
 * Returns a string showing the size in bytes, KBs, MBs, or GBs. Steps with 1024 bytes.
 */
ES_EXTERN NSString *NSStringFromBytesSizeWithStep(unsigned long long bytesSize, int step);
/**
 * With 1024 step.
 */
ES_EXTERN NSString *NSStringFromBytesSize(unsigned long long bytesSize);

/**
 * Creates a mutable set which does not retain references to the objects it contains.
 */
ES_EXTERN NSMutableSet *ESCreateNonretainedMutableSet(void);
ES_EXTERN NSMutableArray *ESCreateNonretainedMutableArray(void);
ES_EXTERN NSMutableDictionary *ESCreateNonretainedMutableDictionary(void);

///=============================================
/// @name Paths
///=============================================
#pragma mark - Path

ES_EXTERN NSString *ESPathForBundleResource(NSBundle *bundle, NSString *relativePath, ...);
ES_EXTERN NSString *ESPathForMainBundleResource(NSString *relativePath, ...);
ES_EXTERN NSString *ESPathForDocuments(void);
ES_EXTERN NSString *ESPathForDocumentsResource(NSString *relativePath, ...);
ES_EXTERN NSString *ESPathForLibrary(void);
ES_EXTERN NSString *ESPathForLibraryResource(NSString *relativePath, ...);
ES_EXTERN NSString *ESPathForCaches(void);
ES_EXTERN NSString *ESPathForCachesResource(NSString *relativePath, ...);
ES_EXTERN NSString *ESPathForTemporary(void);
ES_EXTERN NSString *ESPathForTemporaryResource(NSString *relativePath, ...);

/// Creates the `dir`  if it doesn't exist
ES_EXTERN BOOL ESTouchDirectory(NSString *dir);
/// Creates directories if it doesn't exist, returns `nil` if failed.
ES_EXTERN NSString *ESTouchFilePath(NSString *filePath, ...);

///=============================================
/// @name Dispatch & Block
///=============================================
#pragma mark - Dispatch & Block

typedef void (^ESBasicBlock)(void);
typedef void (^ESHandlerBlock)(id sender);

ES_EXTERN void ESDispatchSyncOnMainThread(dispatch_block_t block) __attribute__((deprecated("use ESDispatchOnMainThreadSynchronously instead.")));
ES_EXTERN void ESDispatchAsyncOnMainThread(dispatch_block_t block) __attribute__((deprecated("use ESDispatchOnMainThreadAsynchronously instead.")));

ES_EXTERN void ESDispatchOnMainThreadSynchronously(dispatch_block_t block);
ES_EXTERN void ESDispatchOnMainThreadAsynchronously(dispatch_block_t block);
ES_EXTERN void ESDispatchOnGlobalQueue(dispatch_queue_priority_t priority, dispatch_block_t block);
ES_EXTERN void ESDispatchOnDefaultQueue(dispatch_block_t block);
ES_EXTERN void ESDispatchOnHighQueue(dispatch_block_t block);
ES_EXTERN void ESDispatchOnLowQueue(dispatch_block_t block);
ES_EXTERN void ESDispatchOnBackgroundQueue(dispatch_block_t block);
/** After `delayTime`, dispatch `block` on the main thread. */
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
 * Call a selector with unknown numbers of arguments.
 *
 * @code
 *  // trun off compiler warning if there is.
 * #pragma clang diagnostic push
 * #pragma clang diagnostic ignored "-Wundeclared-selector"
 *
 *  ESInvokeSelector(self, @selector(test), NULL);
 *
 *  NSInteger result = 0;
 *  ESInvokeSelector([Foo class], @selector(classMethod:), &result, CGSizeMake(10, 20));
 *
 *  if (ESInvokeSelector(someObject, @selector(someSelector:::), NULL, arg1, arg2, arg3)) {
 *         // Invoked OK
 *  }
 *
 * #pragma clang diagnostic pop
 * @endcode
 *
 */
ES_EXTERN BOOL ESInvokeSelector(id target, SEL selector, void *result, ...);

///=============================================
/// @name NSObject(ESAssociatedObject)
///=============================================
#pragma mark - NSObject(ESAssociatedObject)
/**
 * NSObject(ESAssociatedObject)
 * 
 * Get/Set associated objects. It's useful to add properties to a class's category.
 *
 * @code
 * @interface SomeClass (additions)
 * @property (nonatomic, weak) __weak id<SomeDelegate> delegate;
 * @property (nonatomic, strong) UIView *view;
 * @end
 *
 * // SomeClass+additions.m
 *
 * static char _delegateKey;
 * // OR
 * static const void *_viewKey = &_viewKey;
 *
 * @implementation SomeClass (additions)
 * - (id<SomeDelegate>)delegate
 * {
 *        return [self getAssociatedObject:&_delegateKey];
 * }
 * - (void)setDelegate:(id<SomeDelegate>)delegate
 * {
 *        [self setAssociatedObject_nonatomic_weak:delegate key:&_delegateKey];
 * }
 * - (UIView *)view
 * {
 *        return [self getAssociatedObject:_viewKey];
 * }
 * - (void)setView:(UIView *)view
 * {
 *        [self setAssociatedObject_nonatomic_retain:view key:_viewKey];
 * }
 * @end
 * @endcode
 *
 */
@interface NSObject (ESAssociatedObject)
- (id)getAssociatedObject:(const void *)key;
+ (id)getAssociatedObject:(const void *)key;
/// `OBJC_ASSOCIATION_ASSIGN` is not a `zeroing weak references`.
- (void)setAssociatedObject_nonatomic_weak:(__weak id)weakObject key:(const void *)key;
+ (void)setAssociatedObject_nonatomic_weak:(__weak id)weakObject key:(const void *)key;
- (void)setAssociatedObject_nonatomic_retain:(id)object key:(const void *)key;
+ (void)setAssociatedObject_nonatomic_retain:(id)object key:(const void *)key;
- (void)setAssociatedObject_nonatomic_copy:(id)object key:(const void *)key;
+ (void)setAssociatedObject_nonatomic_copy:(id)object key:(const void *)key;
- (void)setAssociatedObject_atomic_retain:(id)object key:(const void *)key;
+ (void)setAssociatedObject_atomic_retain:(id)object key:(const void *)key;
- (void)setAssociatedObject_atomic_copy:(id)object key:(const void *)key;
+ (void)setAssociatedObject_atomic_copy:(id)object key:(const void *)key;
- (void)removeAllAssociatedObjects;
+ (void)removeAllAssociatedObjects;
@end

///=============================================
/// @name NSUserDefaults (ESHelper)
///=============================================
#pragma mark - NSUserDefaults (ESHelper)
@interface NSUserDefaults (ESHelper)
/**
 * Get object for the given key.
 */
+ (id)objectForKey:(NSString *)key;
/**
 * Async saving object.
 */
+ (void)setObject:(id)object forKey:(NSString *)key;
/**
 * Async removing object.
 */
+ (void)removeObjectForKey:(NSString *)key;
@end

#endif // ESFramework_ESDefines_H
