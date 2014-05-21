//
//  NSDate+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-8.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ESAdditions)

/**
 * `return [[self date] timeIntervalSince1970]`
 */
+ (NSTimeInterval)nowTimeInterval;

+ (unsigned long long)timestamp;

- (BOOL)isBefore:(NSDate *)aDate;
- (BOOL)isAfter:(NSDate *)aDate;

@end
