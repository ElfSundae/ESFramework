//
//  ESDefines.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-3.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import "ESDefines.h"
#import <objc/runtime.h>

#if !__es_arc_enabled
#error "ESFramework requires ARC support."
#endif
#if !__has_feature(objc_instancetype)
#error "ESFramework requires Xcode5 to build."
#endif

NSString *const ESFrameworkVersion = @"0.1.0";

NSInteger ESMaxLogLevel = ESLOGLEVEL_INFO;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIColor

UIColor *UIColorWithRGBA(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha)
{
        return [UIColor colorWithRed:red/255.f green:green/255.f blue:blue/255.f alpha:alpha];
}

UIColor *UIColorWithRGB(CGFloat red, CGFloat green, CGFloat blue)
{
        return UIColorWithRGBA(red, green, blue, 1.f);
}

UIColor *UIColorWithRGBAHex(NSInteger rgbValue, CGFloat alpha)
{
        return UIColorWithRGBA((CGFloat)((rgbValue & 0xFF0000) >> 16), (CGFloat)((rgbValue & 0xFF00) >> 8), (CGFloat)(rgbValue & 0xFF), alpha);
}

UIColor *UIColorWithRGBHex(NSInteger rgbValue)
{
        return UIColorWithRGBAHex(rgbValue, 1.f);
}

UIColor *UIColorWithHexString(NSString *hexString, CGFloat alpha)
{
        unsigned rgbValue = 0;
        if ([hexString isKindOfClass:[NSString class]]) {
                NSScanner *scanner = [NSScanner scannerWithString:hexString];
                if (6 == hexString.length) {
                        [scanner scanHexInt:&rgbValue];
                } else if (7 == hexString.length) {
                        [scanner setScanLocation:1]; // bypass '#' character
                        [scanner scanHexInt:&rgbValue];
                } else if (8 == hexString.length) {
                        [scanner setScanLocation:2]; //bypass '0x'
                        [scanner scanHexInt:&rgbValue];
                }
        }
        return UIColorWithRGBAHex(rgbValue, alpha);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - SDK Compatibility

NSString *ESDeviceOSVersion(void)
{
        static NSString *_deviceOSVersion = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                _deviceOSVersion = [[UIDevice currentDevice] systemVersion];
        });
        return _deviceOSVersion;
}

BOOL ESDeviceOSVersionIsAtLeast(double versionNumber)
{
        return (floor(NSFoundationVersionNumber) >= versionNumber);
}

BOOL ESDeviceOSVersionIsAbove(double versionNumber)
{
        return (floor(NSFoundationVersionNumber) > versionNumber);
}

BOOL ESDeviceOSVersionIsAbove7(void)
{
        return ESDeviceOSVersionIsAbove(NSFoundationVersionNumber_iOS_6_1);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 
CGFloat ESStatusBarHeight(void)
{
        CGRect frame = [UIApplication sharedApplication].statusBarFrame;
        // Avoid having to check the status bar orientation.
        return MIN(frame.size.width, frame.size.height);
}

CGFloat ESDegreesToRadians(CGFloat degrees)
{
        return (degrees * M_PI / 180.0);
}

CGFloat ESRadiansToDegrees(CGFloat radians)
{
        return (radians * 180.0 / M_PI);
}

BOOL ESIsPadUI(void)
{
        static BOOL _isPad;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                _isPad = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
        });
        return _isPad;
}

BOOL ESIsPadDevice(void)
{
        static BOOL _isPadDevice;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                _isPadDevice = ([[UIDevice currentDevice].model rangeOfString:@"iPad" options:NSCaseInsensitiveSearch].location != NSNotFound);
        });
        return _isPadDevice;
}

BOOL ESIsPhoneUI(void)
{
        static BOOL _isPhone;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                _isPhone = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone);
        });
        return _isPhone;
}

BOOL ESIsPhoneDevice(void)
{
        static BOOL _isPhoneDevice;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                NSString *model = [UIDevice currentDevice].model;
                _isPhoneDevice = ([model rangeOfString:@"iPhone" options:NSCaseInsensitiveSearch].location != NSNotFound ||
                                  [model rangeOfString:@"iPod" options:NSCaseInsensitiveSearch].location != NSNotFound);
        });
        return _isPhoneDevice;
}

NSMutableSet *ESCreateNonretainedMutableSet(void)
{
        return CFBridgingRelease(CFSetCreateMutable(NULL, 0, NULL));
}

