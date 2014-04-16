//
//  ESHash.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-13.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESHash : NSObject
@end

@interface NSData (ESHash)

/** Lower case. */
- (NSString *)md5Hash;
/** Lower case. */
- (NSString *)sha1Hash;
/** Lower case. */
- (NSString *)sha256Hash;
@end

@interface NSString (ESHash)

/** Lower case. */
- (NSString *)md5Hash;
/** Lower case. */
- (NSString *)sha1Hash;
/** Lower case. */
- (NSString *)sha256Hash;

@end
