// ESDefines.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-2.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#ifndef ESFramework_ESDefines_h
#define ESFramework_ESDefines_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

#if defined(__cplusplus)
        #define ES_EXTERN extern "C"
        #define ES_EXTERN_C_BEGIN extern "C" {
        #define ES_EXTERN_C_END }
#else
        #define ES_EXTERN extern
        #define ES_EXTERN_C_BEGIN
        #define ES_EXTERN_C_END
#endif

#define ES_INLINE       NS_INLINE

///========================================================================================================
/// @name Log
///========================================================================================================
#pragma mark - Log

#ifdef DEBUG
/**
 * A better NSLog.
 */
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
#define NSLogCondition(condition, fmt, ...)     if((condition)){ NSLog(fmt, ##__VA_ARGS__); }
/**
 * Writes log with a prefix, used to debug a specially module.
 *
 * example: `NSLogPrefix(@"<Socket> ", @"Connected to host %@", host);`
 */
#define NSLogPrefix(prefixString, fmt, ...)     NSLog(@"<"prefixString @"> " fmt, ##__VA_ARGS__);
#define NSLogInfo(fmt, ...)     if(ESLOGLEVEL_INFO <= ESMaxLogLevel){ NSLogPrefix(@"Info", fmt, ##__VA_ARGS__); }
#define NSLogWarning(fmt, ...)  if(ESLOGLEVEL_WARNING <= ESMaxLogLevel){ NSLogPrefix(@"❗Warning", fmt, ##__VA_ARGS__); }
#define NSLogError(fmt, ...)    if(ESLOGLEVEL_ERROR <= ESMaxLogLevel){ NSLogPrefix(@"❌Error", fmt, ##__VA_ARGS__); }
#else
#define NSLogCondition(condition, fmt, ...)
#define NSLogPrefix(prefixString, fmt, ...)
#define NSLogInfo(fmt, ...)
#define NSLogWarning(fmt, ...)
#define NSLogError(fmt, ...)
#endif // #ifdef DEBUG

/**
 * Calc the execution time.
 */
#include <mach/mach_time.h>
ES_EXTERN mach_timebase_info_data_t __es_timebase_info__;

#if DEBUG
#define ES_STOPWATCH_BEGIN(begin_time_var, log, ...)  uint64_t begin_time_var = mach_absolute_time(); NSLog(@"<ES_STOPWATCH_BEGIN> " log, ##__VA_ARGS__);
#define ES_STOPWATCH_END(begin_time_var, log, ...)    NSLog(@"<ES_STOPWATCH_END> %llums = " log, ((mach_absolute_time() - begin_time_var) * __es_timebase_info__.numer / __es_timebase_info__.denom / 1000 ), ##__VA_ARGS__ );
#else
#define ES_STOPWATCH_BEGIN(begin_time_var, log, ...)
#define ES_STOPWATCH_END(begin_time_var, log, ...)
#endif


///========================================================================================================
/// @name ARC
///========================================================================================================
#pragma mark - ARC
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
        #define ES_RELEASE(exp)  [exp release]; exp = nil;
        #define ES_RETAIN(exp) [exp retain]
#endif

/**
 * Release a CoreFoundation object safely.
 */
#define ES_RELEASE_CF_SAFELY(__REF)             if (nil != (__REF)) { CFRelease(__REF); __REF = nil; }

/**
 * Weak property.
 *
 *      @property (nonatomic, es_weak_property) __es_weak id<SomeDelegate> delegate;
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
 *
 *	ESWeak(imageView, weakImageView);
 *	[self testBlock:^(UIImage *image) {
 *	        ESStrong(weakImageView, strongImageView);
 *	        strongImageView.image = image;
 *	}];
 *
 *	// `ESWeak_` will create a var named `weak_imageView`
 *	ESWeak_(imageView);
 *	[self testBlock:^(UIImage *image) {
 *	        ESStrong_(imageView);
 *		_imageView.image = image;
 *	}];
 *
 *	// weak `self` and strong `self`
 *	ESWeakSelf;
 *	[self testBlock:^(UIImage *image) {
 *	        ESStrongSelf;
 *	        _self.imageView = image;
 *	}];
 *
 */
