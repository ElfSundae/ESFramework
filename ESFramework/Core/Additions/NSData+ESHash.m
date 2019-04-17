//
//  NSData+ESHash.m
//  ESFramework
//
//  Created by Elf Sundae on 16/1/23.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "NSData+ESHash.h"

@implementation NSData (ESHash)

- (NSString *)stringValue
{
    return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}

- (NSString *)hexStringValue
{
    NSMutableString *hexString = [NSMutableString string];
    const unsigned char *p = self.bytes;
    for (NSUInteger i = 0; i < self.length; ++i) {
        [hexString appendFormat:@"%02x", *p++];
    }
    return [hexString copy];
}

- (NSData *)md5HashData
{
    unsigned char buffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(self.bytes, (CC_LONG)self.length, buffer);
    return [NSData dataWithBytes:buffer length:CC_MD5_DIGEST_LENGTH];
}

- (NSString *)md5HashString
{
    return [[self md5HashData] hexStringValue];
}

- (NSData *)sha1HashData
{
    unsigned char buffer[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(self.bytes, (CC_LONG)self.length, buffer);
    return [NSData dataWithBytes:buffer length:CC_SHA1_DIGEST_LENGTH];
}

- (NSString *)sha1HashString
{
    return [[self sha1HashData] hexStringValue];
}

- (NSData *)sha224HashData
{
    unsigned char buffer[CC_SHA224_DIGEST_LENGTH];
    CC_SHA224(self.bytes, (CC_LONG)self.length, buffer);
    return [NSData dataWithBytes:buffer length:CC_SHA224_DIGEST_LENGTH];
}
- (NSString *)sha224HashString
{
    return [[self sha224HashData] hexStringValue];
}

- (NSData *)sha256HashData
{
    unsigned char buffer[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(self.bytes, (CC_LONG)self.length, buffer);
    return [NSData dataWithBytes:buffer length:CC_SHA256_DIGEST_LENGTH];
}
- (NSString *)sha256HashString
{
    return [[self sha256HashData] hexStringValue];
}

- (NSData *)sha384HashData
{
    unsigned char buffer[CC_SHA384_DIGEST_LENGTH];
    CC_SHA384(self.bytes, (CC_LONG)self.length, buffer);
    return [NSData dataWithBytes:buffer length:CC_SHA384_DIGEST_LENGTH];
}
- (NSString *)sha384HashString
{
    return [[self sha384HashData] hexStringValue];
}

- (NSData *)sha512HashData
{
    unsigned char buffer[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(self.bytes, (CC_LONG)self.length, buffer);
    return [NSData dataWithBytes:buffer length:CC_SHA512_DIGEST_LENGTH];
}
- (NSString *)sha512HashString
{
    return [[self sha512HashData] hexStringValue];
}

- (NSData *)hmacHashDataWithAlgorithm:(CCHmacAlgorithm)algorithm key:(id)key
{
    NSData *keyData = nil;
    if ([key isKindOfClass:[NSData class]]) {
        keyData = (NSData *)key;
    } else if ([key isKindOfClass:[NSString class]]) {
        keyData = [(NSString *)key dataUsingEncoding:NSUTF8StringEncoding];
    } else {
        printf("%s: 'key' must be a NSData or a NSString.\n", __PRETTY_FUNCTION__);
        return nil;
    }
    size_t size = 0;
    if (kCCHmacAlgSHA1 == algorithm) {
        size = CC_SHA1_DIGEST_LENGTH;
    } else if (kCCHmacAlgMD5 == algorithm) {
        size = CC_MD5_DIGEST_LENGTH;
    } else if (kCCHmacAlgSHA224 == algorithm) {
        size = CC_SHA224_DIGEST_LENGTH;
    } else if (kCCHmacAlgSHA256 == algorithm) {
        size = CC_SHA256_DIGEST_LENGTH;
    } else if (kCCHmacAlgSHA384 == algorithm) {
        size = CC_SHA384_DIGEST_LENGTH;
    } else if (kCCHmacAlgSHA512 == algorithm) {
        size = CC_SHA512_DIGEST_LENGTH;
    } else {
        printf("%s: 'algorithm' is wrong.\n", __PRETTY_FUNCTION__);
        return nil;
    }

    unsigned char buffer[size];
    CCHmac(algorithm, keyData.bytes, keyData.length, self.bytes, self.length, buffer);
    return [NSData dataWithBytes:buffer length:(NSUInteger)size];
}

- (NSString *)hmacHashStringWithAlgorithm:(CCHmacAlgorithm)algorithm key:(id)key
{
    return [[self hmacHashDataWithAlgorithm:algorithm key:key] hexStringValue];
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
    return self.base64DecodedData.stringValue;
}

@end
