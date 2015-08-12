//
//  ESDefines.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-3.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESDefines.h"

ES_CATEGORY_FIX(ESDefines)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - SDK Compatibility

NSString *ESOSVersion(void)
{
        static NSString *_deviceOSVersion = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                _deviceOSVersion = [[UIDevice currentDevice] systemVersion];
        });
        return _deviceOSVersion;
}

BOOL ESOSVersionIsAtLeast(double versionNumber)
{
        return (NSFoundationVersionNumber >= versionNumber);
}

BOOL ESOSVersionIsAbove(double versionNumber)
{
        return (NSFoundationVersionNumber > versionNumber);
}

BOOL ESOSVersionIsAbove7(void)
{
        return ESOSVersionIsAbove(NSFoundationVersionNumber_iOS_6_1);
}

BOOL ESOSVersionIsAbove8(void)
{
        return ESOSVersionIsAbove(NSFoundationVersionNumber_iOS_7_1);
}

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

UIColor *UIColorWithRGBAHexString(NSString *hexString, CGFloat alpha)
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
#pragma mark - 

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
        return data;
}

UIColor *ESRandomColor(void)
{
        return [UIColor colorWithRed:(CGFloat)arc4random()/UINT_MAX
                               green:(CGFloat)arc4random()/UINT_MAX
                                blue:(CGFloat)arc4random()/UINT_MAX
                               alpha:1.f];
}

NSString *ESRandomStringOfLength(NSUInteger length)
{
        NSData *data = ESRandomDataOfLength(length);
        NSString *string = nil;
        // Base64
        if ([data respondsToSelector:@selector(base64EncodedStringWithOptions:)]) {
                string = [data base64EncodedStringWithOptions:0];
        } else {
                string = [data base64Encoding];
        }
        // Remove "+/-"
        string = [[string componentsSeparatedByCharactersInSet:
                  [NSCharacterSet characterSetWithCharactersInString:@"+/="]]
                  componentsJoinedByString:@""];
        // base64后的字符串长度是原串长度的大约135.1%， 去掉特殊字符后再检查字符串长度
        if (string.length == length) {
                return string;
        } else if (string.length > length) {
                return [string substringToIndex:length];
        } else {
                NSMutableString *result = string.mutableCopy;
                for (NSUInteger i = string.length; i < length; i++) {
                        NSUInteger loc = ESRandomNumber(0, (uint32_t)string.length);
                        [result appendFormat:@"%c", [string characterAtIndex:loc]];
                }
                return result;
        }
}

NSString *ESUUID(void)
{
        CFUUIDRef theUUID = CFUUIDCreate(NULL);
        CFStringRef string = CFUUIDCreateString(NULL, theUUID);
        CFBridgingRelease(theUUID);
        return CFBridgingRelease(string);
}

/// Store the weak object
@interface _ESWeakObjectHolder : NSObject
@property (nonatomic, weak) __weak id weakObject;
@end
@implementation _ESWeakObjectHolder
@end

const objc_AssociationPolicy OBJC_ASSOCIATION_WEAK = (0100000);

id ESGetAssociatedObject(id target, const void *key)
{
        id object = objc_getAssociatedObject(target, key);
        if ([object isKindOfClass:[_ESWeakObjectHolder class]]) {
                object = [(_ESWeakObjectHolder *)object weakObject];
        }
        return object;
}

