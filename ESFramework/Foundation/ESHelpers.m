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
#import "NSInvocation+ESHelper.h"

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

void ESBenchmark(void (^block)(void), void (^completion)(double elapsedMillisecond))
{
    struct timeval begin, end;
    gettimeofday(&begin, NULL);
    block();
    gettimeofday(&end, NULL);
    completion((double)(end.tv_sec - begin.tv_sec) * 1000 + (double)(end.tv_usec - begin.tv_usec) / 1000);
}

BOOL ESIsStringWithAnyText(id object)
{
    return ([object isKindOfClass:[NSString class]] && [(NSString *)object length] > 0);
}

BOOL ESIsArrayWithItems(id object)
{
    return ([object isKindOfClass:[NSArray class]] && [(NSArray *)object count] > 0);
}

BOOL ESIsDictionaryWithItems(id object)
{
    return ([object isKindOfClass:[NSDictionary class]] && [(NSDictionary *)object count] > 0);
}

BOOL ESIsSetWithItems(id object)
{
    return ([object isKindOfClass:[NSSet class]] && [(NSSet *)object count] > 0);
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
    int result = SecRandomCopyBytes(NULL, (size_t)length, data.mutableBytes);
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
                           alpha:1];
}

NSString *ESRandomStringOfLength(NSUInteger length)
{
    NSData *data = ESRandomDataOfLength(length);
    NSString *string = [data base64EncodedStringWithOptions:0];
    // Remove "+/="
    string = [[string componentsSeparatedByCharactersInSet:
               [NSCharacterSet characterSetWithCharactersInString:@"+/="]]
              componentsJoinedByString:@""];
    // base64 后的字符串长度是原串长度的大约135%， 去掉特殊字符后再检查字符串长度
    if (string.length == length) {
        return string;
    } else if (string.length > length) {
        return [string substringToIndex:length];
    } else {
        NSMutableString *result = string.mutableCopy;
        for (NSUInteger i = string.length; i < length; i++) {
            NSUInteger loc = ESRandomNumber(0, (uint32_t)string.length - 1);
            [result appendFormat:@"%c", [string characterAtIndex:loc]];
        }
        return [result copy];
    }
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
    return [UIDevice currentDevice].orientation;
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

CGFloat ESDegreesToRadians(CGFloat degrees)
{
    return (degrees * M_PI / 180);
}

CGFloat ESRadiansToDegrees(CGFloat radians)
{
    return (radians * 180 / M_PI);
}

BOOL ESIsPadUI(void)
{
    return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
}

BOOL ESIsPadDevice(void)
{
    return ([[UIDevice currentDevice].model rangeOfString:@"iPad" options:NSCaseInsensitiveSearch].location != NSNotFound);
}

BOOL ESIsPhoneUI(void)
{
    return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone);
}

BOOL ESIsPhoneDevice(void)
{
    return ([[UIDevice currentDevice].model rangeOfString:@"iPhone" options:NSCaseInsensitiveSearch].location != NSNotFound ||
            [[UIDevice currentDevice].model rangeOfString:@"iPod" options:NSCaseInsensitiveSearch].location != NSNotFound);
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

NSString *ESPathForDocuments(void)
{
    static NSString *docs = nil;
    static dispatch_once_t onceToken_DocumentsPath;
    dispatch_once(&onceToken_DocumentsPath, ^{
        docs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
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
    static dispatch_once_t onceToken_LibraryPath;
    dispatch_once(&onceToken_LibraryPath, ^{
        lib = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
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
    static dispatch_once_t onceToken_CachesPath;
    dispatch_once(&onceToken_CachesPath, ^{
        caches = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
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

BOOL ESTouchDirectory(NSString *directoryPath)
{
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir = NO;
    if ([fm fileExistsAtPath:directoryPath isDirectory:&isDir]) {
        if (isDir) {
            return YES;
        } else {
            [fm removeItemAtPath:directoryPath error:NULL];
        }
    }
    return [fm createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:NULL];
}

BOOL ESTouchDirectoryAtFilePath(NSString *filePath)
{
    return ESTouchDirectory([filePath stringByDeletingLastPathComponent]);
}

BOOL ESTouchDirectoryAtFileURL(NSURL *url)
{
    return ESTouchDirectoryAtFilePath(url.path);
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
