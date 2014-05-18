//
//  NSString+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-6.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSRegularExpression+ESAdditions.h"

@interface NSString (ESAdditions)

- (BOOL)contains:(NSString*)string;
- (BOOL)containsStringCaseInsensitive:(NSString *)string;
- (BOOL)contains:(NSString*)string options:(NSStringCompareOptions)options;

- (BOOL)isEqualToStringCaseInsensitive:(NSString *)aString;

/**
 * Regex
 */
- (NSRange)match:(NSString *)pattern;
- (NSRange)match:(NSString *)pattern caseInsensitive:(BOOL)caseInsensitive;
- (BOOL)isMatch:(NSString *)pattern;
- (BOOL)isMatch:(NSString *)pattern caseInsensitive:(BOOL)caseInsensitive;

/**
 * Trims `[NSCharacterSet whitespaceAndNewlineCharacterSet]`
 */
- (NSString *)trim;

- (BOOL)isEmpty;

/**
 * Detect whether file exists.
 */
- (BOOL)fileExists;
- (BOOL)fileExists:(BOOL *)isDirectory;

/**
 * Asynchronously write file.
 * It will create directories automatically if not exists.
 */
- (void)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile withBlock:(void (^)(BOOL result))block;

- (NSString *)append:(NSString *)format, ...;
- (NSString *)appendPathComponent:(NSString *)format, ...;
- (NSString *)appendPathExtension:(NSString *)extension;
- (NSString *)appendQueryDictionary:(NSDictionary *)queryDictionary;

- (NSString *)replace:(NSString *)string with:(NSString *)replacement;
- (NSString *)replaceCaseInsensitive:(NSString *)string with:(NSString *)replacement;
- (NSString *)replace:(NSString *)string with:(NSString *)replacement options:(NSStringCompareOptions)options;
- (NSString *)replaceInRange:(NSRange)range with:(NSString *)replacement;
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

/**
 * 36bits, e.g. @"B743154C-087E-4E7C-84AC-2573AAB940AD"
 */
+ (NSString *)newUUID;
/**
 * 16bits, e.g. @"1f3b3d5cb1c893ef0fabfdfced53c9e2"
 */
+ (NSString *)newUUIDWithMD5;

/**
 * Returns the iTunes item identifier(ID) from the iTunes Store URL, returns `nil` if parsing failed.
 * All types of iTunes link are supported, include scheme http[s], itms, itms-apps, etc.
 *
 * e.g. The url https://itunes.apple.com/us/app/qq-cai-xin/id520005183?mt=8 will get @"520005183".
 *
 * Supports all type iTunes links like Apps, Books, Music, Music Videos, Audio Book, Podcast, Movie, etc.
 */
- (NSString *)iTunesItemID;
/**
 * https://itunes.apple.com/app/idxxxxxxx
 */
- (NSString *)appLink;
/**
 * itms-apps://itunes.apple.com/app/idxxxxx
 */
- (NSString *)appLinkForAppStore;
/**
 * itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=xxxxxxx
 */
- (NSString *)appReviewLinkForAppStore;

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

- (NSRegularExpression *)regex;
- (NSRegularExpression *)regexCaseInsensitive;
- (NSRegularExpression *)regexWithOptions:(NSRegularExpressionOptions)options;

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSMutableString

@interface NSMutableString (ESAdditions)
- (void)replace:(NSString *)string to:(NSString *)replacement options:(NSStringCompareOptions)options;
- (void)replace:(NSString *)string to:(NSString *)replacement;
- (void)replaceCaseInsensitive:(NSString *)string to:(NSString *)replacement;
- (void)replaceInRange:(NSRange)range to:(NSString *)replacement;
- (void)replaceRegex:(NSString *)pattern with:(NSString *)replacement caseInsensitive:(BOOL)caseInsensitive;
@end
