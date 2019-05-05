//
//  NSHTTPCookieStorage+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 2019/05/05.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import "NSHTTPCookieStorage+ESAdditions.h"

@implementation NSHTTPCookieStorage (ESAdditions)

- (void)deleteCookiesForURL:(NSURL *)URL
{
    for (NSHTTPCookie *cookie in [self cookiesForURL:URL]) {
        [self deleteCookie:cookie];
    }
}

- (void)deleteAllCookies
{
    for (NSHTTPCookie *cookie in [self cookies]) {
        [self deleteCookie:cookie];
    }
}

@end
