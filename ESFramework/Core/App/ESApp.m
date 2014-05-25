//
//  ESApp.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-8.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESApp+ESInternal.h"

@implementation ESApp

+ (void)load
{
        @autoreleasepool {
                [self isFreshLaunch:nil];
        }
}

+ (instancetype)sharedApp
{
        if ([ESApp _isUIApplicationDelegate]) {
                return [UIApplication sharedApplication].delegate;
        }
        
        static ESApp *__gSharedApp = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                __gSharedApp = [[super alloc] init];
        });
        return __gSharedApp;
}

- (UIWindow *)window
{
        if (_window) {
                return _window;
        }
        return [[self class] keyWindow];
}

- (UIViewController *)rootViewController
{
        if (_rootViewController) {
                return _rootViewController;
        }
        return [[self class] rootViewController];
}

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSMutableURLRequest (ESUserAgent)

@implementation NSMutableURLRequest (ESUserAgent)
- (void)addUserAgent
{
        [self setValue:[[ESApp sharedApp] userAgent] forHTTPHeaderField:@"User-Agent"];
}
@end
