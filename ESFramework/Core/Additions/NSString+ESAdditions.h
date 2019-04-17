//
//  NSString+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-6.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+ESGTMHTML.h"

@interface NSString (ESAdditions)

/**
 * Compare string ignoring case.
 */
- (BOOL)isEqualToStringCaseInsensitive:(NSString *)aString;

/**
 * Indicates whether the length of string is 0.
 */
- (BOOL)isEmpty;

/**
 * Trims with whitespace and new line.
 */
- (NSString *)trim;

/**
 * Trims with the given characters.
 */
- (NSString *)trimWithCharactersInString:(NSString *)string;

- (BOOL)contains:(NSString*)string;
- (BOOL)containsCaseInsensitive:(NSString *)string;
- (BOOL)contains:(NSString*)string options:(NSStringCompareOptions)options;

- (NSRange)match:(NSString *)pattern;
- (NSRange)match:(NSString *)pattern caseInsensitive:(BOOL)caseInsensitive;
- (BOOL)isMatch:(NSString *)pattern;
- (BOOL)isMatch:(NSString *)pattern caseInsensitive:(BOOL)caseInsensitive;

- (NSString *)stringByReplacing:(NSString *)string with:(NSString *)replacement;
- (NSString *)stringByReplacingCaseInsensitive:(NSString *)string with:(NSString *)replacement;
- (NSString *)stringByReplacing:(NSString *)string with:(NSString *)replacement options:(NSStringCompareOptions)options;
- (NSString *)stringByReplacingInRange:(NSRange)range with:(NSString *)replacement;
- (NSString *)stringByReplacingWithDictionary:(NSDictionary *)dictionary options:(NSStringCompareOptions)options;

/**
 * The `replacement` is treated as a template, with $0 being replaced by the
 * contents of the matched range, $1 by the contents of the first capture group,
 * and so on.
 * Additional digits beyond the maximum required to represent
 * the number of capture groups will be treated as ordinary characters, as will
 * a $ not followed by digits.  Backslash will escape both $ and itself.
 */
- (NSString *)stringByReplacingRegex:(NSString *)pattern with:(NSString *)replacement caseInsensitive:(BOOL)caseInsensitive;

- (NSString *)stringByDeletingCharactersInSet:(NSCharacterSet *)characters;
- (NSString *)stringByDeletingCharactersInString:(NSString *)string;

- (NSArray<NSString *> *)splitWith:(NSString *)separator;
- (NSArray<NSString *> *)splitWithCharacterSet:(NSCharacterSet *)separator;

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
- (NSDictionary<NSString *, id> *)queryDictionary;

/**
 * Returns a newly created URL string added the given query dictionary.
 */
- (NSString *)stringByAddingQueryDictionary:(NSDictionary<NSString *, id> *)queryDictionary;

/**
 * Get a string where internal characters that need escaping for HTML are escaped,
 * code grabbed from Google GTMNSString+HTML.
 *
 * Returns `nil` if failure.
 *
 * Example of table:
 * @code
 * // Taken from http://www.w3.org/TR/xhtml1/dtds.html#a_dtd_Special_characters
 * // This is table A.2.2 Special Characters
 * static ESHTMLEscapeMap gUnicodeHTMLEscapeMap[] = {
 *      // C0 Controls and Basic Latin
 *      { @"&quot;", 34 },
 *      { @"&amp;", 38 },
 *      { @"&apos;", 39 },
 *      { @"&lt;", 60 },
 *      { @"&gt;", 62 },
 *
 *      // Latin Extended-A
 *      { @"&OElig;", 338 },
 *      { @"&oelig;", 339 },
 *
 *      //....
 * };
 * @endcode
 *
 * Example of usage:
 * @code
 * [self stringByEncodingHTMLEntitiesUsingTable:__gMyUnicodeHTMLEscapeMap size:sizeof(__gMyUnicodeHTMLEscapeMap) escapeUnicode:NO];
 * @endcode
 *
 * @param table     escaping table
 * @param escapeUnicode should escape unicode
 *
 * @see http://google-toolbox-for-mac.googlecode.com/svn/trunk/Foundation/GTMNSString+HTML.h
 * @see https://github.com/mwaterfall/MWFeedParser/blob/master/Classes/GTMNSString%2BHTML.h
 *
 */
- (NSString *)stringByEncodingHTMLEntitiesUsingTable:(ESHTMLEscapeMap *)table size:(NSUInteger)size escapeUnicode:(BOOL)escapeUnicode;

/**
 * Returns a string that escaped for HTML.
 * e.g. '<' becomes '&lt;' , '>' to '&gt;', '&' become '&amp;'
 *
 * This will only cover characters from table
 * A.2.2 of http://www.w3.org/TR/xhtml1/dtds.html#a_dtd_Special_characters
 * which is what you want for a unicode encoded webpage.
 */
- (NSString *)stringByEncodingHTMLEntitiesForUnicode;
/**
 *  For example, '&' become '&amp;'
 *  All non-mapped characters (unicode that don't have a &keyword; mapping)
 *  will be converted to the appropriate &#xxx; value. If your webpage is
 *  unicode encoded (UTF16 or UTF8) use `stringByEncodingHTMLEntitiesForUnicode` instead as it is
 *  faster, and produces less bloated and more readable HTML (as long as you
 *  are using a unicode compliant HTML reader).
 *
 */
- (NSString *)stringByEncodingHTMLEntitiesForASCII;

/**
 * Get a string where internal characters that are escaped for HTML are unescaped
 *
 * For example, '&amp;' becomes '&'
 * Handles &#32; and &#x32; cases as well
 *
 */
- (NSString *)stringByDecodingHTMLEntities;

@end
