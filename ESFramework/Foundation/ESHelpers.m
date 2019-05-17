//
//  ESHelpers.m
//  ESFramework
//
//  Created by Elf Sundae on 2019/04/23.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import "ESHelpers.h"
#import <sys/time.h>
#import <Security/SecRandom.h>
#import "NSNumber+ESAdditions.h"
#import "NSString+ESAdditions.h"
#import "NSInvocation+ESHelper.h"

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

BOOL ESOSVersionIsAtLeast(NSInteger majorVersion)
{
    return [NSProcessInfo.processInfo isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion) {majorVersion}];
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

void ESBenchmark(NS_NOESCAPE void (^block)(void), NS_NOESCAPE void (^completion)(double elapsedMillisecond))
{
    struct timeval begin, end;
    gettimeofday(&begin, NULL);
    block();
    gettimeofday(&end, NULL);
    completion((double)(end.tv_sec - begin.tv_sec) * 1000 + (double)(end.tv_usec - begin.tv_usec) / 1000);
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

NSURL * _Nullable ESURLValue(id _Nullable obj)
{
    if ([obj isKindOfClass:[NSURL class]]) {
        return (NSURL *)obj;
    } else if (ESIsStringWithAnyText(obj)) {
        return [NSURL URLWithString:(NSString *)obj];
    } else {
        return nil;
    }
}

BOOL ESIsStringWithAnyText(id object)
{
    return [object isKindOfClass:[NSString class]] && [(NSString *)object length] > 0;
}

BOOL ESIsArrayWithItems(id object)
{
    return [object isKindOfClass:[NSArray class]] && [(NSArray *)object count] > 0;
}

BOOL ESIsDictionaryWithItems(id object)
{
    return [object isKindOfClass:[NSDictionary class]] && [(NSDictionary *)object count] > 0;
}

BOOL ESIsSetWithItems(id object)
{
    return [object isKindOfClass:[NSSet class]] && [(NSSet *)object count] > 0;
}

BOOL ESIsOrderedSetWithItems(id object)
{
    return [object isKindOfClass:[NSOrderedSet class]] && [(NSOrderedSet *)object count] > 0;
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

NSString *ESUUIDString(void)
{
    return NSUUID.UUID.UUIDString;
}

uint32_t ESRandomNumber(uint32_t min, uint32_t max)
{
    if (min > max) {
        uint32_t t = min; min = max; max = t;
    }
    return arc4random_uniform(max - min + 1) + min;
}

NSData *ESRandomDataOfLength(NSUInteger length)
{
    NSMutableData *data = [NSMutableData dataWithLength:length];
    int result = SecRandomCopyBytes(kSecRandomDefault, (size_t)length, data.mutableBytes);
    if (0 != result) {
        printf("%s: Unable to generate random data.\n", __PRETTY_FUNCTION__);
    }
    return [data copy];
}

UIColor *ESRandomColor(void)
{
    return [UIColor colorWithRed:(CGFloat)arc4random() / UINT_MAX
                           green:(CGFloat)arc4random() / UINT_MAX
                            blue:(CGFloat)arc4random() / UINT_MAX
                           alpha:1.0];
}

CGFloat ESDegreesToRadians(CGFloat degrees)
{
    return (degrees * M_PI / 180);
}

CGFloat ESRadiansToDegrees(CGFloat radians)
{
    return (radians * 180 / M_PI);
}

NSString *ESRandomStringOfLength(NSUInteger length)
{
    NSData *data = ESRandomDataOfLength(length);
    NSString *string = [data base64EncodedStringWithOptions:0];
    string = [string stringByDeletingCharactersInString:@"+/="];
    NSUInteger stringLength = string.length;
    if (stringLength >= length) {
        return [string substringToIndex:length];
    }

    NSMutableString *result = string.mutableCopy;
    for (NSUInteger i = stringLength; i < length; i++) {
        [result appendFormat:@"%c", [string characterAtIndex:arc4random_uniform((uint32_t)stringLength)]];
    }
    return [result copy];
}

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

NSString *ESScreenSizeString(CGSize size)
{
    return [NSString stringWithFormat:@"%dx%d",
            (int)fmin(size.width, size.height),
            (int)fmax(size.width, size.height)];
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

#pragma mark - ObjC Runtime

void ESSwizzleInstanceMethod(Class c, SEL orig, SEL new)
{
    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod = class_getInstanceMethod(c, new);
    if (class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, newMethod);
    }
}

void ESSwizzleClassMethod(Class c, SEL orig, SEL new)
{
    c = object_getClass((id)c);
    Method origMethod = class_getClassMethod(c, orig);
    Method newMethod = class_getClassMethod(c, new);
    if (class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, newMethod);
    }
}

BOOL ESInvokeSelector(id target, SEL selector, void *result, ...)
{
    va_list arguments;
    va_start(arguments, result);
    NSInvocation *invocation = [NSInvocation invocationWithTarget:target selector:selector retainArguments:NO arguments:arguments];
    va_end(arguments);
    if (invocation) {
        [invocation invoke];
        if (result && 0 != strcmp(invocation.methodSignature.methodReturnType, @encode(void))) {
            [invocation getReturnValue:result];
        }
        return YES;
    }
    return NO;
}
