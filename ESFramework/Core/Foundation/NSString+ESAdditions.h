//
//  NSString+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-6.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ESAdditions)

/**
 * NSCaseInsensitiveSearch
 */
- (BOOL)containsString:(NSString*)string;
- (BOOL)containsString:(NSString*)string options:(NSStringCompareOptions)options;

- (BOOL)isEqualToStringCaseInsensitive:(NSString *)aString;

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
/**
 * Case-insensitive.
 */
- (NSString *)replace:(NSString *)string with:(NSString *)replacement;

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

@end

