//
//  NSString+ESHash.h
//  ESFramework
//
//  Created by Elf Sundae on 16/1/23.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ESDefines.h"

@interface NSString (ESHash)

/// =============================================
/// @name MD5 Digest
/// =============================================

- (NSData *)es_md5HashData;
- (NSString *)es_md5HashString;

/// =============================================
/// @name SHA Digest
/// =============================================

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

/// =============================================
/// @name Hmac Digest
/// =============================================

- (NSData *)es_HmacHashDataWithAlgorithm:(uint32_t /* CCHmacAlgorithm */)algorithm key:(id)key;
- (NSString *)es_HmacHashStringWithAlgorithm:(uint32_t /* CCHmacAlgorithm */)algorithm key:(id)key;

/// =============================================
/// @name Base64
/// =============================================

- (NSData *)es_base64Encoded;
- (NSString *)es_base64EncodedString;
- (NSString *)es_base64EncodedURLSafeString;
- (NSData *)es_base64Decoded;
- (NSString *)es_base64DecodedString;
- (NSString *)es_base64DecodedStringFromURLSafeString;

@end
