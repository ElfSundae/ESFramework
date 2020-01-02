//
//  NSData+ESExtension.h
//  ESFramework
//
//  Created by Elf Sundae on 2016/01/23.
//  Copyright © 2014-2020 https://0x123.com All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (ESExtension)

/**
 * Creates and returns a new data object converted from the hexadecimal string.
 * @note Only hex digits supported in the hex string.
 */
+ (nullable instancetype)dataWithHexString:(NSString *)hexString;

/**
 * Converts the data to a UTF-8 encoded string.
 */
- (nullable NSString *)UTF8String;

/**
 * Converts the data to a lowercase hexadecimal string.
 */
- (NSString *)lowercaseHexString;

/**
 * Converts the data to an uppercase hexadecimal string.
 */
- (NSString *)uppercaseHexString;

/**
 * Converts the data as JSON to an Foundation object.
 */
- (nullable id)JSONObject;

/**
 * Converts the data as JSON to an Foundation object.
 */
- (nullable id)JSONObjectWithOptions:(NSJSONReadingOptions)options;

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

#pragma mark - Base64 Encoding

- (NSData *)base64EncodedData;
- (NSString *)base64EncodedString;
- (NSString *)base64EncodedURLSafeString;
- (nullable NSData *)base64DecodedData;
- (nullable NSString *)base64DecodedString;

#pragma mark - AES Encryption

// AES block size: 128-bit
// Mode: CBC
// Padding: PKCS7
// Key length: 16 (128-bit), 24 (192-bit), or 32 (256-bit)
// IV length: 16 (128-bit)

- (nullable NSData *)aesEncryptedDataWithKey:(NSData *)key IV:(NSData *)IV error:(NSError **)error;
- (nullable NSData *)aesEncryptedDataWithKeyString:(NSString *)key IVString:(NSString *)IV error:(NSError **)error;
- (nullable NSData *)aesEncryptedDataWithHexKey:(NSString *)key hexIV:(NSString *)IV error:(NSError **)error;

- (nullable NSData *)aesDecryptedDataWithKey:(NSData *)key IV:(NSData *)IV error:(NSError **)error;
- (nullable NSData *)aesDecryptedDataWithKeyString:(NSString *)key IVString:(NSString *)IV error:(NSError **)error;
- (nullable NSData *)aesDecryptedDataWithHexKey:(NSString *)key hexIV:(NSString *)IV error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
