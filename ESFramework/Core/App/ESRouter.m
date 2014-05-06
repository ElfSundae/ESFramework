//
//  ESRouter.m
//  ESFramework
//
//  Created by Elf Sundae on 5/5/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESRouter.h"
#import "ESApp.h"
#import "NSString+ESAdditions.h"

@interface ESRouter ()
@property (nonatomic, strong, readwrite) NSMutableDictionary *map;
@end

@implementation ESRouter

ES_SINGLETON_IMP(sharedRouter);

- (instancetype)init
{
        self = [super init];
        if (self) {
                _map = [[NSMutableDictionary alloc] init];
        }
        return self;
}

- (NSString *)defaultContainerNavigationControllerForPresenting
{
        if (!_defaultContainerNavigationControllerForPresenting) {
                if (NSClassFromString(@"ESNavigationController")) {
                        _defaultContainerNavigationControllerForPresenting = @"ESNavigationController";
                } else {
                        _defaultContainerNavigationControllerForPresenting = @"UINavigationController";
                }
        }
        return _defaultContainerNavigationControllerForPresenting;
}

- (UINavigationController *)defaultNavigationController
{
        if (!_defaultNavigationController) {
                UIViewController *vc = [ESApp rootViewController];
                if ([vc isKindOfClass:[UINavigationController class]]) {
                        _defaultNavigationController = (UINavigationController *)vc;
                }
        }
        return _defaultNavigationController;
}

///=============================================
/// @name Register
///=============================================
- (ESRouterObject *)registerPath:(NSString *)path toRouterObject:(ESRouterObject *)routerObject
{
        if (![path isKindOfClass:[NSString class]] || ![routerObject isKindOfClass:[ESRouterObject class]]) {
                return nil;
        }
        @synchronized(self.map) {
                self.map[path] = routerObject;
        }
        return routerObject;
}
- (ESRouterObject *)registerPath:(NSString *)path toClass:(NSString *)className
{
        return [self registerPath:path toRouterObject:[ESRouterObject objectWithClass:className]];
}
- (ESRouterObject *)registerPath:(NSString *)path toBlock:(ESRouterOpenBlock)block
{
        return [self registerPath:path toRouterObject:[ESRouterObject objectWithBlock:block]];
}

///=============================================
/// @name Router
///=============================================

//- (void)open:(NSString *)url, ...
//{
//        va_list args;
//        va_start(args, url);
//        NSString *urlString = [[NSString alloc] initWithFormat:url arguments:args];
//        va_end(args);
//        [self open:urlString userinfo:nil];
//}


- (void)openURL:(NSString *)url params:(NSDictionary *)routerParams extraInfo:(id)extraInfo
{
        NSString *scheme = nil;
        NSString *path = nil;
        NSMutableDictionary *params = nil;
        if (![self _parseURL:url toScheme:&scheme toPath:&path toParams:&params]) {
                return;
        }
        [params addEntriesFromDictionary:routerParams];
        
        NSLog(@"=======\n%@\n%@\n%@\n%@", url, scheme, path, params);
        
        
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (BOOL)_parseURL:(NSString *)url toScheme:(NSString **)scheme toPath:(NSString **)path toParams:(NSMutableDictionary **)params
{
        if (![url isKindOfClass:[NSString class]]) {
                return NO;
        }
        static NSString *const pattern = @"^([^\\s:]+):/?/?([^\\s\\?/&#]+)(/[^\\s\\?/&#]+)?(/[^\\s\\?/&#]+)?(/[^\\s\\?/&#]+)?";
        NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:NULL];
        NSTextCheckingResult *matchResult = [reg firstMatchInString:url options:0 range:NSMakeRange(0, url.length)];
        if (!matchResult || matchResult.numberOfRanges < 4) {
                return NO;
        }
        
        if (!(*params)) {
                *params = [NSMutableDictionary dictionary];
        }
        
        for (NSInteger i = 0; i < matchResult.numberOfRanges; i++) {
                NSRange range = [matchResult rangeAtIndex:i];
                if (NSNotFound == range.location) {
                        continue;
                }
                if (1 == i && scheme) {
                        *scheme = [url substringWithRange:range];
                } else if (2 == i && path) {
                        *path = [url substringWithRange:range];
                } else if (params) {
                        NSRange r = NSMakeRange(range.location+1, range.length-1);
                        NSString *p = [url substringWithRange:r];
                        if (3 == i) {
                                [*params setObject:p forKey:ESRouterURLKeyParam];
                        } else if (4 == i) {
                               [*params setObject:p forKey:ESRouterURLKeyParam1];
                        } else if (5 == i) {
                               [*params setObject:p forKey:ESRouterURLKeyParam2];
                        }
                }
        }
        
        if (params) {
                [*params addEntriesFromDictionary:[url queryDictionary]];
        }
        
        return YES;
}
@end
