//
//  NSData+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 16/1/23.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "NSData+ESAdditions.h"
#include <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

@implementation NSData (ESAdditions)

- (NSString *)UTF8String
{
    return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}

- (NSString *)lowercaseHexString
{
    NSUInteger length = self.length;
    NSMutableString *hexString = [NSMutableString stringWithCapacity:length * 2];
    const unsigned char *bytes = (const unsigned char *)self.bytes;
    for (NSUInteger i = 0; i < length; i++) {
        [hexString appendFormat:@"%02.2hhx", bytes[i]];
    }
    return [hexString copy];
}

- (NSString *)uppercaseHexString
{
    return [[self lowercaseHexString] uppercaseString];
}

- (NSData *)md5HashData
{
    unsigned char buffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(self.bytes, (CC_LONG)self.length, buffer);
    return [NSData dataWithBytes:buffer length:CC_MD5_DIGEST_LENGTH];
}

- (NSString *)md5HashString
{
    return [[self md5HashData] lowercaseHexString];
}

- (NSData *)sha1HashData
{
    unsigned char buffer[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(self.bytes, (CC_LONG)self.length, buffer);
    return [NSData dataWithBytes:buffer length:CC_SHA1_DIGEST_LENGTH];
}

- (NSString *)sha1HashString
{
    return [[self sha1HashData] lowercaseHexString];
}

- (NSData *)sha224HashData
{
    unsigned char buffer[CC_SHA224_DIGEST_LENGTH];
    CC_SHA224(self.bytes, (CC_LONG)self.length, buffer);
    return [NSData dataWithBytes:buffer length:CC_SHA224_DIGEST_LENGTH];
}

- (NSString *)sha224HashString
{
    return [[self sha224HashData] lowercaseHexString];
}

- (NSData *)sha256HashData
{
    unsigned char buffer[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(self.bytes, (CC_LONG)self.length, buffer);
    return [NSData dataWithBytes:buffer length:CC_SHA256_DIGEST_LENGTH];
}

- (NSString *)sha256HashString
{
    return [[self sha256HashData] lowercaseHexString];
}

- (NSData *)sha384HashData
{
    unsigned char buffer[CC_SHA384_DIGEST_LENGTH];
    CC_SHA384(self.bytes, (CC_LONG)self.length, buffer);
    return [NSData dataWithBytes:buffer length:CC_SHA384_DIGEST_LENGTH];
}

- (NSString *)sha384HashString
{
    return [[self sha384HashData] lowercaseHexString];
}

- (NSData *)sha512HashData
{
    unsigned char buffer[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(self.bytes, (CC_LONG)self.length, buffer);
    return [NSData dataWithBytes:buffer length:CC_SHA512_DIGEST_LENGTH];
}

- (NSString *)sha512HashString
{
    return [[self sha512HashData] lowercaseHexString];
}

- (NSData *)es_hmacHashDataWithAlgorithm:(CCHmacAlgorithm)algorithm key:(NSData *)key
{
    size_t size = 0;
    switch (algorithm) {
        case kCCHmacAlgMD5:
            size = CC_MD5_DIGEST_LENGTH;
            break;
        case kCCHmacAlgSHA1:
            size = CC_SHA1_DIGEST_LENGTH;
            break;
        case kCCHmacAlgSHA224:
            size = CC_SHA224_DIGEST_LENGTH;
            break;
        case kCCHmacAlgSHA256:
            size = CC_SHA256_DIGEST_LENGTH;
            break;
        case kCCHmacAlgSHA384:
            size = CC_SHA384_DIGEST_LENGTH;
            break;
        case kCCHmacAlgSHA512:
            size = CC_SHA512_DIGEST_LENGTH;
            break;
        default:
            [NSException raise:NSInvalidArgumentException format:@"Invalid hmac algorithm"];
            break;
    }

    unsigned char buffer[size];
    CCHmac(algorithm, key.bytes, key.length, self.bytes, self.length, buffer);
    return [NSData dataWithBytes:buffer length:(NSUInteger)size];
}

- (NSString *)es_hmacHashStringWithAlgorithm:(CCHmacAlgorithm)algorithm key:(NSString *)key
{
    return [[self es_hmacHashDataWithAlgorithm:algorithm
                                           key:[key dataUsingEncoding:NSUTF8StringEncoding]]
            lowercaseHexString];
}

- (NSData *)hmacMD5HashDataWithKey:(NSData *)key
{
    return [self es_hmacHashDataWithAlgorithm:kCCHmacAlgMD5 key:key];
}

- (NSString *)hmacMD5HashStringWithKey:(NSString *)key
{
    return [self es_hmacHashStringWithAlgorithm:kCCHmacAlgMD5 key:key];
}

- (NSData *)hmacSHA1HashDataWithKey:(NSData *)key
{
    return [self es_hmacHashDataWithAlgorithm:kCCHmacAlgSHA1 key:key];
}

- (NSString *)hmacSHA1HashStringWithKey:(NSString *)key
{
    return [self es_hmacHashStringWithAlgorithm:kCCHmacAlgSHA1 key:key];
}

- (NSData *)hmacSHA224HashDataWithKey:(NSData *)key
{
    return [self es_hmacHashDataWithAlgorithm:kCCHmacAlgSHA224 key:key];
}

- (NSString *)hmacSHA224HashStringWithKey:(NSString *)key
{
    return [self es_hmacHashStringWithAlgorithm:kCCHmacAlgSHA224 key:key];
}

- (NSData *)hmacSHA256HashDataWithKey:(NSData *)key
{
    return [self es_hmacHashDataWithAlgorithm:kCCHmacAlgSHA256 key:key];
}

- (NSString *)hmacSHA256HashStringWithKey:(NSString *)key
{
    return [self es_hmacHashStringWithAlgorithm:kCCHmacAlgSHA256 key:key];
}

- (NSData *)hmacSHA384HashDataWithKey:(NSData *)key
{
    return [self es_hmacHashDataWithAlgorithm:kCCHmacAlgSHA384 key:key];
}

- (NSString *)hmacSHA384HashStringWithKey:(NSString *)key
{
    return [self es_hmacHashStringWithAlgorithm:kCCHmacAlgSHA384 key:key];
}

- (NSData *)hmacSHA512HashDataWithKey:(NSData *)key
{
    return [self es_hmacHashDataWithAlgorithm:kCCHmacAlgSHA512 key:key];
}

- (NSString *)hmacSHA512HashStringWithKey:(NSString *)key
{
    return [self es_hmacHashStringWithAlgorithm:kCCHmacAlgSHA512 key:key];
}

- (NSData *)base64EncodedData
{
    return [self base64EncodedDataWithOptions:0];
}

- (NSString *)base64EncodedString
{
    return [self base64EncodedStringWithOptions:0];
}

- (NSString *)base64EncodedURLSafeString
{
    return [[[self.base64EncodedString
              stringByReplacingOccurrencesOfString:@"+" withString:@"-"]
             stringByReplacingOccurrencesOfString:@"/" withString:@"_"]
            stringByReplacingOccurrencesOfString:@"=" withString:@""];
}

- (NSData *)base64DecodedData
{
    return [[NSData alloc] initWithBase64EncodedData:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
}

- (NSString *)base64DecodedString
{
    return self.base64DecodedData.UTF8String;
}

@end
