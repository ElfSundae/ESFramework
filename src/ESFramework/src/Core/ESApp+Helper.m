//
//  ESApp+Helper.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-10.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import "ESApp.h"
#import "NSUserDefaults+ESAdditions.h"

#define kESUserDefaultsKey_CheckFreshLaunchAppVersion @"es_check_fresh_launch_app_version"

@implementation ESApp (Helper)

+ (BOOL)isFreshLaunch:(NSString **)previousAppVersion
{
        static NSString *__previousVersion = nil;
        static BOOL __isFreshLaunch = NO;
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                __previousVersion = [NSUserDefaults objectForKey:kESUserDefaultsKey_CheckFreshLaunchAppVersion];
                NSString *current = [self appVersion];
                if (__previousVersion && [__previousVersion compare:current] == NSOrderedSame) {
                        __isFreshLaunch = NO;
                } else {
                        __isFreshLaunch = YES;
                        [NSUserDefaults setObject:current forKey:kESUserDefaultsKey_CheckFreshLaunchAppVersion];
                }
        });
        
        if (previousAppVersion) {
                *previousAppVersion = __previousVersion;
        }
        return __isFreshLaunch;
}


@end
