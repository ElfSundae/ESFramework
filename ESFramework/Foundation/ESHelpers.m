//
//  ESHelpers.m
//  ESFramework
//
//  Created by Elf Sundae on 2019/04/23.
//  Copyright © 2014-2020 https://0x123.com All rights reserved.
//

#import "ESHelpers.h"
#import <objc/runtime.h>
#import <sys/time.h>
#import <Security/SecRandom.h>
#import "ESNumericValue.h"
#import "NSInvocation+ESExtension.h"

BOOL ESOSVersionIsAtLeast(NSInteger majorVersion, NSInteger minorVersion)
{
    return [NSProcessInfo.processInfo isOperatingSystemAtLeastVersion:
            (NSOperatingSystemVersion) { majorVersion, minorVersion }];
}

extern uint64_t dispatch_benchmark(size_t count, void (^block)(void));

uint64_t ESBenchmark(size_t count, void (^block)(void))
{
    return dispatch_benchmark(count, block);
}

uint32_t ESRandomNumber(uint32_t min, uint32_t max)
{
    return arc4random_uniform(max - min + 1) + min;
}

NSString *ESUniqueNumericIdentifier(void)
{
    static size_t len = (size_t)(sizeof(ULONG_MAX) * CHAR_BIT * 0.302) + 3;

    char str[len];
    sprintf(str, "%lu%02u%03u",
            (unsigned long)CFAbsoluteTimeGetCurrent(),
            arc4random_uniform(100),
            arc4random_uniform(1000));

    return [NSString stringWithCString:str encoding:NSUTF8StringEncoding];
}

NSString * _Nullable ESRandomString(NSUInteger length)
{
    static char charset[] = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    static uint32_t charsetLen = (uint32_t)(sizeof(charset) - 1);

    char *str = malloc(length + 1);
    if (!str) {
        return nil;
    }

    for (NSUInteger i = 0; i < length; i++) {
        str[i] = charset[arc4random_uniform(charsetLen)];
    }
    str[length] = '\0';

    NSString *string = [NSString stringWithCString:str encoding:NSUTF8StringEncoding];
    free(str);

    return string;
}

NSData * _Nullable ESRandomData(NSUInteger length)
{
    unsigned char buffer[length];
    int result = SecRandomCopyBytes(kSecRandomDefault, (size_t)length, buffer);
    if (0 != result) {
        return nil;
    }
    return [NSData dataWithBytes:buffer length:length];
}

CGFloat ESDegreesToRadians(CGFloat degrees)
{
    return (degrees * M_PI / 180.0);
}

CGFloat ESRadiansToDegrees(CGFloat radians)
{
    return (radians * 180.0 / M_PI);
}

NSURL *ESAppStoreURL(id appIdentifier)
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"https://apps.apple.com/app/id%@", ESStringValue(appIdentifier)]];
}

NSURL *ESAppStoreDirectURL(id appIdentifier)
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://apps.apple.com/app/id%@", ESStringValue(appIdentifier)]];
}

NSURL *ESAppStoreReviewURL(id appIdentifier)
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://apps.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", ESStringValue(appIdentifier)]];
}

NSString *ESDocumentDirectory(void)
{
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
}

NSString *ESDocumentPath(NSString *pathComponent)
{
    return [ESDocumentDirectory() stringByAppendingPathComponent:pathComponent];
}

