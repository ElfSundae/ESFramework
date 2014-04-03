//
//  ESDefines.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-2.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#ifndef ESFramework_ESDefines_h
#define ESFramework_ESDefines_h

#import <Foundation/Foundation.h>
@import UIKit;

FOUNDATION_EXTERN NSString *const ESFrameworkVersion;

/**
 * Mark method or property to deprecated.
 */
#if defined(__GNUC__) && (__GNUC__ >= 4) && defined(__APPLE_CC__) && (__APPLE_CC__ >= 5465)
#define __ES_DEPRECATED_ATTRIBUTE       __attribute__((deprecated))
#else
#define __ES_DEPRECATED_ATTRIBUTE
#endif

/**
 * A better NSLog.
 */
#ifdef DEBUG
#define NSLog(fmt, ...)		NSLog((@"%@ (%d) %s " fmt),[[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__)
#else
#define NSLog(fmt, ...)
#endif

#define ESLOGLEVEL_INFO     5
#define ESLOGLEVEL_WARNING  3
#define ESLOGLEVEL_ERROR    1
FOUNDATION_EXTERN NSInteger ESMaxLogLevel;

#undef NSLogCondition
#ifdef DEBUG
#define NSLogCondition(condition, fmt, ...) do { if((condition)){ NSLog(fmt, ##__VA_ARGS__); } } while(0)
#else
#define NSLogCondition(condition, fmt, ...) ((void)0)
#endif

#define NSLogPrefix(prefixString, fmt, ...)     NSLog(@""prefixString@""fmt, ##__VA_ARGS__)
#define NSLogInfo(fmt, ...)     do { if(ESLOGLEVEL_INFO <= ESMaxLogLevel){ NSLogPrefix(@"<Info> ", fmt, ##__VA_ARGS__); } } while(0)
#define NSLogWarning(fmt, ...)  do { if(ESLOGLEVEL_WARNING <= ESMaxLogLevel){ NSLogPrefix(@"<Warning>❗ ", fmt, ##__VA_ARGS__); } } while(0)
#define NSLogError(fmt, ...)    do { if(ESLOGLEVEL_ERROR <= ESMaxLogLevel){ NSLogPrefix(@"<Error>❌ ", fmt, ##__VA_ARGS__); } } while(0)


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
 * Weak object.
 */
#define __es_typeof(var)         __typeof(&*var)
#if __es_arc_enabled
        #define ES_WEAK_VAR(_var, _weak_var)    __es_weak __es_typeof(_var) _weak_var = _var
#else
        #define ES_WEAK_VAR(_var, _weak_var)    __block __es_typeof(_var) _weak_var = _var
#endif
#define ES_STRONG_VAR(_weak_var, _strong_var)        __es_typeof(_weak_var) _strong_var = _weak_var
#define ES_STRONG_VAR_CHECK_NULL(_weak_var, _strong_var)        ES_STRONG_VAR(_weak_var, _strong_var); if(!_strong_var) return;

/**
 * Check bit (flag)
 */
#define ES_IS_MASK_SET(value, flag)  (((value) & (flag)) == (flag))

/**
 * LocalizedString
 */
#define ESLocalizedString(s) NSLocalizedString(s,s)
#define ESLocalizedStringWithFormat(s, ...) [NSString stringWithFormat:NSLocalizedString(s,s),##__VA_ARGS__]


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


/**
 * Color helper
 */
#define UIColorFromRGBA(r,g,b,a)        [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define UIColorFromRGB(r,g,b)           UIColorFromRGBA(r,g,b,1.0f)
/**
 @code
 UIColorFromRGBAHex(0xCECECE, 0.8);
 @endcode
 */
#define UIColorFromRGBAHex(rgbValue,a)  UIColorFromRGBA( ((CGFloat)((rgbValue & 0xFF0000) >> 16)), ((CGFloat)((rgbValue & 0xFF00) >> 8)), ((CGFloat)(rgbValue & 0xFF)), a)
#define UIColorFromRGBHex(rgbValue)     UIColorFromRGBAHex(rgbValue, 1.0f)

#if defined(__cplusplus)
extern "C" {
#endif
        /**
         @code
         UIColorFromHexString(@"#33AF00");
         UIColorFromHexString(@"33AF00");
         @endcode
         */
        UIColor *UIColorFromRGBHexString(NSString *hexString);
        
        /**
         * Dispatch
         */
        void es_dispatchSyncOnMainThread(dispatch_block_t block);
        void es_dispatchAsyncOnMainThread(dispatch_block_t block);
        void es_dispatchAsyncOnGlobalQueue(dispatch_queue_priority_t priority, dispatch_block_t block);
        
        /**
         * Swizzle class method.
         */
        void es_swizzleClassMethod(Class c, SEL orig, SEL new);
        /**
         * Swizzle instance method.
         */
        void es_swizzleInstanceMethod(Class c, SEL orig, SEL new);
        /**
         * Call a selector with unknown number of arguments.
         *
         * @warning: Only for instance method.
         */
        void es_invokeSelector(id target, SEL selector, NSArray *arguments);
        
        /**
         * Common values
         */
        CGFloat ESStatusBarHeight(void);
        
        /**
         * Path
         */
        NSString *ESPathForBundleResource(NSBundle *bundle, NSString *relativePath);
        NSString *ESPathForMainBundleResource(NSString *relativePath);
        NSString *ESPathForDocuments(void);
        NSString *ESPathForDocumentsResource(NSString *relativePath);
        NSString *ESPathForLibrary(void);
        NSString *ESPathForLibraryResource(NSString *relativePath);
        NSString *ESPathForCaches(void);
        NSString *ESPathForCachesResource(NSString *relativePath);
        NSString *ESPathForTemporary(void);
        NSString *ESPathForTemporaryResource(NSString *relativePath);
        
#if defined(__cplusplus)
}
#endif



#endif // ESFramework_ESDefines_h
