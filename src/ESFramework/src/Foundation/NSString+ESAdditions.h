//
//  NSString+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-6.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ESAdditions)
- (BOOL)containsString:(NSString*)string;
- (BOOL)containsString:(NSString*)string options:(NSStringCompareOptions)options;

- (NSString *)newUUID;

/**
 * Returns MD5 hash, Lower-case.
 */
- (NSString *)md5Hash;
/**
 * Returns MD5 hash, Upper-case.
 */
- (NSString *)md5HashWithUppercase;

/**
 * Add percent escapes for characters in @":/?#[]@!$&'()*+,;="
 */
- (NSString *)URLEncode;
/**
 * Calls <code>-stringByReplacingPercentEscapesUsingEncoding:</code>
 */
- (NSString *)URLDecode;

/**
 * Append URL query string from #queryDictionary.
 * Supports 'array' params, like "?key[]=value1&key[]=value2".
 */
- (NSString *)stringByAppendingQueryDictionary:(NSDictionary *)queryDictionary;

@end

