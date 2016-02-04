//
//  ESDefines.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-3.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESDefines.h"

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
        NSString *string = [data base64EncodedStringWithOptions:0];
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

/*!
 * `_ESWeakObjectHolder` stores the weak object.
 */
@interface _ESWeakObjectHolder : NSObject
@property (nonatomic, weak) __weak id weakObject;
@end
@implementation _ESWeakObjectHolder
@end

const objc_AssociationPolicy OBJC_ASSOCIATION_WEAK = (01407);

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
        
        return [UIImage imageWithContentsOfFile:filePath];
}

NSString *NSStringFromBytesSizeWithStep(unsigned long long bytesSize, int step)
{
        //!!!: NSByteCountFormatter uses 1000 step length
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
        static dispatch_once_t onceToken_DocumentsPath;
        dispatch_once(&onceToken_DocumentsPath, ^{
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
        static dispatch_once_t onceToken_LibraryPath;
        dispatch_once(&onceToken_LibraryPath, ^{
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
        static dispatch_once_t onceToken_CachesPath;
        dispatch_once(&onceToken_CachesPath, ^{
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
                return ([fm removeItemAtPath:directoryPath error:NULL] &&
                        [fm createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:NULL]);
        }
        return NO;
}

BOOL ESTouchDirectoryAtFilePath(NSString *filePath)
{
        return ESTouchDirectory([filePath stringByDeletingLastPathComponent]);
}

BOOL ESTouchDirectoryAtURL(NSURL *url)
{
        return ESTouchDirectoryAtFilePath(url.path);
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
#pragma mark - ObjC Runtime

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

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Invocation

static id __gNil = nil;

@implementation NSInvocation (_ESHelper)

+ (instancetype)invocationWithTarget:(id)target selector:(SEL)selector
{
        if (target && selector && [target respondsToSelector:selector]) {
                NSMethodSignature *signature = [target methodSignatureForSelector:selector];
                if (signature) {
                        NSInvocation *invocation = [self invocationWithMethodSignature:signature];
                        if (invocation) {
                                [invocation setTarget:target];
                                [invocation setSelector:selector];
                                return invocation;
                        }
                }
        }
        return nil;
}

+ (instancetype)invocationWithTarget:(id)target selector:(SEL)selector retainArguments:(BOOL)retainArguments arguments:(va_list)arguments
{
        NSInvocation *invocation = [self invocationWithTarget:target selector:selector];
        if (invocation && arguments) {
                NSMethodSignature *signature = invocation.methodSignature;
                NSUInteger totalArguments = signature.numberOfArguments;
                NSUInteger argCount = 2;
                for (; argCount < totalArguments; ++argCount) {
                        // https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
                        const char *argType = [signature getArgumentTypeAtIndex:argCount];
                        
#define CMP(objCType) (0 == strcmp(argType, objCType))
#define STRPREFIX(prefix) (strlen(argType) >= strlen(prefix) && 0 == strncmp(prefix, argType, strlen(prefix)))
                        
#define SET_ARG(type) do {\
type arg = va_arg(arguments, type); \
[invocation setArgument:&arg atIndex:argCount]; \
} while(0);
                        
#define IF_CMP(type) if (CMP(@encode(type))) { SET_ARG(type) }
#define IF_CMP_AS(type, asType) if (CMP(@encode(type))) { SET_ARG(asType) }
#define ELIF_CMP(type) else IF_CMP(type)
#define ELIF_CMP_AS(type, asType) else IF_CMP_AS(type, asType)
#define IF_PRE(type) if (STRPREFIX(type)) {}
                        printf("%d %s\n", argCount, argType);
                        
                        IF_CMP_AS(char, int)
                        ELIF_CMP_AS(unsigned char, int)
                        ELIF_CMP_AS(short, int)
                        ELIF_CMP_AS(unsigned short, int)
                        ELIF_CMP_AS(BOOL, int)
                        ELIF_CMP(int)
                        ELIF_CMP(unsigned int)
                        ELIF_CMP(long)
                        ELIF_CMP(unsigned long)
                        ELIF_CMP(long long)
                        ELIF_CMP(unsigned long long)
                        ELIF_CMP_AS(float, double)
                        ELIF_CMP(double)
                        ELIF_CMP(long double)
                        ELIF_CMP(char *)
                        ELIF_CMP(id)
                        ELIF_CMP(Class)
                        ELIF_CMP(SEL)
                        ELIF_CMP(CGPoint)
                        ELIF_CMP(CGSize)
                        ELIF_CMP(CGVector)
                        ELIF_CMP(CGRect)
                        ELIF_CMP(CGAffineTransform)
                        ELIF_CMP(NSRange)
                        ELIF_CMP(UIEdgeInsets)
                        ELIF_CMP(UIOffset)
                        
                        else {
                                //TODO: output parameter
                                //TODO: ^f int * double* etc.
                                //TODO: argCount != arumentsCount
                                // assume it's a pointer
                                void *arg = va_arg(arguments, void *);
                                if (arg) {
                                        [invocation setArgument:arg atIndex:argCount];
                                } else {
                                        [invocation setArgument:&__gNil atIndex:argCount];
                                }
                        }
                }
        }
        
        if (invocation) {
                if (retainArguments && !invocation.argumentsRetained) {
                        [invocation retainArguments];
                }
        }
        
        return invocation;
}

+ (instancetype)invocationWithTarget:(id)target selector:(SEL)selector retainArguments:(BOOL)retainArguments, ...
{
        va_list arguments;
        va_start(arguments, retainArguments);
        NSInvocation *invocation = [NSInvocation invocationWithTarget:target selector:selector retainArguments:retainArguments arguments:arguments];
        va_end(arguments);
        return invocation;
}

@end

BOOL ESInvokeSelector(id target, SEL selector, void *result, ...)
{
        va_list arguments;
        va_start(arguments, result);
        NSInvocation *invocation = [NSInvocation invocationWithTarget:target selector:selector retainArguments:NO arguments:arguments];
        va_end(arguments);
        
        [invocation invoke];

        if (0 != strcmp(invocation.methodSignature.methodReturnType, @encode(void))) {
                if (result) {
                        
                        //TODO: void * to __bridge cast
                        [invocation getReturnValue:result];
                }
        }
        return YES;
}
