//
//  ESApp+Network.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-10.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import "ESApp.h"

@implementation ESApp (Network)

+ (void)deleteAllHTTPCookies
{
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        [cookieStorage.cookies enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [cookieStorage deleteCookie:obj];
        }];
}

@end
