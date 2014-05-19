//
//  ESDefines.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-3.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESDefines.h"
#import <objc/runtime.h>

#if !__es_arc_enabled
#error "ESFramework requires ARC support."
#endif
#if !__has_feature(objc_instancetype)
#error "ESFramework requires Xcode5 to build."
#endif

NSInteger ESMaxLogLevel = ESLOGLEVEL_INFO;

NSString *const ESErrorDomain = @"com.0x123.ESErrorDomain";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

#if DEBUG
mach_timebase_info_data_t __es_timebase_info__;
@interface ESDefinesInternal : NSObject
@end
@implementation ESDefinesInternal
+ (void)load {
        (void) mach_timebase_info(&__es_timebase_info__);
}
@end
#endif

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

UIColor *UIColorWithRGBHexString(NSString *hexString, CGFloat alpha)
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
        return (floor(NSFoundationVersionNumber) >= versionNumber);
}

BOOL ESOSVersionIsAbove(double versionNumber)
{
        return (floor(NSFoundationVersionNumber) > versionNumber);
}

BOOL ESOSVersionIsAbove7(void)
{
        return ESOSVersionIsAbove(NSFoundationVersionNumber_iOS_6_1);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 

NSBundle *ESBundleWithName(NSString *bundleName)
{
        NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:bundleName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                return [NSBundle bundleWithPath:path];
        }
        return nil;
}

NSBundle *ESFWBundle(void)
{
        static NSBundle *__es_bundle = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                __es_bundle = ESBundleWithName(@"ESFrameworkResources.bundle");
        });
        return __es_bundle;
}

UIDeviceOrientation ESDeviceOrientation(void)
{
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        if (UIDeviceOrientationUnknown == orientation) {
                orientation = UIDeviceOrientationPortrait;
        }
        return orientation;
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

CGRect ESFrameOfCenteredViewWithinView(UIView *view, UIView *containerView)
{
        CGRect rect;
        CGSize containerSize = containerView.bounds.size;
        rect.size = view.frame.size;
        rect.origin.x = ESSizeCenterX(containerSize, rect.size);
        rect.origin.y = ESSizeCenterY(containerSize, rect.size);
        return rect;
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

BOOL ESIsRetinaScreen(void)
{
        static BOOL _gIsRetina;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                _gIsRetina = ([UIScreen mainScreen].scale == 2.0);
        });
        return _gIsRetina;
}

UIImage *UIImageFromCache(NSString *path, ...)
{
        NSString *filePath = nil;
        if ([path isKindOfClass:[NSString class]]) {
                va_list args;
                va_start(args, path);
                filePath = [[NSString alloc] initWithFormat:path arguments:args];
                va_end(args);
        }
        if (!filePath) {
                return nil;
        }
        return [UIImage imageNamed:filePath];
}

