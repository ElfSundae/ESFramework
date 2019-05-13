//
//  NSData+ESHash.h
//  ESFramework
//
//  Created by Elf Sundae on 16/1/23.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonHMAC.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (ESHash)

#pragma mark - String Value

/**
 * Converts data to an UTF-8 encoded string.
 */
- (NSString *)UTF8String;

/**
 * Converts data to an uppercase hexadecimal string.
 */
- (NSString *)uppercaseHexString;

/**
 * Converts data to a lowercase hexadecimal string.
 */
- (NSString *)lowercaseHexString;

#pragma mark - MD5 Digest

- (NSData *)md5HashData;
- (NSString *)md5HashString;

#pragma mark - SHA Digest

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

#pragma mark - HMAC Digest

- (NSData *)hmacHashDataWithAlgorithm:(CCHmacAlgorithm)algorithm key:(id)key;
- (NSString *)hmacHashStringWithAlgorithm:(CCHmacAlgorithm)algorithm key:(id)key;

#pragma mark - Base64

- (NSData *)base64EncodedData;
- (NSString *)base64EncodedString;
- (NSString *)base64EncodedURLSafeString;
- (nullable NSData *)base64DecodedData;
- (nullable NSString *)base64DecodedString;

@end

NS_ASSUME_NONNULL_END
