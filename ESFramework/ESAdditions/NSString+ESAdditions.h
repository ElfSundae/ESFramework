//
//  NSString+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-6.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESDefines.h"
#import "NSString+ESGTMHTML.h"
#import "NSRegularExpression+ESAdditions.h"

@interface NSString (ESAdditions)

- (BOOL)contains:(NSString*)string;
- (BOOL)containsStringCaseInsensitive:(NSString *)string;
- (BOOL)contains:(NSString*)string options:(NSStringCompareOptions)options;

/**
 * Compare string ignoring case
 */
- (BOOL)isEqualToStringCaseInsensitive:(NSString *)aString;

/**
 * Trims with whitespace and new line
 */
- (NSString *)trim;
- (NSString *)trimWithCharactersInString:(NSString *)string;

- (BOOL)isEmpty;

/**
 * Detect whether file exists for this path.
 */
- (BOOL)fileExists;
- (BOOL)fileExists:(BOOL *)isDirectory;

/**
 * Asynchronously write string to file.
 * It will create directories automatically if not exists.
 */
- (void)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile withBlock:(void (^)(BOOL result))block;

- (NSString *)append:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);
- (NSString *)appendPathComponent:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);
- (NSString *)appendPathExtension:(NSString *)extension;
/**
 * Append URL query string from `queryDictionary`.
 * Supports 'array' params, like "?key[]=value1&key[]=value2".
 *
 * In `queryDictionary`, the keys must be NSString/NSNumber, the values must be
 * NSString/NSNumber/NSArray with NSString,NSNumber.
 */
- (NSString *)appendQueryDictionary:(NSDictionary *)queryDictionary;


- (NSString *)replace:(NSString *)string with:(NSString *)replacement;
- (NSString *)replaceCaseInsensitive:(NSString *)string with:(NSString *)replacement;
- (NSString *)replace:(NSString *)string with:(NSString *)replacement options:(NSStringCompareOptions)options;
- (NSString *)replaceInRange:(NSRange)range with:(NSString *)replacement;
- (NSString *)stringByReplacingWithDictionary:(NSDictionary *)dictionary options:(NSStringCompareOptions)options;

/**
 * The `replacement` is treated as a template, with $0 being replaced by the 
 * contents of the matched range, $1 by the contents of the first capture group, 
 * and so on. 
 * Additional digits beyond the maximum required to represent
 * the number of capture groups will be treated as ordinary characters, as will
 * a $ not followed by digits.  Backslash will escape both $ and itself.
 */
- (NSString *)replaceRegex:(NSString *)pattern with:(NSString *)replacement caseInsensitive:(BOOL)caseInsensitive;

- (NSArray *)splitWith:(NSString *)separator;
- (NSArray *)splitWithCharacterSet:(NSCharacterSet *)separator;

- (NSString *)stringByDeletingCharactersInSet:(NSCharacterSet *)characters;
- (NSString *)stringByDeletingCharactersInString:(NSString *)string;

/**
 * Add percent escapes for characters for @":/?#[]@!$&'()*+,;="
 */
- (NSString *)URLEncode;

/**
 * Replaces "+" to " ", then calls `-stringByReplacingPercentEscapesUsingEncoding:`
 */
- (NSString *)URLDecode;

/**
 * Parse query string (http://foo.bar?key=value) to dictionary ({key:value}).
 */
- (NSDictionary *)queryDictionary;

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
 * 	// C0 Controls and Basic Latin
 * 	{ @"&quot;", 34 },
 * 	{ @"&amp;", 38 },
 * 	{ @"&apos;", 39 },
 * 	{ @"&lt;", 60 },
 * 	{ @"&gt;", 62 },
 *
 * 	// Latin Extended-A
 * 	{ @"&OElig;", 338 },
 * 	{ @"&oelig;", 339 },
 *
 * 	//....
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

/**
 * @"camelCase" to @"camel<replace>case"
 * @"CamelCase" to @"camel<replace>case"
 *
 * It will convert all "\W" to "_", and replace Uppercase to "_"+lowercase.
 */
- (NSString *)stringByReplacingCamelcaseWith:(NSString *)replace;
/**
 * @"camelCase" to @"camel_case"
 * @"CamelCase" to @"camel_case"
 *
 * @see -stringByReplacingCamelcaseWith:
 */
- (NSString *)stringByReplacingCamelcaseWithUnderscore;

///=============================================
/// @name NSRegularExpression Maker
///=============================================

- (NSRegularExpression *)regex;
- (NSRegularExpression *)regexCaseInsensitive;
- (NSRegularExpression *)regexWithOptions:(NSRegularExpressionOptions)options;

/**
 * Regex
 */
- (NSRange)match:(NSString *)pattern;
- (NSRange)match:(NSString *)pattern caseInsensitive:(BOOL)caseInsensitive;
- (BOOL)isMatch:(NSString *)pattern;
- (BOOL)isMatch:(NSString *)pattern caseInsensitive:(BOOL)caseInsensitive;


@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSMutableString

@interface NSMutableString (ESAdditions)

- (void)replace:(NSString *)string to:(NSString *)replacement options:(NSStringCompareOptions)options;
- (void)replace:(NSString *)string to:(NSString *)replacement;
- (void)replaceCaseInsensitive:(NSString *)string to:(NSString *)replacement;
- (void)replaceInRange:(NSRange)range to:(NSString *)replacement;
- (void)replaceRegex:(NSString *)pattern to:(NSString *)replacement caseInsensitive:(BOOL)caseInsensitive;
/**
 * `dictionary` is NSString keyed, vlaued with NSString or NSNumber.
 * `options` can be any value including `NSRegularExpressionSearch`.
 */
- (void)replaceWithDictionary:(NSDictionary *)dictionary options:(NSStringCompareOptions)options;

@end