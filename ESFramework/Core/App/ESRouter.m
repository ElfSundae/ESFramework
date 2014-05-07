//
//  ESRouter.m
//  ESFramework
//
//  Created by Elf Sundae on 5/5/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESRouter.h"
#import "ESApp.h"
#import "ESFoundation.h"

@interface ESRouter ()
@property (nonatomic, strong, readwrite) NSMutableDictionary *map;
@property (nonatomic, strong, readwrite) Class defaultContainerNavigationControllerClassForPresenting;
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
                _defaultContainerNavigationControllerForPresenting = @"UINavigationController";
        }
        return _defaultContainerNavigationControllerForPresenting;
}

- (Class)defaultContainerNavigationControllerClassForPresenting
{
        if (!_defaultContainerNavigationControllerClassForPresenting) {
                _defaultContainerNavigationControllerClassForPresenting = NSClassFromString(self.defaultContainerNavigationControllerForPresenting);
        }
        return _defaultContainerNavigationControllerClassForPresenting;
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

- (BOOL)open:(NSString *)format, ...
{
        va_list args;
        va_start(args, format);
        NSString *url = [[NSString alloc] initWithFormat:format arguments:args];
        va_end(args);
        return [self open:url params:nil extraInfo:nil];
}

- (BOOL)open:(NSString *)url params:(NSDictionary *)routerParams extraInfo:(id)extraInfo
{
        NSString *scheme = ESRouterURLSchemeController;
        NSString *path = nil;
        NSMutableDictionary *params = nil;
        if (![self _parseURL:url toScheme:&scheme toPath:&path toParams:&params]) {
                return NO;
        }
        [params addEntriesFromDictionary:routerParams];
        //NSLog(@"=======\n%@\n%@\n%@\n%@", url, scheme, path, params);
        if (!path) {
                return NO;
        }

        ESRouterObject *routerObject = [self.map objectForKey:path];
        if (routerObject) {
                // If there are '__modal__' '__root__' '__animated__' in URL params,
                // then copy the routerObject and set these opening options
                if ([params match:^BOOL(id key, id obj) {
                        NSString *str = (NSString *)key;
                        return ([str isEqualToStringCaseInsensitive:ESRouterURLKeyIsModal] ||
                                [str isEqualToStringCaseInsensitive:ESRouterURLKeyIsRoot] ||
                                [str isEqualToStringCaseInsensitive:ESRouterURLKeyIsAnimated]);
                }]) {
                        routerObject = [routerObject copy];
                }
        } else {
                if ([scheme isEqualToStringCaseInsensitive:ESRouterURLSchemeController]) {
                       routerObject = [ESRouterObject objectWithClass:path];
                }
        }
        [params addEntriesFromDictionary:routerObject.defaultParams];
        
        return [self openRouterObject:routerObject params:params extraInfo:extraInfo];
}

- (BOOL)openRouterObject:(ESRouterObject *)routerObject params:(NSMutableDictionary *)params extraInfo:(id)extraInfo
{
        if (!params || !routerObject) {
                return NO;
        }
        
        BOOL isRoot, isModal, isAnimated;
        if (ESBoolVal(&isRoot, params[ESRouterURLKeyIsRoot])) {
                routerObject.root = isRoot;
        }
        if (ESBoolVal(&isModal, params[ESRouterURLKeyIsModal])) {
                routerObject.modal = isModal;
        }
        if (ESBoolVal(&isAnimated, params[ESRouterURLKeyIsAnimated])) {
                routerObject.animated = isAnimated;
        }
        
        /* Open block */
        if (routerObject.openBlock) {
                routerObject.openBlock(params);
                return YES;
        }
        
        /* Open view controller */
        if (!routerObject.openClass) {
                return NO;
        }
        
        UIViewController<ESRouterDelegate> *openViewController = [[routerObject.openClass alloc] init];
        if (![openViewController isKindOfClass:[UIViewController class]]) {
                return NO;
        }
        
        // Set params to delegate
        if ([openViewController respondsToSelector:@selector(setRouterParams:)]) {
                openViewController.routerParams = params;
        }
        if ([openViewController respondsToSelector:@selector(setRouterParam:)]) {
                openViewController.routerParam = params[ESRouterURLKeyParam];
        }
        if ([openViewController respondsToSelector:@selector(setRouterParam1:)]) {
                openViewController.routerParam1 = params[ESRouterURLKeyParam1];
        }
        if ([openViewController respondsToSelector:@selector(setRouterParam2:)]) {
                openViewController.routerParam2 = params[ESRouterURLKeyParam2];
        }
        if ([openViewController respondsToSelector:@selector(setRouterExtraInfo:)]) {
                openViewController.routerExtraInfo = extraInfo;
        }
        
        if (routerObject.isModal) {
                // Create navigation controller
                UINavigationController *navController = nil;
                if ([openViewController isKindOfClass:[UINavigationController class]]) {
                        navController = (UINavigationController *)openViewController;
                } else {
                        Class navClass = nil;
                        if (routerObject.containerNavigationControllerForPresenting) {
                                navClass = NSClassFromString(routerObject.containerNavigationControllerForPresenting);
                        }
                        if (!navClass) {
                                navClass = self.defaultContainerNavigationControllerClassForPresenting;
                        }
                        
                        if (navClass && [navClass instancesRespondToSelector:@selector(initWithRootViewController:)]) {
                                navController = [[navClass alloc] initWithRootViewController:openViewController];
                        }
                }
                if (![navController isKindOfClass:[UINavigationController class]]) {
                        navController = [[UINavigationController alloc] initWithRootViewController:openViewController];
                }
                // Present
                UIViewController *rootController = [ESApp rootViewControllerForPresenting];
                if (routerObject.openingCallback) {
                        routerObject.openingCallback(rootController, openViewController, params);
                }
                [ESApp presentViewController:navController animated:routerObject.isAnimated completion:nil];
        } else {
                // Get navigation controller to push
                UINavigationController *navController = routerObject.navigationController;
                if (!navController) {
                        navController = self.defaultNavigationController;
                }
                if (!navController) {
                        return NO;
                }
                // Push
                if (routerObject.openingCallback) {
                        routerObject.openingCallback(navController, openViewController, params);
                }
                if (routerObject.isRoot) {
                        [navController setViewControllers:@[openViewController] animated:routerObject.isAnimated];
                } else {
                        [navController pushViewController:openViewController animated:routerObject.isAnimated];
                }
        }
        return YES;
}

+ (void)close:(UIViewController *)controller animated:(BOOL)animated
{
        if (controller.presentingViewController) {
                if (controller.navigationController) {
                        controller = controller.navigationController;
                }
                [controller dismissViewControllerAnimated:animated completion:nil];
        } else if (controller.navigationController) {
                // Dismiss all modal controllers that presented by this navigation controller.
                if ([controller.navigationController presentedViewController]) {
                        [controller.navigationController dismissViewControllerAnimated:animated completion:nil];
                }
                // pop me
                NSArray *navStack = controller.navigationController.viewControllers;
                NSUInteger index = [navStack indexOfObject:controller];
                if (index > 0) {
                        [controller.navigationController popToViewController:navStack[index-1] animated:animated];
                }
        }
}

- (void)close:(UIViewController *)controller animated:(BOOL)animated
{
        [[self class] close:controller animated:animated];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (ESRouterObject *)routerObjectForPath:(NSString *)path
{
        ESRouterObject *object = nil;
        @synchronized(self.map) {
                object = [self.map objectForKey:path];
        }
        return object;
}
- (BOOL)_parseURL:(NSString *)url toScheme:(NSString **)scheme toPath:(NSString **)path toParams:(NSMutableDictionary **)params
{
        if (![url isKindOfClass:[NSString class]]) {
                return NO;
        }
        static NSString *const pattern = @"^(([^\\s:]+):/?/?)?([^\\s\\?/&#]+)(/[^\\s\\?/&#]+)?(/[^\\s\\?/&#]+)?(/[^\\s\\?/&#]+)?";
        NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:NULL];
        NSTextCheckingResult *matchResult = [reg firstMatchInString:url options:0 range:NSMakeRange(0, url.length)];
        if (!matchResult || matchResult.numberOfRanges < 6) {
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
                if (2 == i && scheme) {
                        *scheme = [url substringWithRange:range];
                } else if (3 == i && path) {
                        *path = [url substringWithRange:range];
                } else if (params) {
                        NSRange r = NSMakeRange(range.location+1, range.length-1);
                        NSString *p = [url substringWithRange:r];
                        if (4 == i) {
                                [*params setObject:p forKey:ESRouterURLKeyParam];
                        } else if (5 == i) {
                               [*params setObject:p forKey:ESRouterURLKeyParam1];
                        } else if (6 == i) {
                               [*params setObject:p forKey:ESRouterURLKeyParam2];
                        }
                }
        }
        
        NSDictionary *queryDictionary = [url queryDictionary];
        if (queryDictionary.count) {
                [*params addEntriesFromDictionary:queryDictionary];
        }
        
        return YES;
}
@end
