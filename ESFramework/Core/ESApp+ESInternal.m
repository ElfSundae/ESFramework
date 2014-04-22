//
//  ESApp+ESInternal.m
//  ESFramework
//
//  Created by Elf Sundae on 4/21/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESApp+ESInternal.h"

@implementation ESApp (ESInternal)

+ (BOOL)_isUIApplicationDelegate
{
        static BOOL __isRealAppDelegate = NO;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                __isRealAppDelegate = ([[UIApplication sharedApplication].delegate isKindOfClass:[ESApp class]]);
        });
        return __isRealAppDelegate;
}

@end

@implementation NSMutableURLRequest (ESUserAgent)
- (void)addUserAgent
{
        [self setValue:[[[ESApp sharedApp] class] userAgent] forHTTPHeaderField:@"User-Agent"];
}
@end