//
//  NSString+ESExtension.h
//  ESFramework
//
//  Created by Elf Sundae on 2014/04/06.
//  Copyright (c) 2014 https://0x123.com All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (ESExtension)

/**
 * Generates an UUID string, e.g. "E621E1F8-C36C-495A-93FC-0C247A3E6E5F".
 */
+ (NSString *)UUIDString;

/**
 * Generates a random string that contains a-zA-Z0-9.
 */
+ (nullable NSString *)randomStringWithLength:(NSUInteger)length;

/**
 * Returns a NSNumber object created by parsing the string.
 */
- (nullable NSNumber *)numberValue;

@property (readonly) char charValue;
@property (readonly) unsigned char unsignedCharValue;
@property (readonly) short shortValue;
@property (readonly) unsigned short unsignedShortValue;
@property (readonly) unsigned int unsignedIntValue;
@property (readonly) long longValue;
@property (readonly) unsigned long unsignedLongValue;
@property (readonly) unsigned long long unsignedLongLongValue;
@property (readonly) NSUInteger unsignedIntegerValue;

/**
 * Returns a NSData object containing a representation of the string encoded using UTF-8 encoding.
 */
- (nullable NSData *)dataValue;

/**
 * Returns a new string made by trimming whitespace and newline characters.
 */
- (NSString *)trimmedString;

/**
 * Returns a percent escaped string following RFC 3986 for a query string key or value.
 */
- (nullable NSString *)URLEncodedString;

/**
 * Returns a new string made by replacing all percent encoded sequences with the matching UTF-8 characters.
 */
- (nullable NSString *)URLDecodedString;

- (BOOL)contains:(NSString*)string;
- (BOOL)containsCaseInsensitive:(NSString *)string;
- (BOOL)contains:(NSString*)string options:(NSStringCompareOptions)options;

- (NSString *)stringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement options:(NSStringCompareOptions)options;
- (NSString *)stringByReplacingWithDictionary:(NSDictionary *)dictionary options:(NSStringCompareOptions)options;

- (NSString *)stringByDeletingCharactersInSet:(NSCharacterSet *)characters;
- (NSString *)stringByDeletingCharactersInString:(NSString *)string;

/**
 * Returns the URL query parameters.
 */
- (nullable NSDictionary<NSString *, id> *)URLQueryParameters;

/**
 * Returns a newly created URL string added the given query parameters.
 */
- (NSString *)stringByAddingURLQueryParameters:(NSDictionary<NSString *, id> *)parameters;

@end

@interface NSString (ESHash)

- (NSData *)md5HashData;
- (NSString *)md5HashString;

- (NSData *)sha1HashData;
- (NSString *)sha1HashString;
- (NSData *)sha224HashData;
- (NSString *)sha224HashString;
- (NSData *)sha256HashData;
- (NSString *)sha256HashString;
- (NSData *)sha384HashData;
- (NSString *)sha384HashString;
- (NSData *)sha512HashData;
- (NSString *)sha512HashString;

- (NSData *)hmacMD5HashDataWithKey:(NSData *)key;
- (NSString *)hmacMD5HashStringWithKey:(NSString *)key;
- (NSData *)hmacSHA1HashDataWithKey:(NSData *)key;
- (NSString *)hmacSHA1HashStringWithKey:(NSString *)key;
- (NSData *)hmacSHA224HashDataWithKey:(NSData *)key;
- (NSString *)hmacSHA224HashStringWithKey:(NSString *)key;
- (NSData *)hmacSHA256HashDataWithKey:(NSData *)key;
- (NSString *)hmacSHA256HashStringWithKey:(NSString *)key;
- (NSData *)hmacSHA384HashDataWithKey:(NSData *)key;
- (NSString *)hmacSHA384HashStringWithKey:(NSString *)key;
- (NSData *)hmacSHA512HashDataWithKey:(NSData *)key;
- (NSString *)hmacSHA512HashStringWithKey:(NSString *)key;

- (NSData *)base64EncodedData;
- (NSString *)base64EncodedString;
- (NSString *)base64EncodedURLSafeString;
- (nullable NSData *)base64DecodedData;
- (nullable NSString *)base64DecodedString;

@end

@interface NSMutableString (ESExtension)

- (NSUInteger)replaceOccurrencesOfString:(NSString *)target withString:(NSString *)replacement options:(NSStringCompareOptions)options;

- (void)replaceWithDictionary:(NSDictionary<NSString *, NSString *> *)dictionary options:(NSStringCompareOptions)options;

@end

NS_ASSUME_NONNULL_END
