//
//  NSString+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-6.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

@import Foundation;

@interface NSString (ESAdditions)

/**
 * Asynchronously write file.
 * It will create directories if not exists.
 */
- (void)writeToFile:(NSString *)path withBlock:(void (^)(BOOL result, NSError *error))block;

/**
 * 36bits
 */
+ (NSString *)newUUID;

/**
 * `md5([self newUUID])` **Uppercase** 16bits
 */
+ (NSString *)newUUIDWithMD5;

/**
 * NSCaseInsensitiveSearch
 */
- (BOOL)containsString:(NSString*)string;
- (BOOL)containsString:(NSString*)string options:(NSStringCompareOptions)options;
/**
 * Trims `[NSCharacterSet whitespaceAndNewlineCharacterSet]`
 */
- (NSString *)trim;

- (BOOL)isEmpty;

/**
 * Add percent escapes for characters in @":/?#[]@!$&'()*+,;="
 */
- (NSString *)URLEncode;
/**
 * Calls `-stringByReplacingPercentEscapesUsingEncoding:`
 */
- (NSString *)URLDecode;

/**
 * Append URL query string from `queryDictionary`.
 * Supports 'array' params, like "?key[]=value1&key[]=value2".
 */
- (NSString *)stringByAppendingQueryDictionary:(NSDictionary *)queryDictionary;

/**
 * Parse query string to dictionary.
 */
- (NSDictionary *)queryDictionary;

@end