UIImage *UIImageFrom(NSString *path, ...)
{
        NSString *filePath = nil;
        if ([path isKindOfClass:[NSString class]]) {
                va_list args;
                va_start(args, path);
                filePath = [[NSString alloc] initWithFormat:path arguments:args];
                va_end(args);
        }
        if (!filePath) {
                return nil;
        }
        
        if (![filePath isAbsolutePath]) {
                filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:filePath];
        }
        
        NSFileManager *fm = [NSFileManager defaultManager];
        if ([fm fileExistsAtPath:filePath]) {
                return [UIImage imageWithContentsOfFile:filePath];
        }
        
        NSString *fileDir = [filePath stringByDeletingLastPathComponent];
        NSString *fileFullName = [filePath lastPathComponent];
        NSString *fileShortName = [fileFullName stringByDeletingPathExtension];
        NSString *fileExtension = [fileFullName pathExtension];
        
        if (0 == fileExtension.length) {
                fileExtension = @"png";
                filePath = [fileDir stringByAppendingPathComponent:[fileShortName stringByAppendingPathExtension:fileExtension]];
        }
        if ([fm fileExistsAtPath:filePath]) {
                return [UIImage imageWithContentsOfFile:filePath];
        }
        
        fileShortName = [fileShortName stringByReplacingOccurrencesOfString:@"@2x" withString:@""];
        NSString *x2 = [fileDir stringByAppendingFormat:@"/%@@2x.%@", fileShortName, fileExtension];
        if ([fm fileExistsAtPath:x2]) {
                return [UIImage imageWithContentsOfFile:x2];
        }
        
        NSString *x2_device = [fileDir stringByAppendingFormat:@"/%@@2x~%@.%@", fileShortName, (ESIsPadUI() ? @"ipad" : @"iphone"), fileExtension];
        if ([fm fileExistsAtPath:x2_device]) {
                return [UIImage imageWithContentsOfFile:x2_device];
        }
        
        NSString *original = [fileDir stringByAppendingFormat:@"/%@.%@", fileShortName, fileExtension];
        if ([fm fileExistsAtPath:original]) {
                return [UIImage imageWithContentsOfFile:original];
        }
        NSString *original_device = [fileDir stringByAppendingFormat:@"/%@~%@.%@", fileShortName, (ESIsPadUI() ? @"ipad" : @"iphone"), fileExtension];
        if ([fm fileExistsAtPath:original_device]) {
                return [UIImage imageWithContentsOfFile:original_device];
        }
        
        return nil;
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
                return [NSURL URLWithString:string];
        }
        return nil;
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

NSString *ESPathForBundleResource(NSBundle *bundle, NSString *relativePath, ...)
{
        NSBundle *b = bundle ?: [NSBundle mainBundle];
        NSString *filePath = [b resourcePath];
        if (relativePath) {
                va_list args;
                va_start(args, relativePath);
                NSString *path = [[NSString alloc] initWithFormat:relativePath arguments:args];
                va_end(args);
                filePath = [filePath stringByAppendingPathComponent:path];
        }
        return filePath;
}

NSString *ESPathForMainBundleResource(NSString *relativePath, ...)
{
        NSString *path = nil;
        if (relativePath) {
                va_list args;
                va_start(args, relativePath);
                path = [[NSString alloc] initWithFormat:relativePath arguments:args];
                va_end(args);
        }
        return ESPathForBundleResource([NSBundle mainBundle], path);
}

