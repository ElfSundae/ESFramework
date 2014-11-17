//
//  ESHash.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-13.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (ESHash)

/** Lower case. */
- (NSString *)es_md5Hash;
/** Lower case. */
- (NSString *)es_sha1Hash;
/** Lower case. */
- (NSString *)es_sha256Hash;

- (NSData *)es_base64EncodedData;
- (NSString *)es_base64EncodedString;
- (NSData *)es_base64DecodedData;
- (NSString *)es_base64DecodedString;

@end

@interface NSString (ESHash)

/** Lower case. */
- (NSString *)es_md5Hash;
/** Lower case. */
- (NSString *)es_sha1Hash;
/** Lower case. */
- (NSString *)es_sha256Hash;

- (NSData *)es_base64EncodedData;
- (NSString *)es_base64EncodedString;
- (NSData *)es_base64DecodedData;
- (NSString *)es_base64DecodedString;

@end