NSMutableArray *ESCreateNonretainedMutableArray(void)
{
        return CFBridgingRelease(CFArrayCreateMutable(NULL, 0, NULL));
}

NSMutableDictionary *ESCreateNonretainedMutableDictionary(void)
{
        return CFBridgingRelease(CFDictionaryCreateMutable(NULL, 0, NULL, NULL));
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Path

NSString *ESPathForBundleResource(NSBundle *bundle, NSString *relativePath)
{
        NSBundle *b = bundle ?: [NSBundle mainBundle];
        return [[b resourcePath] stringByAppendingPathComponent:relativePath];
}

NSString *ESPathForMainBundleResource(NSString *relativePath)
{
        return ESPathForBundleResource([NSBundle mainBundle], relativePath);
}

NSString *ESPathForDocuments(void)
{
        static NSString *docs = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                docs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        });
        return docs;
}

NSString *ESPathForDocumentsResource(NSString *relativePath)
{
        return [ESPathForDocuments() stringByAppendingPathComponent:relativePath];
}

NSString *ESPathForLibrary(void)
{
        static NSString *lib = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                lib = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
        });
        return lib;
}

NSString *ESPathForLibraryResource(NSString *relativePath)
{
        return [ESPathForLibrary() stringByAppendingPathComponent:relativePath];
}

NSString *ESPathForCaches(void)
{
        static NSString *caches = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                caches = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        });
        return caches;
}

NSString *ESPathForCachesResource(NSString *relativePath)
{
        return [ESPathForCaches() stringByAppendingPathComponent:relativePath];
}

NSString *ESPathForTemporary(void)
{
        return NSTemporaryDirectory();
}

NSString *ESPathForTemporaryResource(NSString *relativePath)
{
        return [ESPathForTemporary() stringByAppendingPathComponent:relativePath];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Dispatch
void ESDispatchSyncOnMainThread(dispatch_block_t block)
{
        if ([NSThread isMainThread]) {
                block();
        } else {
                dispatch_sync(dispatch_get_main_queue(), block);
        }
}

void ESDispatchAsyncOnMainThread(dispatch_block_t block)
{
        if ([NSThread isMainThread]) {
                block();
        } else {
                dispatch_async(dispatch_get_main_queue(), block);
        }
}

void ESDispatchAsyncOnGlobalQueue(dispatch_queue_priority_t priority, dispatch_block_t block)
{
        dispatch_async(dispatch_get_global_queue(priority, 0), block);
}

void ESDispatchAfter(NSTimeInterval delayTime, dispatch_block_t block)
{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)),
                       dispatch_get_main_queue(),
                       block);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Selector
void ESSwizzleClassMethod(Class c, SEL orig, SEL new)
{
        Method origMethod = class_getClassMethod(c, orig);
        Method newMethod = class_getClassMethod(c, new);
        if(class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
                class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
        } else {
                method_exchangeImplementations(origMethod, newMethod);
        }
}

void ESSwizzleInstanceMethod(Class c, SEL orig, SEL new)
{
        Method origMethod = class_getInstanceMethod(c, orig);
        Method newMethod = class_getInstanceMethod(c, new);
        if(class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
                class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
        } else {
                method_exchangeImplementations(origMethod, newMethod);
        }
}

NSInvocation *ESInvocationWith(id target, SEL selector)
{
        NSMethodSignature *signature = [target methodSignatureForSelector:selector];
        if (!signature) {
                return nil;
        }
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:target];
        [invocation setSelector:selector];
        return invocation;
}

id ESInvokeSelector(id target, SEL selector, id arguments, ...)
{
        NSInvocation *invocation = ESInvocationWith(target, selector);
        NSCAssert(invocation, @"Constructing NSInvocation error.");
        
        NSInteger argIndex = 2;
        if (arguments) {
                va_list argsList;
                va_start(argsList, arguments);
                id eachArg = arguments;
                do {
                        [invocation setArgument:&eachArg atIndex:argIndex++];
                } while ((eachArg = va_arg(argsList, id)));
                va_end(argsList);
        }
        
        [invocation invoke];
        
        const char *returnType = invocation.methodSignature.methodReturnType;
        if (0 != strcmp(returnType, @encode(void))) {
                __autoreleasing id result = nil;
                [invocation getReturnValue:&result];
                return result;
        }
        return nil;
}

