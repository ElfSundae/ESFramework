//
//  ESHash.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-13.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import "ESHash.h"
#import <CommonCrypto/CommonDigest.h>

@implementation ESHash
@end

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


@end