void ESSetAssociatedObject(id target, const void *key, id value, objc_AssociationPolicy policy)
{
        if (OBJC_ASSOCIATION_WEAK == policy) {
                _ESWeakObjectHolder *weakHolder = objc_getAssociatedObject(target, key);
                if (!weakHolder) {
                        weakHolder = [[_ESWeakObjectHolder alloc] init];
                        objc_setAssociatedObject(target, key, weakHolder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                }
                weakHolder.weakObject = value;
        } else {
                objc_setAssociatedObject(target, key, value, policy);
        }
}

NSString *NSStringWith(NSString *format, ...)
{
        NSString *string = nil;
        if (format) {
                va_list args;
                va_start(args, format);
                string = [[NSString alloc] initWithFormat:format arguments:args];
                va_end(args);
        }
        return string;
}

NSURL *NSURLWith(NSString *format, ...)
{
        NSString *string = nil;
        if (format) {
                va_list args;
                va_start(args, format);
                string = [[NSString alloc] initWithFormat:format arguments:args];
                va_end(args);
        }
        if (string) {
                if ([string hasPrefix:@"/"]) {
                        return [NSURL fileURLWithPath:string];
                } else {
                        return [NSURL URLWithString:string];
                }
        }
        return nil;
}


UIImage *UIImageFromCache(NSString *filePath)
{
        if (!ESIsStringWithAnyText(filePath)) {
                return nil;
        }
        return [UIImage imageNamed:filePath];
}

UIImage *UIImageFrom(NSString *filePath)
{
        if (!ESIsStringWithAnyText(filePath)) {
                return nil;
        }
        
        // 如果不是绝对路径,加上mainBundle的路径
        if (![filePath isAbsolutePath]) {
                filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:filePath];
        }
        
#if 0 //-Elf: imageWithContentsOfFile同样会自动寻找路径, 不需要自己计算
        NSFileManager *fm = [NSFileManager defaultManager];
        
        /* 分辨率倍数: "", "@2x", "@3x", 根据当前适配的屏幕分辨率获得 */
        static NSString *__scaleExtension = nil;
        /* 设备修饰符 */
        static NSString *__deviceModifier = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                int scale = (int)[UIScreen mainScreen].scale;
                if (0 == scale) {
                        __scaleExtension = @"";
                } else {
                        __scaleExtension = NSStringWith(@"@%dx", scale);
                }
                __deviceModifier = ESIsPadUI() ? @"~ipad" : @"~iphone";
        });
        
        // 获取pathInfo
        NSString *fileDir = [filePath stringByDeletingLastPathComponent];
        NSString *fileFullName = [filePath lastPathComponent];
        NSString *fileShortName = [fileFullName stringByDeletingPathExtension];
        NSString *fileExtension = [fileFullName pathExtension];
        
        if ([fileExtension isEqualToString:@""]) {
#if 0 //Elf: 不规范的命名放在最后面处理. 因为常见的使用方法是不写扩展名, 从而导致每次都检查文件存在性, 放到最后再检查以优化性能
                // 如果没有扩展名, 检查是否存在没有扩展名的文件,如果有则直接使用
                if ([fm fileExistsAtPath:filePath]) {
                        return [UIImage imageWithContentsOfFile:filePath];
                }
#endif
                
                // 默认的扩展名是小写的png
                fileExtension = @"png";
        }
        
        NSString *retina = [fileDir stringByAppendingFormat:@"/%@%@.%@", fileShortName, __scaleExtension, fileExtension];
        if ([fm fileExistsAtPath:retina]) {
                return [UIImage imageWithContentsOfFile:retina];
        }
        
        NSString *retina_device = [fileDir stringByAppendingFormat:@"/%@%@%@.%@", fileShortName, __scaleExtension, __deviceModifier, fileExtension];
        if ([fm fileExistsAtPath:retina_device]) {
                return [UIImage imageWithContentsOfFile:retina_device];
        }

        /* 处理不符合命名规范的情况 */
        
        // 文件没有扩展名但是这个文件确实存在,
        // 或者有扩展名但是不符合命名规范,但是这个文件确实存在,
        // 就直接加载这个图片
        if ([fm fileExistsAtPath:filePath]) {
                return [UIImage imageWithContentsOfFile:filePath];
        }
        
        // 非高清屏手机上没有对应的图片,使用@2x图片
        if ([__scaleExtension isEqualToString:@""]) {
                NSString *x2 = [fileDir stringByAppendingFormat:@"/%@%@.%@", fileShortName, @"@2x", fileExtension];
                if ([fm fileExistsAtPath:x2]) {
                        return [UIImage imageWithContentsOfFile:x2];
                }
                
                NSString *x2_device = [fileDir stringByAppendingFormat:@"/%@%@%@.%@", fileShortName, @"@2x", __deviceModifier, fileExtension];
                if ([fm fileExistsAtPath:x2_device]) {
                        return [UIImage imageWithContentsOfFile:x2_device];
                }
        }
        
        return nil;
#else
        return [UIImage imageWithContentsOfFile:filePath];
#endif
}

NSString *NSStringFromBytesSizeWithStep(unsigned long long bytesSize, int step)
{
        // !!: NSByteCountFormatter uses 1000 step length
        // if (NSClassFromString(@"NSByteCountFormatter")) {
        //         return [NSByteCountFormatter stringFromByteCount:fileSize countStyle:NSByteCountFormatterCountStyleFile];
        // }
        
        static const NSString *sOrdersOfMagnitude[] = {
                @"Bytes", @"KB", @"MB", @"GB", @"TB", @"PB"
        };
        static const NSUInteger sOrdersOfMagnitude_len = sizeof(sOrdersOfMagnitude) / sizeof(sOrdersOfMagnitude[0]);
        
        int multiplyFactor = 0;
        long double convertedValue = (long double)bytesSize;
        while (convertedValue > step && multiplyFactor < sOrdersOfMagnitude_len) {
                convertedValue /= step;
                ++multiplyFactor;
        }
        
        const NSString *token = sOrdersOfMagnitude[multiplyFactor];
        if (multiplyFactor > 0) {
                return [NSString stringWithFormat:@"%.2Lf %@", convertedValue, token];
        } else {
                return [NSString stringWithFormat:@"%lld %@", bytesSize, token];
        }
}

