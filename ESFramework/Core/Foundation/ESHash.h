//
//  ESHash.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-13.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * All returned hex string are lower case.
 */
@interface NSData (ESHash)

- (NSData *)es_md5Hash;
- (NSString *)es_md5HashString;

- (NSData *)es_sha1Hash;
- (NSString *)es_sha1HashString;
- (NSData *)es_sha224Hash;
- (NSString *)es_sha224HashString;
- (NSData *)es_sha256Hash;
- (NSString *)es_sha256HashString;
- (NSData *)es_sha384Hash;
- (NSString *)es_sha384HashString;
- (NSData *)es_sha512Hash;
- (NSString *)es_sha512HashString;

- (NSData *)es_base64Encoded;
- (NSString *)es_base64EncodedString;
- (NSData *)es_base64Decoded;
- (NSString *)es_base64DecodedString;

@end

@interface NSString (ESHash)

- (NSData *)es_md5Hash;
- (NSString *)es_md5HashString;

- (NSData *)es_sha1Hash;
- (NSString *)es_sha1HashString;
- (NSData *)es_sha224Hash;
- (NSString *)es_sha224HashString;
- (NSData *)es_sha256Hash;
- (NSString *)es_sha256HashString;
- (NSData *)es_sha384Hash;
- (NSString *)es_sha384HashString;
- (NSData *)es_sha512Hash;
- (NSString *)es_sha512HashString;

- (NSData *)es_base64Encoded;
- (NSString *)es_base64EncodedString;
- (NSData *)es_base64Decoded;
- (NSString *)es_base64DecodedString;

@end
