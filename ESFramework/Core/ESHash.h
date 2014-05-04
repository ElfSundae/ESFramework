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
- (NSString *)md5Hash;
/** Lower case. */
- (NSString *)sha1Hash;
/** Lower case. */
- (NSString *)sha256Hash;

- (NSData *)base64EncodedData;
- (NSString *)base64EncodedString;
- (NSData *)base64DecodedData;
- (NSString *)base64DecodedString;

@end

@interface NSString (ESHash)

/** Lower case. */
- (NSString *)md5Hash;
/** Lower case. */
- (NSString *)sha1Hash;
/** Lower case. */
- (NSString *)sha256Hash;

- (NSData *)base64EncodedData;
- (NSString *)base64EncodedString;
- (NSData *)base64DecodedData;
- (NSString *)base64DecodedString;

@end
