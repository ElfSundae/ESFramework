//
//  NSCharacterSet+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 2019/04/15.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCharacterSet (ESAdditions)

/**
 * Returns a character set containing the characters allowed in an encoded URL,
 * includes all alphanumeric characters and "-_.~", it conforms to
 * [RFC 3986](http://www.faqs.org/rfcs/rfc3986.html)
 */
@property (class, readonly, copy) NSCharacterSet *URLEncodingAllowedCharacterSet;

@end
