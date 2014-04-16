//
//  ESFormatter.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-16.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESFormatter : NSObject

/**
 * Formats a number of bytes in a human-readable format.
 * Will create a string showing the size in bytes, KBs, MBs, or GBs.
 */
+ (NSString *)stringFromByteCount:(unsigned long long)fileSize;

@end