NSURL *ESDocumentDirectoryURL(void)
{
    return [NSFileManager.defaultManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
}

NSURL *ESDocumentURL(NSString *pathComponent, BOOL isDirectory)
{
    return [ESDocumentDirectoryURL() URLByAppendingPathComponent:pathComponent isDirectory:isDirectory];
}

NSString *ESLibraryDirectory(void)
{
    return NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
}

NSString *ESLibraryPath(NSString *pathComponent)
{
    return [ESLibraryDirectory() stringByAppendingPathComponent:pathComponent];
}

NSURL *ESLibraryDirectoryURL(void)
{
    return [NSFileManager.defaultManager URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask].firstObject;
}

NSURL *ESLibraryURL(NSString *pathComponent, BOOL isDirectory)
{
    return [ESLibraryDirectoryURL() URLByAppendingPathComponent:pathComponent isDirectory:isDirectory];
}

NSString *ESCachesDirectory(void)
{
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
}

NSString *ESCachesPath(NSString *pathComponent)
{
    return [ESCachesDirectory() stringByAppendingPathComponent:pathComponent];
}

NSURL *ESCachesDirectoryURL(void)
{
    return [NSFileManager.defaultManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask].firstObject;
}

NSURL *ESCachesURL(NSString *pathComponent, BOOL isDirectory)
{
    return [ESCachesDirectoryURL() URLByAppendingPathComponent:pathComponent isDirectory:isDirectory];
}

NSString *ESTemporaryDirectory(void)
{
    return NSTemporaryDirectory();
}

NSString *ESTemporaryPath(NSString *pathComponent)
{
    return [ESTemporaryDirectory() stringByAppendingPathComponent:pathComponent];
}

NSURL *ESTemporaryDirectoryURL(void)
{
    return [NSURL fileURLWithPath:ESTemporaryDirectory() isDirectory:YES];
}

NSURL *ESTemporaryURL(NSString *pathComponent, BOOL isDirectory)
{
    return [ESTemporaryDirectoryURL() URLByAppendingPathComponent:pathComponent isDirectory:isDirectory];
}

void ESSwizzleInstanceMethod(Class class, SEL originalSelector, SEL swizzledSelector)
{
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    if (class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

void ESSwizzleClassMethod(Class class, SEL originalSelector, SEL swizzledSelector)
{
    class = object_getClass(class);
    Method originalMethod = class_getClassMethod(class, originalSelector);
    Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
    if (class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

BOOL ESInvokeSelector(id target, SEL selector, void *result, ...)
{
    va_list arguments;
    va_start(arguments, result);
    NSInvocation *invocation = [NSInvocation invocationWithTarget:target selector:selector arguments:arguments];
    va_end(arguments);

    if (!invocation) {
        return NO;
    }

    [invocation retainArguments];
    [invocation invoke];

    if (result && 0 != strcmp(invocation.methodSignature.methodReturnType, @encode(void))) {
        [invocation getReturnValue:result];
    }

    return YES;
}

#if TARGET_OS_IOS || TARGET_OS_TV

UIColor *ESRandomColor(void)
{
    return [UIColor colorWithRed:(CGFloat)arc4random() / UINT_MAX
                           green:(CGFloat)arc4random() / UINT_MAX
                            blue:(CGFloat)arc4random() / UINT_MAX
                           alpha:1.0];
}

UIColor *UIColorWithRGBA(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha)
{
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha];
}

UIColor *UIColorWithRGB(CGFloat red, CGFloat green, CGFloat blue)
{
    return UIColorWithRGBA(red, green, blue, 1.0);
}

UIColor *UIColorWithRGBHex(NSUInteger hex, CGFloat alpha)
{
    return [UIColor colorWithRed:(CGFloat)((hex & 0xFF0000) >> 16) / 255.0
                           green:(CGFloat)((hex & 0xFF00) >> 8) / 255.0
                            blue:(CGFloat)(hex & 0xFF) / 255.0
                           alpha:alpha];
}

UIColor *UIColorWithRGBHexString(NSString *hexString, CGFloat alpha)
{
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    if (7 == hexString.length) {
        scanner.scanLocation = 1; // bypass '#' char
    }
    unsigned int hex = 0;
    if (![scanner scanHexInt:&hex]) {
        return [UIColor clearColor];
    }
    return UIColorWithRGBHex(hex, alpha);
}

BOOL ESIsPadUI(void)
{
    return UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad;
}

BOOL ESIsPadDevice(void)
{
    return [UIDevice.currentDevice.model hasPrefix:@"iPad"];
}

BOOL ESIsPhoneUI(void)
{
    return UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone;
}

BOOL ESIsPhoneDevice(void)
{
    return ([UIDevice.currentDevice.model hasPrefix:@"iPhone"] ||
            [UIDevice.currentDevice.model hasPrefix:@"iPod"]);
}

BOOL ESIsRetinaScreen(void)
{
    return [UIScreen mainScreen].scale >= 2.0;
}

#endif // TARGET_OS_IOS || TARGET_OS_TV

#if TARGET_OS_IOS

CGFloat ESStatusBarHeight(void)
{
    CGRect frame = UIApplication.sharedApplication.statusBarFrame;
    return fmin(CGRectGetWidth(frame), CGRectGetHeight(frame));
};

UIInterfaceOrientation ESInterfaceOrientation(void)
{
    return [UIApplication sharedApplication].statusBarOrientation;
}

UIDeviceOrientation ESDeviceOrientation(void)
{
    return UIDevice.currentDevice.orientation;
}

CGAffineTransform ESRotateTransformForOrientation(UIInterfaceOrientation orientation)
{
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

#endif // TARGET_OS_IOS