NSString *NSStringFromBytesSize(unsigned long long bytesSize)
{
        return NSStringFromBytesSizeWithStep(bytesSize, 1024);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Path

NSBundle *ESBundleWithName(NSString *bundleName)
{
        NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:bundleName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                return [NSBundle bundleWithPath:path];
        }
        return nil;
}

NSString *ESPathForBundleResource(NSBundle *bundle, NSString *relativePath)
{
        if (![bundle isKindOfClass:[NSBundle class]]) {
                bundle = [NSBundle mainBundle];
        }
        NSString *path = bundle.resourcePath;
        if (relativePath) {
                path = [path stringByAppendingPathComponent:relativePath];
        }
        return path;
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

BOOL ESTouchDirectory(NSString *directoryPath)
{
        if (ESIsStringWithAnyText(directoryPath)) {
                NSFileManager *fm = [NSFileManager defaultManager];
                BOOL isDir = NO;
                if ([fm fileExistsAtPath:directoryPath isDirectory:&isDir] && isDir) {
                        return YES;
                }
                if ([fm removeItemAtPath:directoryPath error:NULL]) {
                        if ([fm createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:NULL]) {
                                return YES;
                        }
                }
        }
        return NO;
}

BOOL ESTouchDirectoryAtFilePath(NSString *filePath)
{
        NSString *dir = [filePath stringByDeletingLastPathComponent];
        return ESTouchDirectory(dir);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Dispatch

void ESDispatchOnMainThreadSynchrony(dispatch_block_t block)
{
        if ([NSThread isMainThread]) {
                block();
        } else {
                dispatch_sync(dispatch_get_main_queue(), block);
        }
}
void ESDispatchOnMainThreadAsynchrony(dispatch_block_t block)
{
        dispatch_async(dispatch_get_main_queue(), block);
}

void ESDispatchOnGlobalQueue(dispatch_queue_priority_t priority, dispatch_block_t block)
{
        dispatch_async(dispatch_get_global_queue(priority, 0), block);
}

void ESDispatchOnDefaultQueue(dispatch_block_t block)
{
        ESDispatchOnGlobalQueue(DISPATCH_QUEUE_PRIORITY_DEFAULT, block);
}
void ESDispatchOnHighQueue(dispatch_block_t block)
{
       ESDispatchOnGlobalQueue(DISPATCH_QUEUE_PRIORITY_HIGH, block);
}
void ESDispatchOnLowQueue(dispatch_block_t block)
{
        ESDispatchOnGlobalQueue(DISPATCH_QUEUE_PRIORITY_LOW, block);
}
void ESDispatchOnBackgroundQueue(dispatch_block_t block)
{
        ESDispatchOnGlobalQueue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, block);
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


NSInvocation *ESInvocationWith(id target, SEL selector)
{
        if (!target || !selector) {
                return nil;
        }
        
        if (![target respondsToSelector:selector]) {
                return nil;
        }
        NSMethodSignature *signature = [target methodSignatureForSelector:selector];
        if (!signature) {
                return nil;
        }
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        if (!invocation) {
                return nil;
        }
        
        [invocation setTarget:target];
        [invocation setSelector:selector];
        return invocation;
}

BOOL ESInvokeSelector(id target, SEL selector, void *result, ...)
{
        NSInvocation *invocation = ESInvocationWith(target, selector);
        if (!invocation) {
                return NO;
        }

        NSMethodSignature *signature = invocation.methodSignature;
        NSUInteger argCount = 2;
        NSUInteger totalArguments = signature.numberOfArguments;
        
        if (argCount < totalArguments) {
                va_list argsList;
                va_start(argsList, result);
                while (argCount < totalArguments) {
                        // https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
                        char *argType = (char *)[signature getArgumentTypeAtIndex:argCount];

                        if (0 == strcmp(argType, @encode(id))) {
                                id arg = va_arg(argsList, id);
                                [invocation setArgument:&arg atIndex:argCount++];
                        } else if (0 == strcmp(argType, @encode(char)) ||
                                   0 == strcmp(argType, @encode(unsigned char)) ||
                                   0 == strcmp(argType, @encode(BOOL)) ||
                                   0 == strcmp(argType, @encode(short)) ||
                                   0 == strcmp(argType, @encode(unsigned short)) ||
                                   0 == strcmp(argType, @encode(int))) {
                                int arg = va_arg(argsList, int);
                                [invocation setArgument:&arg atIndex:argCount++];
                        } else if (0 == strcmp(argType, @encode(unsigned int))) {
                                unsigned int arg = va_arg(argsList, unsigned int);
                                [invocation setArgument:&arg atIndex:argCount++];
                        } else if (0 == strcmp(argType, @encode(long))) {
                                long arg = va_arg(argsList, long);
                                [invocation setArgument:&arg atIndex:argCount++];
                        } else if (0 == strcmp(argType, @encode(unsigned long))) {
                                unsigned long arg = va_arg(argsList, unsigned long);
                                [invocation setArgument:&arg atIndex:argCount++];
                        } else if (0 == strcmp(argType, @encode(long long))) {
                                long long arg = va_arg(argsList, long long);
                                [invocation setArgument:&arg atIndex:argCount++];
                        } else if (0 == strcmp(argType, @encode(unsigned long long))) {
                                unsigned long long arg = va_arg(argsList, unsigned long long);
                                [invocation setArgument:&arg atIndex:argCount++];
                        } else if (0 == strcmp(argType, @encode(float)) ||
                                   0 == strcmp(argType, @encode(double))) {
                                double arg = va_arg(argsList, double);
                                [invocation setArgument:&arg atIndex:argCount++];
                        } else if (0 == strcmp(argType, @encode(long double))) {
                                long double arg = va_arg(argsList, long double);
                                [invocation setArgument:&arg atIndex:argCount++];
                        } else if (0 == strcmp(argType, @encode(Class))) {
                                Class arg = va_arg(argsList, Class);
                                [invocation setArgument:&arg atIndex:argCount++];
                        } else if (0 == strcmp(argType, @encode(SEL))) {
                                SEL arg = va_arg(argsList, SEL);
                                [invocation setArgument:&arg atIndex:argCount++];
                        } else if (0 == strcmp(argType, @encode(char *))) {
                                char *arg = va_arg(argsList, char *);
                                [invocation setArgument:&arg atIndex:argCount++];
                        } else if (0 == strcmp(argType, @encode(CGRect))) {
                                CGRect arg = va_arg(argsList, CGRect);
                                [invocation setArgument:&arg atIndex:argCount++];
                        } else if (0 == strcmp(argType, @encode(CGPoint))) {
                                CGPoint arg = va_arg(argsList, CGPoint);
                                [invocation setArgument:&arg atIndex:argCount++];
                        } else if (0 == strcmp(argType, @encode(CGSize))) {
                                CGSize arg = va_arg(argsList, CGSize);
                                [invocation setArgument:&arg atIndex:argCount++];
                        } else if (0 == strcmp(argType, @encode(CGAffineTransform))) {
                                CGAffineTransform arg = va_arg(argsList, CGAffineTransform);
                                [invocation setArgument:&arg atIndex:argCount++];
                        } else if (0 == strcmp(argType, @encode(NSRange))) {
                                NSRange arg = va_arg(argsList, NSRange);
                                [invocation setArgument:&arg atIndex:argCount++];
                        } else if (0 == strcmp(argType, @encode(UIOffset))) {
                                UIOffset arg = va_arg(argsList, UIOffset);
                                [invocation setArgument:&arg atIndex:argCount++];
                        } else if (0 == strcmp(argType, @encode(UIEdgeInsets))) {
                                UIEdgeInsets arg = va_arg(argsList, UIEdgeInsets);
                                [invocation setArgument:&arg atIndex:argCount++];
                        } else {
                               // assume it's a pointer
                                void *arg = va_arg(argsList, void *);
                                [invocation setArgument:arg atIndex:argCount++];
                        }

                }
                va_end(argsList);
        }
        
        NSCAssert(argCount == totalArguments, @"Invocation arguments count mismatch: %lu expected, %lu sent.\n", (unsigned long)totalArguments, (unsigned long)argCount);
        
        [invocation invoke];

        if (0 != strcmp(signature.methodReturnType, @encode(void))) {
                if (result) {
                        [invocation getReturnValue:result];
                }
        }
        return YES;
}