NSString *ESPathForESFWBundleResource(NSString *relativePath, ...)
{
        NSString *path = nil;
        if (relativePath) {
                va_list args;
                va_start(args, relativePath);
                path = [[NSString alloc] initWithFormat:relativePath arguments:args];
                va_end(args);
        }
        return ESPathForBundleResource(ESFWBundle(), path);
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

NSString *ESPathForDocumentsResource(NSString *relativePath, ...)
{
        NSString *filePath = @"";
        if (relativePath) {
                va_list args;
                va_start(args, relativePath);
                filePath = [[NSString alloc] initWithFormat:relativePath arguments:args];
                va_end(args);
        }
        return [ESPathForDocuments() stringByAppendingPathComponent:filePath];
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

NSString *ESPathForLibraryResource(NSString *relativePath, ...)
{
        NSString *filePath = @"";
        if (relativePath) {
                va_list args;
                va_start(args, relativePath);
                filePath = [[NSString alloc] initWithFormat:relativePath arguments:args];
                va_end(args);
        }
        return [ESPathForLibrary() stringByAppendingPathComponent:filePath];
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

NSString *ESPathForCachesResource(NSString *relativePath, ...)
{
        NSString *filePath = @"";
        if (relativePath) {
                va_list args;
                va_start(args, relativePath);
                filePath = [[NSString alloc] initWithFormat:relativePath arguments:args];
                va_end(args);
        }
        return [ESPathForCaches() stringByAppendingPathComponent:filePath];
}

NSString *ESPathForTemporary(void)
{
        return NSTemporaryDirectory();
}

NSString *ESPathForTemporaryResource(NSString *relativePath, ...)
{
        NSString *filePath = @"";
        if (relativePath) {
                va_list args;
                va_start(args, relativePath);
                filePath = [[NSString alloc] initWithFormat:relativePath arguments:args];
                va_end(args);
        }
        return [ESPathForTemporary() stringByAppendingPathComponent:filePath];
}

BOOL ESTouchDirectory(NSString *dir)
{
        if (![dir isKindOfClass:[NSString class]] || 0 == dir.length) {
                return NO;
        }
        NSFileManager *fm = [NSFileManager defaultManager];
        BOOL isDirectory = NO;
        if (![fm fileExistsAtPath:dir isDirectory:&isDirectory] || !isDirectory) {
                if (![fm createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:NULL]) {
                        return NO;
                }
        }
        return YES;
}

NSString *ESTouchFilePath(NSString *filePath, ...)
{
        NSString *path = @"";
        if ([filePath isKindOfClass:[NSString class]]) {
                va_list args;
                va_start(args, filePath);
                path = [[NSString alloc] initWithFormat:filePath arguments:args];
                va_end(args);
        }
        NSString *dir = [path stringByDeletingLastPathComponent];
        if (!ESTouchDirectory(dir)) {
                return nil;
        }
        return path;
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
                        char *argType = (char *)[signature getArgumentTypeAtIndex:argCount];
                        //void *arg = NULL;
                        if (0 == strcmp(argType, @encode(id))) {
                                id arg = va_arg(argsList, id);
                                [invocation setArgument:&arg atIndex:argCount++];
                        } else if (0 == strcmp(argType, @encode(char)) ||
                                   0 == strcmp(argType, @encode(unsigned char)) ||
                                   0 == strcmp(argType, @encode(short)) ||
                                   0 == strcmp(argType, @encode(unsigned short)) ||
                                   0 == strcmp(argType, @encode(int)) ||
                                   0 == strcmp(argType, @encode(unsigned int)) ) {
                                int arg = va_arg(argsList, int);
                                [invocation setArgument:&arg atIndex:argCount++];
                        } else if ( 0 == strcmp(argType, @encode(long)) ||
                                   0 == strcmp(argType, @encode(unsigned long))) {
                                long arg = va_arg(argsList, long);
                                [invocation setArgument:&arg atIndex:argCount++];
                        } else if (0 == strcmp(argType, @encode(long long)) ||
                                   0 == strcmp(argType, @encode(unsigned long long))) {
                                long long arg = va_arg(argsList, long long);
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

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject+ESAssociatedObject
@interface _ESWeakAssociatedObject : NSObject
@property (nonatomic, es_weak_property) __es_weak id weakObject;
@end
@implementation _ESWeakAssociatedObject
@end

@implementation NSObject (ESAssociatedObject)

- (id)getAssociatedObject:(const void *)key
{
        id obj = objc_getAssociatedObject(self, key);
        if ([obj isKindOfClass:[_ESWeakAssociatedObject class]]) {
                obj = [(_ESWeakAssociatedObject *)obj weakObject];
        }
        return obj;
}
+ (id)getAssociatedObject:(const void *)key
{
        id obj = objc_getAssociatedObject(self, key);
        if ([obj isKindOfClass:[_ESWeakAssociatedObject class]]) {
                obj = [(_ESWeakAssociatedObject *)obj weakObject];
        }
        return obj;
}

- (void)setAssociatedObject_nonatomic_weak:(__es_weak id)weakObject key:(const void *)key
{
        _ESWeakAssociatedObject *object = objc_getAssociatedObject(self, key);
        if (!object) {
                object = [[_ESWeakAssociatedObject alloc] init];
                [self setAssociatedObject_nonatomic_retain:object key:key];
        }
        object.weakObject = weakObject;
}
+ (void)setAssociatedObject_nonatomic_weak:(__es_weak id)weakObject key:(const void *)key
{
        _ESWeakAssociatedObject *object = objc_getAssociatedObject(self, key);
        if (!object) {
                object = [[_ESWeakAssociatedObject alloc] init];
                [self setAssociatedObject_nonatomic_retain:object key:key];
        }
        object.weakObject = weakObject;
}

- (void)setAssociatedObject_nonatomic_retain:(id)object key:(const void *)key
{
        objc_setAssociatedObject(self, key, object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
+ (void)setAssociatedObject_nonatomic_retain:(id)object key:(const void *)key
{
        objc_setAssociatedObject(self, key, object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setAssociatedObject_nonatomic_copy:(id)object key:(const void *)key
{
        objc_setAssociatedObject(self, key, object, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
+ (void)setAssociatedObject_nonatomic_copy:(id)object key:(const void *)key
{
        objc_setAssociatedObject(self, key, object, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)setAssociatedObject_atomic_retain:(id)object key:(const void *)key
{
        objc_setAssociatedObject(self, key, object, OBJC_ASSOCIATION_RETAIN);
}
+ (void)setAssociatedObject_atomic_retain:(id)object key:(const void *)key
{
        objc_setAssociatedObject(self, key, object, OBJC_ASSOCIATION_RETAIN);
}
- (void)setAssociatedObject_atomic_copy:(id)object key:(const void *)key
{
        objc_setAssociatedObject(self, key, object, OBJC_ASSOCIATION_COPY);
}
+ (void)setAssociatedObject_atomic_copy:(id)object key:(const void *)key
{
        objc_setAssociatedObject(self, key, object, OBJC_ASSOCIATION_COPY);
}

- (void)removeAllAssociatedObjects
{
        objc_removeAssociatedObjects(self);
}
+ (void)removeAllAssociatedObjects
{
        objc_removeAssociatedObjects(self);
}

@end
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Notification with block
@interface NSObject (_ESObserverInternal)
@property (nonatomic, strong) NSMutableDictionary *__es_notificationHandlers;
@end
static const void *__es_notificationHandlersKey = &__es_notificationHandlersKey;
@implementation NSObject (ESObserver)
- (void)set__es_notificationHandlers:(NSMutableDictionary *)handlers
{
        [self setAssociatedObject_nonatomic_retain:handlers key:__es_notificationHandlersKey];
}
- (NSMutableDictionary *)__es_notificationHandlers
{
        NSMutableDictionary *dict = [self getAssociatedObject:__es_notificationHandlersKey];
        if (!dict) {
                dict = [NSMutableDictionary dictionary];
                [self set__es_notificationHandlers:dict];
        }
        return dict;
}
- (void)__es_appendNotificationHandler:(ESNotificationHandler)handler toName:(NSString *)name
{
        [[self __es_notificationHandlersWithName:name] addObject:[handler copy]];
}
- (NSMutableArray *)__es_notificationHandlersWithName:(NSString *)name
{
        NSMutableArray *array = self.__es_notificationHandlers[name];
        if (!array) {
                array = [NSMutableArray array];
                [self.__es_notificationHandlers setObject:array forKey:name];
        }
        return array;
}

- (void)__es_notificationSelector:(NSNotification *)notification
{
        NSMutableArray *array = [self __es_notificationHandlersWithName:notification.name];
        for (ESNotificationHandler handler in array) {
                handler(notification, notification.userInfo);
        }
}

- (void)addNotification:(NSString *)name handler:(ESNotificationHandler)handler
{
        if ([name isKindOfClass:[NSString class]]) {
                if (handler) {
                        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(__es_notificationSelector:) name:name object:nil];
                        [self __es_appendNotificationHandler:handler toName:name];
                } else {
                        [[self __es_notificationHandlersWithName:name] removeAllObjects];
                }
        } else {
                [[NSNotificationCenter defaultCenter] removeObserver:self];
        }
}

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSUserDefaults+ESHelper

@implementation NSUserDefaults (ESHelper)
+ (id)objectForKey:(NSString *)key
{
        return [[self standardUserDefaults] objectForKey:key];
}
+ (void)setObject:(id)object forKey:(NSString *)key
{
        ESDispatchOnDefaultQueue(^{
                NSUserDefaults *ud = [self standardUserDefaults];
                [ud setObject:object forKey:key];
                [ud synchronize];
        });
}
+ (void)removeObjectForKey:(NSString *)key
{
        ESDispatchOnDefaultQueue(^{
                NSUserDefaults *ud = [self standardUserDefaults];
                [ud removeObjectForKey:key];
                [ud synchronize];
        });
}
@end