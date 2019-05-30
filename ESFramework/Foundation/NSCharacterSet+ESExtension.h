//
//  NSCharacterSet+ESExtension.h
//  ESFramework
//
//  Created by Elf Sundae on 2019/04/15.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSCharacterSet (ESExtension)

/**
 * Returns a character set containing the characters allowed in an encoded URL,
 * includes all alphanumeric characters and "-_.~", it conforms to
 * [RFC 3986](http://www.faqs.org/rfcs/rfc3986.html)
 */
+ (NSCharacterSet *)URLEncodingAllowedCharacterSet;

@end

NS_ASSUME_NONNULL_END
