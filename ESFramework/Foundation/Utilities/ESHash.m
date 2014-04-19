//
//  ESHash.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-13.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESHash.h"
#import <CommonCrypto/CommonDigest.h>

@implementation ESHash
@end
//
//+ (NSString *)base64String:(NSString *)str
//{
//        NSData *theData = [str dataUsingEncoding: NSASCIIStringEncoding];
//        const uint8_t* input = (const uint8_t*)[theData bytes];
//        NSInteger length = [theData length];
//        
//        static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
//        
//        NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
//        uint8_t* output = (uint8_t*)data.mutableBytes;
//        
//        NSInteger i;
//        for (i=0; i < length; i += 3) {
//                NSInteger value = 0;
//                NSInteger j;
//                for (j = i; j < (i + 3); j++) {
//                        value <<= 8;
//                        
//                        if (j < length) {
//                                value |= (0xFF & input[j]);
//                        }
//                }
//                
//                NSInteger theIndex = (i / 3) * 4;
//                output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
//                output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
//                output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
//                output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
//        }
//        
//        return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
//}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSData
@implementation NSData (ESHash)
- (NSString *)md5Hash
{
        if (!self) return nil;
        unsigned char buffer[CC_MD5_DIGEST_LENGTH];
        CC_MD5(self.bytes, (CC_LONG)self.length, buffer);
        return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                buffer[0], buffer[1], buffer[2], buffer[3], buffer[4], buffer[5], buffer[6], buffer[7],buffer[8], buffer[9], buffer[10], buffer[11],buffer[12], buffer[13], buffer[14], buffer[15]];
}

- (NSString *)sha1Hash
{
        if (!self) return nil;
        unsigned char buffer[CC_SHA1_DIGEST_LENGTH];
        CC_SHA1(self.bytes, (CC_LONG)self.length, buffer);
        return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                buffer[0], buffer[1], buffer[2], buffer[3], buffer[4], buffer[5], buffer[6], buffer[7],buffer[8], buffer[9], buffer[10], buffer[11],buffer[12], buffer[13], buffer[14], buffer[15], buffer[16], buffer[17], buffer[18], buffer[19]];
}

- (NSString *)sha256Hash
{
        if (!self) return nil;
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
        if ([self respondsToSelector:@selector(base64EncodedDataWithOptions:)]) {
                NSData *data = [self base64EncodedDataWithOptions:0];
                return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
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
        if (!self) return nil;
        const char *cString = [self cStringUsingEncoding:NSUTF8StringEncoding];
        unsigned char buffer[CC_MD5_DIGEST_LENGTH];
        CC_MD5(cString, (CC_LONG)strlen(cString), buffer);
        return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                buffer[0], buffer[1], buffer[2], buffer[3], buffer[4], buffer[5], buffer[6], buffer[7],buffer[8], buffer[9], buffer[10], buffer[11],buffer[12], buffer[13], buffer[14], buffer[15]];
}

- (NSString *)sha1Hash
{
        if (!self) return nil;
        const char *cString = [self cStringUsingEncoding:NSUTF8StringEncoding];
        unsigned char buffer[CC_SHA1_DIGEST_LENGTH];
        CC_SHA1(cString, (CC_LONG)strlen(cString), buffer);
        return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                buffer[0], buffer[1], buffer[2], buffer[3], buffer[4], buffer[5], buffer[6], buffer[7],buffer[8], buffer[9], buffer[10], buffer[11],buffer[12], buffer[13], buffer[14], buffer[15], buffer[16], buffer[17], buffer[18], buffer[19]];
}

- (NSString *)sha256Hash
{
        if (!self) return nil;
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
