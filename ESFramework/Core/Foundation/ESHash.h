//
//  ESHash.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-13.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonHMAC.h>

/**
 * All returned hex string are lower case.
 */
@interface NSData (ESHash)

- (NSData *)es_md5HashData;
- (NSString *)es_md5HashString;

- (NSData *)es_sha1HashData;
- (NSString *)es_sha1HashString;
- (NSData *)es_sha224HashData;
- (NSString *)es_sha224HashString;
- (NSData *)es_sha256HashData;
- (NSString *)es_sha256HashString;
- (NSData *)es_sha384HashData;
- (NSString *)es_sha384HashString;
- (NSData *)es_sha512HashData;
- (NSString *)es_sha512HashString;

- (NSData *)es_HmacHashDataWithAlgorithm:(CCHmacAlgorithm)algorithm key:(id)key;
- (NSString *)es_HmacHashStringWithAlgorithm:(CCHmacAlgorithm)algorithm key:(id)key;

- (NSData *)es_base64Encoded;
- (NSString *)es_base64EncodedString;
- (NSData *)es_base64Decoded;
- (NSString *)es_base64DecodedString;

@end

@interface NSString (ESHash)

- (NSData *)es_md5HashData;
- (NSString *)es_md5HashString;

- (NSData *)es_sha1HashData;
- (NSString *)es_sha1HashString;
- (NSData *)es_sha224HashData;
- (NSString *)es_sha224HashString;
- (NSData *)es_sha256HashData;
- (NSString *)es_sha256HashString;
- (NSData *)es_sha384HashData;
- (NSString *)es_sha384HashString;
- (NSData *)es_sha512HashData;
- (NSString *)es_sha512HashString;

- (NSData *)es_HmacHashDataWithAlgorithm:(CCHmacAlgorithm)algorithm key:(id)key;
- (NSString *)es_HmacHashStringWithAlgorithm:(CCHmacAlgorithm)algorithm key:(id)key;

- (NSData *)es_base64Encoded;
- (NSString *)es_base64EncodedString;
- (NSData *)es_base64Decoded;
- (NSString *)es_base64DecodedString;

@end
