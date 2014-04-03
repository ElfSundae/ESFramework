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

NSString *const ESFrameworkVersion = @"0.1.0";

NSInteger ESMaxLogLevel = ESLOGLEVEL_INFO;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
UIColor *UIColorFromRGBHexString(NSString *hexString)
{
        unsigned rgbValue = 0;
        if ([hexString isKindOfClass:[NSString class]]) {
                NSScanner *scanner = [NSScanner scannerWithString:hexString];
                if (6 == hexString.length) {
                        [scanner scanHexInt:&rgbValue];
                } else if (7 == hexString.length) {
                        [scanner setScanLocation:1]; // bypass '#' character
                        [scanner scanHexInt:&rgbValue];
                }
        }
        return UIColorFromRGBHex(rgbValue);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Dispatch
void es_dispatchSyncOnMainThread(dispatch_block_t block)
{
        if ([NSThread isMainThread]) {
                block();
        } else {
                dispatch_sync(dispatch_get_main_queue(), block);
        }
}

void es_dispatchAsyncOnMainThread(dispatch_block_t block)
{
        if ([NSThread isMainThread]) {
                block();
        } else {
                dispatch_async(dispatch_get_main_queue(), block);
        }
}

void es_dispatchAsyncOnGlobalQueue(dispatch_queue_priority_t priority, dispatch_block_t block)
{
        dispatch_async(dispatch_get_global_queue(priority, 0), block);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Selector
void es_swizzleClassMethod(Class c, SEL orig, SEL new)
{
        Method origMethod = class_getClassMethod(c, orig);
        Method newMethod = class_getClassMethod(c, new);
        if(class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
                class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
        } else {
                method_exchangeImplementations(origMethod, newMethod);
        }
}

void es_swizzleInstanceMethod(Class c, SEL orig, SEL new)
{
        Method origMethod = class_getInstanceMethod(c, orig);
        Method newMethod = class_getInstanceMethod(c, new);
        if(class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
                class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
        } else {
                method_exchangeImplementations(origMethod, newMethod);
        }
}

void es_invokeSelector(id target, SEL selector, NSArray *arguments)
{
        //TODO: check if it's a instance method or not.
        if (!arguments || !arguments.count) {
                return;
        }
        
        NSMethodSignature *signature = [target methodSignatureForSelector:selector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:target];
        [invocation setSelector:selector];
        // The first two arguments are the hidden arguments self and _cmd
        NSUInteger numberOfArgs = signature.numberOfArguments - 2;
        if (numberOfArgs > arguments.count) {
                // no enough arguments in the array
                return;
        }
        
        for (int i = 0; i < numberOfArgs; i++) {
                id arg = [arguments objectAtIndex:i];
                // The first two arguments are the hidden arguments self and _cmd
                [invocation setArgument:&arg atIndex:i+2];
        }
        
        [invocation invoke];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Common values

CGFloat ESStatusBarHeight(void)
{
        CGRect frame = [UIApplication sharedApplication].statusBarFrame;
        // Avoid having to check the status bar orientation.
        return MIN(frame.size.width, frame.size.height);
}

NSLocale *ESCurrentLocale(void)
{
        static NSLocale *_currentLocale;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                NSArray *languages = [NSLocale preferredLanguages];
                NSString *currentLang = [languages firstObject];
                if (currentLang) {
                        _currentLocale = [[NSLocale alloc] initWithLocaleIdentifier:currentLang];
                } else {
                        _currentLocale = [NSLocale currentLocale];
                }
        });
        return _currentLocale;
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

BOOL ESDeviceOSVersionIsAbove7(void)
{
        return (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1);
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
        return ESPathForBundleResource(nil, relativePath);
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