#if __es_arc_enabled
        #define ESWeak(var, weakVar) __es_weak __es_typeof(var) weakVar = var
#else
        #define ESWeak(var, weakVar) __block __es_typeof(var) weakVar = var
#endif
#define ESStrong_DoNotCheckNil(weakVar, _var) __es_typeof(weakVar) _var = weakVar
#define ESStrong(weakVar, _var) ESStrong_DoNotCheckNil(weakVar, _var); if (!_var) return;

#define ESWeak_(var) ESWeak(var, weak_##var);
#define ESStrong_(var) ESStrong(weak_##var, _##var);

/** defines a weak self named "__weakSelf" */
#define ESWeakSelf      ESWeak(self, __weakSelf);
/** defines a strong self named "_self" from "__weakSelf" */
#define ESStrongSelf    ESStrong(__weakSelf, _self);

///========================================================================================================
/// @name SDK Compatibility
///========================================================================================================
#pragma mark - SDK Compatibility
#import <Availability.h>
/**
 *
 *      #if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
 *      // This code will only compile on versions >= iOS 7.0
 *      #endif
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
#define NSFoundationVersionNumber_iOS_7_0  1047.22
#endif

/**
 * Marks a method or property as deprecated to the compiler.
 */
#define __ES_ATTRIBUTE_DEPRECATED       __attribute__((deprecated))

/**
 * Returns the device's OS version.
 * e.g. @"6.1"
 */
ES_EXTERN NSString *ESOSVersion(void);

/**
 * Checks whether the device's OS version is at least the given version number.
 *
 * @param versionNumber Any value of NSFoundationVersionNumber_iOS_xxx
 */
ES_EXTERN BOOL ESOSVersionIsAtLeast(double versionNumber);

/**
 * Checks whether the device's OS version is above the given version number.
 *
 * @param versionNumber Any value of NSFoundationVersionNumber_iOS_xxx
 */
ES_EXTERN BOOL ESOSVersionIsAbove(double versionNumber);

/**
 * Checks whether the device's OS version is above iOS7.0.
 *
 *      return ESOSVersionIsAbove(NSFoundationVersionNumber_iOS_6_1);
 */
ES_EXTERN BOOL ESOSVersionIsAbove7(void);

///========================================================================================================
/// @name UIColor Helper
///========================================================================================================
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
ES_EXTERN UIColor *UIColorWithRGBHexString(NSString *hexString, CGFloat alpha);

///========================================================================================================
/// @name Singleton
///========================================================================================================
#pragma mark - Singleton
/**
 * Singleton Example:
 *
 * @code
 *
 *	@interface MyLocationManager : NSObject
 *	ES_SINGLETON_DEC(sharedManager);
 *	ES_SINGLETON_DEC(anotherManager);
 *	@end
 *
 *	@implementation MyLocationManager
 *	ES_SINGLETON_IMP(sharedManager);
 *	ES_SINGLETON_IMP_AS(anotherManager, gAnotherManager);
 *	@end
 *
 *	@interface SubclassManager : MyLocationManager
 *	@end
 *
 *	@implementation SubclassManager
 *	 // Subclasses must give a different variable name for evey shared instance.
 *	 // You can use `ES_SINGLETON_IMP_AS` to overwrite the sharedInstance methods.
 *	ES_SINGLETON_IMP_AS(sharedManager, gSharedSubclassManager);
 *	ES_SINGLETON_IMP_AS(anotherManager, gSharedAnotherManager);
 *	@end
 *	
 * @endcode
 *
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
 *
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


///========================================================================================================
/// @name Helper
///========================================================================================================
#pragma mark - Helper

ES_EXTERN NSString *const ESErrorDomain;
/**
 * Bitmask
 */
