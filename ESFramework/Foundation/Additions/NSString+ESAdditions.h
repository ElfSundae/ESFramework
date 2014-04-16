//
//  NSString+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-6.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

@import Foundation;

@interface NSString (ESAdditions)

+ (NSString *)newUUID;

/**
 * NSCaseInsensitiveSearch
 */
- (BOOL)containsString:(NSString*)string;
- (BOOL)containsString:(NSString*)string options:(NSStringCompareOptions)options;
/**
 * Trims whitespaceAndNewline
 */
- (NSString *)trim;

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

/**
 * Parse query string to dictionary.
 */
- (NSDictionary *)queryDictionary;

@end

