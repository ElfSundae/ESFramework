//
//  ESHelpers.m
//  ESFramework
//
//  Created by Elf Sundae on 2019/04/23.
//  Copyright © 2019 https://0x123.com. All rights reserved.
//

#import "ESHelpers.h"
#import <sys/time.h>
#import <Security/SecRandom.h>
#import "NSNumber+ESExtension.h"
#import "NSInvocation+ESExtension.h"

static NSNumber * _Nullable _ESNumberFromObject(id _Nullable obj)
{
    if ([obj isKindOfClass:[NSNumber class]]) {
        return (NSNumber *)obj;
    } else if ([obj isKindOfClass:[NSString class]]) {
        return [NSNumber numberWithString:(NSString *)obj];
    } else {
        return nil;
    }
}

char ESCharValue(id _Nullable obj)
{
    return [_ESNumberFromObject(obj) charValue];
}

unsigned char ESUCharValue(id _Nullable obj)
{
    return [_ESNumberFromObject(obj) unsignedCharValue];
}

short ESShortValue(id _Nullable obj)
{
    return [_ESNumberFromObject(obj) shortValue];
}

unsigned short ESUShortValue(id _Nullable obj)
{
    return [_ESNumberFromObject(obj) unsignedShortValue];
}

int ESIntValue(id _Nullable obj)
{
    return [_ESNumberFromObject(obj) intValue];
}

unsigned int ESUIntValue(id _Nullable obj)
{
    return [_ESNumberFromObject(obj) unsignedIntValue];
}

long ESLongValue(id _Nullable obj)
{
    return [_ESNumberFromObject(obj) longValue];
}

unsigned long ESULongValue(id _Nullable obj)
{
    return [_ESNumberFromObject(obj) unsignedLongValue];
}

long long ESLongLongValue(id _Nullable obj)
{
    return [_ESNumberFromObject(obj) longLongValue];
}

unsigned long long ESULongLongValue(id _Nullable obj)
{
    return [_ESNumberFromObject(obj) unsignedLongLongValue];
}

float ESFloatValue(id _Nullable obj)
{
    return [_ESNumberFromObject(obj) floatValue];
}

double ESDoubleValue(id _Nullable obj)
{
    return [_ESNumberFromObject(obj) doubleValue];
}

BOOL ESBoolValue(id _Nullable obj)
{
    return [_ESNumberFromObject(obj) boolValue];
}

NSInteger ESIntegerValue(id _Nullable obj)
{
    return [_ESNumberFromObject(obj) integerValue];
}

NSUInteger ESUIntegerValue(id _Nullable obj)
{
    return [_ESNumberFromObject(obj) unsignedIntegerValue];
}

NSString * _Nullable ESStringValue(id _Nullable obj)
{
    if ([obj isKindOfClass:[NSString class]]) {
        return (NSString *)obj;
    } else if ([obj isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)obj stringValue];
    } else {
        return nil;
    }
}

BOOL ESOSVersionIsAtLeast(NSInteger majorVersion, NSInteger minorVersion)
{
    return [NSProcessInfo.processInfo isOperatingSystemAtLeastVersion:
            (NSOperatingSystemVersion) { majorVersion, minorVersion }];
}

void ESMeasureExecution(NS_NOESCAPE void (^block)(void), NS_NOESCAPE void (^ _Nullable completion)(NSTimeInterval elapsedMillisecond))
{
    struct timeval begin, end;
    gettimeofday(&begin, NULL);
    block();
    gettimeofday(&end, NULL);
    NSTimeInterval ms = (NSTimeInterval)(end.tv_sec - begin.tv_sec) * 1000 + (NSTimeInterval)(end.tv_usec - begin.tv_usec) / 1000;
    if (completion) {
        completion(ms);
    } else {
        NSLog(@"‼️ Measure Execution Time: %f ms", ms);
    }
}

uint32_t ESRandomNumber(uint32_t min, uint32_t max)
{
    return arc4random_uniform(max - min + 1) + min;
}

NSString *ESUUIDString(void)
{
    return [NSUUID UUID].UUIDString;
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

    NSString *string = [NSString stringWithUTF8String:str];
    free(str);

    return string;
}

NSData * _Nullable ESRandomData(NSUInteger length)
{
    NSMutableData *data = [NSMutableData dataWithLength:length];
    int result = SecRandomCopyBytes(kSecRandomDefault, (size_t)length, data.mutableBytes);
    if (0 != result) {
        return nil;
    }
    return [data copy];
}

CGFloat ESDegreesToRadians(CGFloat degrees)
{
    return (degrees * M_PI / 180);
}

CGFloat ESRadiansToDegrees(CGFloat radians)
{
    return (radians * 180 / M_PI);
}

NSURL *ESAppLink(NSInteger appIdentifier)
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"https://apps.apple.com/app/id%ld", (long)appIdentifier]];
}

NSURL *ESAppStoreLink(NSInteger appIdentifier)
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://apps.apple.com/app/id%ld", (long)appIdentifier]];
}

NSURL *ESAppStoreReviewLink(NSInteger appIdentifier)
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://apps.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%ld", (long)appIdentifier]];
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
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:1.0];
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

NSString *ESScreenSizeString(CGSize size)
{
    return [NSString stringWithFormat:@"%dx%d",
#if TARGET_OS_IOS
            (int)fmin(size.width, size.height),
            (int)fmax(size.width, size.height)
#else
            (int)size.width, (int)size.height
#endif
    ];
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

#endif // TARGET_OS_IOS