#define ESMaskIsSet(value, flag)        (((value) & (flag)) == (flag))
#define ESMaskSet(value, flag)          ((value) |= (flag));
#define ESMaskUnset(value, flag)        ((value) &= ~(flag));

/**
 * Datetime constants
 */

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


/**
 * LocalizedString 
 */
#define ESLocalizedString(key)          NSLocalizedString(key,nil)
#define ESLocalizedStringWithFormat(key, ...)   [NSString stringWithFormat:NSLocalizedString(key,nil),##__VA_ARGS__]
/** 
 * Shortcut for ESLocalizedString(key) 
 */
#undef _
#define _(key) ESLocalizedString(key)

ES_EXTERN NSBundle *ESBundleWithName(NSString *bundleName);

ES_EXTERN NSBundle *ESFWBundle(void);
#define ESFWLocalizedString(key)        NSLocalizedStringFromTableInBundle(key, nil, ESFWBundle(), nil)
#define ESFWLocalizedStringWithFormat(key, ...) [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(key, nil, ESFWBundle(), nil), ##__VA_ARGS__]
#undef _es_
#define _es_(key) ESFWLocalizedString(key)
/**
 * Returns the current statusBar's height, in any orientation.
 */
ES_INLINE CGFloat ESStatusBarHeight(void) {
        CGRect frame = [UIApplication sharedApplication].statusBarFrame;
        // Avoid having to check the status bar orientation.
        return MIN(frame.size.width, frame.size.height);
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
 * Returns (x, y, w+dx, h+dy);
 */
ES_INLINE CGRect ESRectExpandSize(CGRect rect, CGFloat dx, CGFloat dy) {
        return CGRectMake(rect.origin.x, rect.origin.y, rect.size.width + dx, rect.size.height + dy);
}
/**
 * Returns (x+dx, y+dy, w, h);
 */
ES_INLINE CGRect ESRectExpandOrigin(CGRect rect, CGFloat dx, CGFloat dy) {
        return CGRectMake(rect.origin.x + dx, rect.origin.y + dy, rect.size.width, rect.size.height);
}

ES_INLINE CGRect ESRectExpandWithEdgeInsets(CGRect rect, UIEdgeInsets insets) {
        return UIEdgeInsetsInsetRect(rect, insets);
}

ES_INLINE CGRect ESRectExpandWithEdgeInsetsFrom(CGRect rect, CGFloat top, CGFloat left, CGFloat bottom, CGFloat right) {
        return ESRectExpandWithEdgeInsets(rect, UIEdgeInsetsMake(top, left, bottom, right));
}

/**
 * `return floorf((containerSize.width - size.width) / 2.f);`
 */
ES_INLINE CGFloat ESSizeCenterX(CGSize containerSize, CGSize size) {
        return floorf((containerSize.width - size.width) / 2.f);
}

/**
 * `return floorf((containerSize.height - size.height) / 2.f);`
 */
ES_INLINE CGFloat ESSizeCenterY(CGSize containerSize, CGSize size) {
        return floorf((containerSize.height - size.height) / 2.f);
}

ES_EXTERN CGRect ESFrameOfCenteredViewWithinView(UIView *view, UIView *containerView);

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

ES_EXTERN BOOL ESIsRetinaScreen(void);

/**
 * Returns an `UIImage` instance using `+[UIImage imageNamed:]` method.
 * App bundle could includes only `@2x` high resolution images, this method will
 * return correct `scaled` image for normal resolution device such as iPad mini 1th.
 * 
 * + Standard: `<ImageName><device_modifier>.<filename_extension>`
 * + High resolution: `<ImageName>@2x<device_modifier>.<filename_extension>`
 *
 * The `<device_modifier>` portion is optional and contains either the string `~ipad` or `~iphone`
 *
 * @see https://developer.apple.com/library/ios/documentation/2DDrawing/Conceptual/DrawingPrintingiOS/SupportingHiResScreensInViews/SupportingHiResScreensInViews.html#//apple_ref/doc/uid/TP40010156-CH15-SW8
 */
ES_EXTERN UIImage *UIImageFromCache(NSString *path, ...);
/**
 * Returns a new `UIImage` instance.
 *
 * The `path` specification is the same as `UIImageFromCache(NSString *)`, as well as `+[UIImage imageNamed:]`.
 */
ES_EXTERN UIImage *UIImageFrom(NSString *path, ...);

ES_EXTERN NSString *NSStringWith(NSString *format, ...);
/**
 * It can handle 'xxxx:[//]' or a file path.
 */
ES_EXTERN NSURL *NSURLWith(NSString *format, ...);

/**
 * Creates a mutable set which does not retain references to the objects it contains.
 */
ES_EXTERN NSMutableSet *ESCreateNonretainedMutableSet(void);
ES_EXTERN NSMutableArray *ESCreateNonretainedMutableArray(void);
ES_EXTERN NSMutableDictionary *ESCreateNonretainedMutableDictionary(void);

#pragma mark - Path

ES_EXTERN NSString *ESPathForBundleResource(NSBundle *bundle, NSString *relativePath, ...);
ES_EXTERN NSString *ESPathForMainBundleResource(NSString *relativePath, ...);
ES_EXTERN NSString *ESPathForESFWBundleResource(NSString *relativePath, ...);
ES_EXTERN NSString *ESPathForDocuments(void);
ES_EXTERN NSString *ESPathForDocumentsResource(NSString *relativePath, ...);
ES_EXTERN NSString *ESPathForLibrary(void);
ES_EXTERN NSString *ESPathForLibraryResource(NSString *relativePath, ...);
ES_EXTERN NSString *ESPathForCaches(void);
ES_EXTERN NSString *ESPathForCachesResource(NSString *relativePath, ...);
ES_EXTERN NSString *ESPathForTemporary(void);
ES_EXTERN NSString *ESPathForTemporaryResource(NSString *relativePath, ...);
/// Create the `dir`  if it doesn't exist
ES_EXTERN BOOL ESTouchDirectory(NSString *dir);
/// Create directories if it doesn't exist, returns `nil` if failed.
ES_EXTERN NSString *ESTouchFilePath(NSString *filePath, ...);

#pragma mark - Dispatch & Block

typedef void (^ESBasicBlock)(void);
typedef void (^ESErrorBlock)(NSError *error);
typedef void (^ESHandlerBlock)(id sender);

ES_EXTERN void ESDispatchSyncOnMainThread(dispatch_block_t block);
ES_EXTERN void ESDispatchAsyncOnMainThread(dispatch_block_t block);
ES_EXTERN void ESDispatchOnGlobalQueue(dispatch_queue_priority_t priority, dispatch_block_t block);
ES_EXTERN void ESDispatchOnDefaultQueue(dispatch_block_t block);
ES_EXTERN void ESDispatchOnHighQueue(dispatch_block_t block);
ES_EXTERN void ESDispatchOnLowQueue(dispatch_block_t block);
ES_EXTERN void ESDispatchOnBackgroundQueue(dispatch_block_t block);

/**
 * After `delayTime`, dispatch `block` on the main thread.
 */
ES_EXTERN void ESDispatchAfter(NSTimeInterval delayTime, dispatch_block_t block);

#pragma mark - Selector
/**
 * e.g.
 *
 *	 + (void)load {
 *	        @autoreleasepool {
 *	                ESSwizzleInstanceMethod([self class], @selector(viewDidLoad), @selector(viewDidLoad_new));
 *	        }
 *	 }
 */
/**
 * Swizzle instance method.
 */
ES_EXTERN void ESSwizzleInstanceMethod(Class c, SEL orig, SEL new);
/**
 * Swizzle class method.
 * @see ESSwizzleInstanceMethod(Class c, SEL orig, SEL new);
 */
ES_EXTERN void ESSwizzleClassMethod(Class c, SEL orig, SEL new);

/**
 * Constructs an NSInvocation for a class target or an instance target.
 *
 *      NSInvocation *invocation = ESInvocation(self, @selector(foo:));
 *      NSInvocation *invocation = ESInvocation([self class], @selector(classMethod:));
 *
 */
ES_EXTERN NSInvocation *ESInvocationWith(id target, SEL selector);

/**
 * Call a selector with unknown numbers of arguments.
 *
 * 	 // trun off compiler warning if there is.
 * 	#pragma clang diagnostic push
 * 	#pragma clang diagnostic ignored "-Wundeclared-selector"
 *
 * 	 ESInvokeSelector(self, @selector(test), NULL);
 *
 * 	 NSInteger result = 0;
 * 	 ESInvokeSelector([Foo class], @selector(classMethod:), &result, CGSizeMake(10, 20));
 *
 * 	 if (ESInvokeSelector(someObject, @selector(someSelector:::), NULL, arg1, arg2, arg3)) {
 * 	        // Invoked OK
 * 	 }
 *
 * 	#pragma clang diagnostic pop
 *
 */
ES_EXTERN BOOL ESInvokeSelector(id target, SEL selector, void *result, ...);

///========================================================================================================
/// @name NSObject(ESAssociatedObject)
///========================================================================================================
#pragma mark - NSObject(ESAssociatedObject)
/**
 * NSObject(ESAssociatedObject)
 * 
 * Get/Set associated objects. It's useful to add properties to a class's category.
 *
 * 	 @interface SomeClass (additions)
 * 	 @property (nonatomic, es_weak_property) __es_weak id<SomeDelegate> delegate;
 * 	 @property (nonatomic, strong) UIView *view;
 * 	 @end
 *
 * 	 // SomeClass+additions.m
 *
 * 	 static char _delegateKey;
 * 	 // OR
 * 	 static const void *_viewKey = &_viewKey;
 *
 * 	 @implementation SomeClass (additions)
 * 	 - (id<SomeDelegate>)delegate
 * 	 {
 * 	        return [self getAssociatedObject:&_delegateKey];
 * 	 }
 * 	 - (void)setDelegate:(id<SomeDelegate>)delegate
 * 	 {
 * 	        [self setAssociatedObject_nonatomic_weak:delegate key:&_delegateKey];
 * 	 }
 * 	 - (UIView *)view
 * 	 {
 * 	        return [self getAssociatedObject:_viewKey];
 * 	 }
 * 	 - (void)setView:(UIView *)view
 * 	 {
 * 	        [self setAssociatedObject_nonatomic_retain:view key:_viewKey];
 * 	 }
 * 	 @end
 *
 */
@interface NSObject (ESAssociatedObject)
- (id)getAssociatedObject:(const void *)key;
+ (id)getAssociatedObject:(const void *)key;
/// Since `OBJC_ASSOCIATION_ASSIGN` is not a `zeroing weak references`.
- (void)setAssociatedObject_nonatomic_weak:(__es_weak id)weakObject key:(const void *)key;
+ (void)setAssociatedObject_nonatomic_weak:(__es_weak id)weakObject key:(const void *)key;
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

///========================================================================================================
/// @name Notification with block
///========================================================================================================
#pragma mark - Notification with block
/**
 * Notification with block
 */
typedef void (^ESNotificationHandler)(NSNotification *notification, NSDictionary *userInfo);
@interface NSObject (ESObserver)
/**
 * Add `self` to `NSNotificationCenter` as an observer.
 * `handler` may be `nil` to stop handling the notification.
 * If `handler` and `name` both are `nil`, it will remove all observers from `NSNotificationCenter`.
 */
- (void)addNotification:(NSString *)name handler:(ESNotificationHandler)handler;
@end

///========================================================================================================
/// @name NSUserDefaults+ESHelper
///========================================================================================================
#pragma mark - NSUserDefaults+ESHelper
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

#endif // ESFramework_ESDefines_h
