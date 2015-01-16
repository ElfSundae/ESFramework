//
//  ESApp+Internal.m
//  ESFramework
//
//  Created by Elf Sundae on 14-12-16.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import "ESApp+Internal.h"

@implementation ESApp (Internal)

+ (BOOL)_isUIApplicationDelegate
{
        static BOOL __isRealAppDelegate = NO;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                __isRealAppDelegate = ([[UIApplication sharedApplication].delegate isKindOfClass:[self class]]);
        });
        return __isRealAppDelegate;
}

@end
