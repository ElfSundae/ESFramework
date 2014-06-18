//
//  ESHash.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-13.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESHash.h"
#import <CommonCrypto/CommonDigest.h>

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSData
@implementation NSData (ESHash)
- (NSString *)md5Hash
{
        unsigned char buffer[CC_MD5_DIGEST_LENGTH];
        CC_MD5(self.bytes, (CC_LONG)self.length, buffer);
        return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                buffer[0], buffer[1], buffer[2], buffer[3], buffer[4], buffer[5], buffer[6], buffer[7],buffer[8], buffer[9], buffer[10], buffer[11],buffer[12], buffer[13], buffer[14], buffer[15]];
}

- (NSString *)sha1Hash
{
        unsigned char buffer[CC_SHA1_DIGEST_LENGTH];
        CC_SHA1(self.bytes, (CC_LONG)self.length, buffer);
        return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                buffer[0], buffer[1], buffer[2], buffer[3], buffer[4], buffer[5], buffer[6], buffer[7],buffer[8], buffer[9], buffer[10], buffer[11],buffer[12], buffer[13], buffer[14], buffer[15], buffer[16], buffer[17], buffer[18], buffer[19]];
}

- (NSString *)sha256Hash
{
        unsigned char buffer[CC_SHA256_DIGEST_LENGTH];
        CC_SHA256(self.bytes, (CC_LONG)self.length, buffer);
        return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                buffer[0], buffer[1], buffer[2], buffer[3], buffer[4], buffer[5], buffer[6], buffer[7],buffer[8], buffer[9], buffer[10], buffer[11],buffer[12], buffer[13], buffer[14], buffer[15], buffer[16], buffer[17], buffer[18], buffer[19],
                buffer[20], buffer[21], buffer[22], buffer[23], buffer[24], buffer[25], buffer[26], buffer[27], buffer[28], buffer[29], buffer[30], buffer[31]];
}

- (NSData *)base64EncodedData
{
        if ([self respondsToSelector:@selector(base64EncodedDataWithOptions:)]) {
                return [self base64EncodedDataWithOptions:0];
        }
        
        NSString *encodingString = [self base64Encoding];
        return [encodingString dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)base64EncodedString
{
        if ([self respondsToSelector:@selector(base64EncodedStringWithOptions:)]) {
                return [self base64EncodedStringWithOptions:0];
        }
        return [self base64Encoding];
}

- (NSData *)base64DecodedData
{
        if ([self respondsToSelector:@selector(initWithBase64EncodedData:options:)]) {
                return [[NSData alloc] initWithBase64EncodedData:self options:0];
        }
        
        NSString *encodedStr = [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
        return [[NSData alloc] initWithBase64Encoding:encodedStr];
}


- (NSString *)base64DecodedString
{
        if ([self respondsToSelector:@selector(initWithBase64EncodedData:options:)]) {
                NSData *data = [[NSData alloc] initWithBase64EncodedData:self options:0];
                return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
        
        return [[NSString alloc] initWithData:[self base64DecodedData] encoding:NSUTF8StringEncoding];
}

@end


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSString
@implementation NSString (ESHash)

- (NSString *)md5Hash
{
        const char *cString = [self cStringUsingEncoding:NSUTF8StringEncoding];
        unsigned char buffer[CC_MD5_DIGEST_LENGTH];
        CC_MD5(cString, (CC_LONG)strlen(cString), buffer);
        return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                buffer[0], buffer[1], buffer[2], buffer[3], buffer[4], buffer[5], buffer[6], buffer[7],buffer[8], buffer[9], buffer[10], buffer[11],buffer[12], buffer[13], buffer[14], buffer[15]];
}

- (NSString *)sha1Hash
{
        const char *cString = [self cStringUsingEncoding:NSUTF8StringEncoding];
        unsigned char buffer[CC_SHA1_DIGEST_LENGTH];
        CC_SHA1(cString, (CC_LONG)strlen(cString), buffer);
        return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                buffer[0], buffer[1], buffer[2], buffer[3], buffer[4], buffer[5], buffer[6], buffer[7],buffer[8], buffer[9], buffer[10], buffer[11],buffer[12], buffer[13], buffer[14], buffer[15], buffer[16], buffer[17], buffer[18], buffer[19]];
}

- (NSString *)sha256Hash
{
        const char *cString = [self cStringUsingEncoding:NSUTF8StringEncoding];
        unsigned char buffer[CC_SHA256_DIGEST_LENGTH];
        CC_SHA256(cString, (CC_LONG)strlen(cString), buffer);
        return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                buffer[0], buffer[1], buffer[2], buffer[3], buffer[4], buffer[5], buffer[6], buffer[7],buffer[8], buffer[9], buffer[10], buffer[11],buffer[12], buffer[13], buffer[14], buffer[15], buffer[16], buffer[17], buffer[18], buffer[19],
                buffer[20], buffer[21], buffer[22], buffer[23], buffer[24], buffer[25], buffer[26], buffer[27], buffer[28], buffer[29], buffer[30], buffer[31]];
}

- (NSData *)base64EncodedData
{
        NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
        return [data base64EncodedData];
}

- (NSString *)base64EncodedString
{
        NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
        return [data base64EncodedString];
}

- (NSData *)base64DecodedData
{
        if ([NSData instancesRespondToSelector:@selector(initWithBase64EncodedString:options:)]) {
                return [[NSData alloc] initWithBase64EncodedString:self options:0];
        }
        return [[NSData alloc] initWithBase64Encoding:self];
}

- (NSString *)base64DecodedString
{
        return [[NSString alloc] initWithData:[self base64DecodedData] encoding:NSUTF8StringEncoding];
}

@end
