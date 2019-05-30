//
//  NSHTTPCookieStorage+ESExtension.h
//  ESFramework
//
//  Created by Elf Sundae on 2019/05/05.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSHTTPCookieStorage (ESExtension)

/**
 * Deletes all cookies which to send to the given URL.
 */
- (void)deleteCookiesForURL:(NSURL *)URL;

/**
 * Deletes all cookies from the cookie storage.
 */
- (void)deleteAllCookies;

@end

NS_ASSUME_NONNULL_END
