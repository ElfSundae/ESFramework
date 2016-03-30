//
//  ESDefines.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-3.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESDefines.h"
#import <Security/SecRandom.h>

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIColor

UIColor *UIColorWithRGBA(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha)
{
        return [UIColor colorWithRed:red/255. green:green/255. blue:blue/255. alpha:alpha];
}

UIColor *UIColorWithRGB(CGFloat red, CGFloat green, CGFloat blue)
{
        return UIColorWithRGBA(red, green, blue, 1.);
}

UIColor *UIColorWithRGBAHex(NSInteger rgbValue, CGFloat alpha)
{
        return UIColorWithRGBA((CGFloat)((rgbValue & 0xFF0000) >> 16), (CGFloat)((rgbValue & 0xFF00) >> 8), (CGFloat)(rgbValue & 0xFF), alpha);
}

UIColor *UIColorWithRGBHex(NSInteger rgbValue)
{
        return UIColorWithRGBAHex(rgbValue, 1.);
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
                               alpha:1.];
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

NSString *ESStringFromSize(CGSize size)
{
        if (size.height < size.width) {
                CGFloat t = size.width;
                size.width = size.height;
                size.height = t;
        }
        return [NSString stringWithFormat:@"%dx%d", (int)size.width, (int)size.height];
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
        c = object_getClass((id)c);
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
                NSUInteger argIndex = 2;
                for (; argIndex < totalArguments; ++argIndex) {
                        // https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
                        const char *argType = [signature getArgumentTypeAtIndex:argIndex];
                        
#define CMPString(str, str1)    (0 == strcmp(str, str1))
#define CMPType(type)           (CMPString(@encode(type), argType))
#define SetArgumentWithValue(type) do { \
type arg = va_arg(arguments, type); \
[invocation setArgument:&arg atIndex:argIndex]; \
} while(0)
#define SetArgumentWithPointer(type) do { \
type arg = va_arg(arguments, type); \
if (arg) [invocation setArgument:arg atIndex:argIndex]; \
else [invocation setArgument:&__gNil atIndex:argIndex]; \
} while(0)
                        
#define IfTypeThenSetValueAs(type, asType)      if (CMPType(type)) { SetArgumentWithValue(asType); }
#define IfTypeThenSetValue(type)                IfTypeThenSetValueAs(type, type)
#define IfTypeThenSetPointer(type)              if (CMPType(type)) { SetArgumentWithPointer(type); }
                        
#define ElseIfTypeThenSetValueAs(type, asType)  else IfTypeThenSetValueAs(type, asType)
#define ElseIfTypeThenSetValue(type)            else IfTypeThenSetValue(type)
#define ElseIfTypeThenSetPointer(type)          else IfTypeThenSetPointer(type)
                        
                        IfTypeThenSetValueAs(char, int)
                        ElseIfTypeThenSetValueAs(unsigned char, int)
                        ElseIfTypeThenSetValueAs(short, int)
                        ElseIfTypeThenSetValueAs(unsigned short, int)
                        ElseIfTypeThenSetValueAs(BOOL, int)
                        ElseIfTypeThenSetValue(int)
                        ElseIfTypeThenSetValue(unsigned int)
                        ElseIfTypeThenSetValue(long)
                        ElseIfTypeThenSetValue(unsigned long)
                        ElseIfTypeThenSetValue(long long)
                        ElseIfTypeThenSetValue(unsigned long long)
                        ElseIfTypeThenSetValueAs(float, double)
                        ElseIfTypeThenSetValue(double)
                        ElseIfTypeThenSetValue(long double)
                        ElseIfTypeThenSetValue(char *)
                        ElseIfTypeThenSetValue(Class)
                        ElseIfTypeThenSetValue(SEL)
                        ElseIfTypeThenSetValue(NSRange)
                        ElseIfTypeThenSetValue(CGPoint)
                        ElseIfTypeThenSetValue(CGSize)
                        ElseIfTypeThenSetValue(CGVector)
                        ElseIfTypeThenSetValue(CGRect)
                        ElseIfTypeThenSetValue(CGAffineTransform)
                        ElseIfTypeThenSetValue(UIEdgeInsets)
                        ElseIfTypeThenSetValue(UIOffset)
                        ElseIfTypeThenSetValue(CATransform3D)
                        ElseIfTypeThenSetValue(id)
                        else if (CMPString(argType, "@?")) {
                                // block
                                SetArgumentWithValue(id);
                        } else if (argType[0] == '^') {
                                IfTypeThenSetValue(short *)
                                ElseIfTypeThenSetValue(unsigned short *)
                                ElseIfTypeThenSetValue(BOOL *)
                                ElseIfTypeThenSetValue(int *)
                                ElseIfTypeThenSetValue(unsigned int *)
                                ElseIfTypeThenSetValue(long *)
                                ElseIfTypeThenSetValue(unsigned long *)
                                ElseIfTypeThenSetValue(long long *)
                                ElseIfTypeThenSetValue(unsigned long long *)
                                ElseIfTypeThenSetValue(float *)
                                ElseIfTypeThenSetValue(double *)
                                ElseIfTypeThenSetValue(long double *)
                                ElseIfTypeThenSetValue(char **)
                                ElseIfTypeThenSetValue(Class *)
                                ElseIfTypeThenSetValue(SEL *)
                                ElseIfTypeThenSetValue(NSRange *)
                                ElseIfTypeThenSetValue(CGPoint *)
                                ElseIfTypeThenSetValue(CGSize *)
                                ElseIfTypeThenSetValue(CGVector *)
                                ElseIfTypeThenSetValue(CGRect *)
                                ElseIfTypeThenSetValue(CGAffineTransform *)
                                ElseIfTypeThenSetValue(UIEdgeInsets *)
                                ElseIfTypeThenSetValue(UIOffset *)
                                ElseIfTypeThenSetValue(CATransform3D *)
                                else if (CMPString(argType, "^@")) {
                                        SetArgumentWithValue(void *);
                                } else {
                                        SetArgumentWithPointer(void *);
                                }
                        } else {
                                SetArgumentWithPointer(void *);
                        }
                }
        }
        
        if (invocation && retainArguments && !invocation.argumentsRetained) {
                [invocation retainArguments];
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

- (void)es_getReturnValue:(void *)returnValue
{
        if (returnValue && 0 != strcmp(self.methodSignature.methodReturnType, @encode(void))) {
                [self getReturnValue:returnValue];
        }
}

@end

#define _ESInvokeSelector(target, selector, result) \
va_list arguments;      \
va_start(arguments, result);    \
NSInvocation *invocation = [NSInvocation invocationWithTarget:target selector:selector retainArguments:NO arguments:arguments];    \
va_end(arguments);      \
if (invocation) {       \
[invocation invoke];    \
[invocation es_getReturnValue:result];       \
return YES;     \
}               \
return NO;

@implementation NSObject (_ESInvoke)

+ (BOOL)invokeSelector:(SEL)selector result:(void *)result, ...
{
        _ESInvokeSelector(self, selector, result);
}
- (BOOL)invokeSelector:(SEL)selector result:(void *)result, ...
{
        _ESInvokeSelector(self, selector, result);
}

@end

BOOL ESInvokeSelector(id target, SEL selector, void *result, ...)
{
        _ESInvokeSelector(target, selector, result);
}
