//
//  NSHTTPCookieStorage+ESExtension.m
//  ESFramework
//
//  Created by Elf Sundae on 2019/05/05.
//  Copyright © 2019 https://0x123.com. All rights reserved.
//

#import "NSHTTPCookieStorage+ESExtension.h"

@implementation NSHTTPCookieStorage (ESExtension)

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
