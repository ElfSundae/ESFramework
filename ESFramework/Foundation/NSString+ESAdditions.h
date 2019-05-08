//
//  NSString+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-6.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (ESAdditions)

- (NSString *)trim;

- (BOOL)contains:(NSString*)string;
- (BOOL)containsCaseInsensitive:(NSString *)string;
- (BOOL)contains:(NSString*)string options:(NSStringCompareOptions)options;

- (NSString *)stringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement options:(NSStringCompareOptions)options;
- (NSString *)stringByReplacingWithDictionary:(NSDictionary *)dictionary options:(NSStringCompareOptions)options;

- (NSString *)stringByDeletingCharactersInSet:(NSCharacterSet *)characters;
- (NSString *)stringByDeletingCharactersInString:(NSString *)string;

/**
 * Returns a URL-encoded string in which all non-alphanumeric characters
 * except -_.~ have been replaced with a percent (%) sign followed by two hex digits,
 * it conforms to [RFC 3986](http://www.faqs.org/rfcs/rfc3986.html)
 */
- (NSString *)URLEncoded;

/**
 * Returns a URL-decoded string.
 */
- (NSString *)URLDecoded;

/**
 * Returns the query components parsed as a dictionary for the URL string.
 * For URL http://foo.bar?key=value&arr[]=value&arr[]=value1 , the query dictionary will be:
 * { key:value, arr:[value, value1] }.
 */
- (nullable NSDictionary<NSString *, id> *)queryDictionary;

/**
 * Returns a newly created URL string added the given query dictionary.
 */
- (NSString *)stringByAddingQueryDictionary:(NSDictionary<NSString *, id> *)queryDictionary;

/**
 * Returns a string that escaped for HTML.
 * e.g. '<' becomes '&lt;' , '>' to '&gt;', '&' become '&amp;'
 *
 * This will only cover characters from table
 * A.2.2 of http://www.w3.org/TR/xhtml1/dtds.html#a_dtd_Special_characters
 * which is what you want for a unicode encoded webpage.
 */
- (NSString *)stringByEncodingHTMLEntities;

/**
 * Get a string where internal characters that are escaped for HTML are unescaped.
 *
 * For example, '&amp;' becomes '&'
 * Handles &#32; and &#x32; cases as well
 *
 */
- (NSString *)stringByDecodingHTMLEntities;

@end

#pragma mark - NSMutableString (ESAdditions)

@interface NSMutableString (ESAdditions)

- (NSUInteger)replaceOccurrencesOfString:(NSString *)target withString:(NSString *)replacement options:(NSStringCompareOptions)options;

- (void)replaceWithDictionary:(NSDictionary<NSString *, NSString *> *)dictionary options:(NSStringCompareOptions)options;

@end

NS_ASSUME_NONNULL_END
