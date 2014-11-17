//
//  NSTimer+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-18.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (ESAdditions)

/// Associated property
@property (nonatomic, copy) NSString *name;

/**
 * The `block` is stored as the timer's userinfo, so do not use the 'userInfo` property of the timer.
 */
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)(NSTimer *timer))block repeats:(BOOL)inRepeats;
+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)(NSTimer *timer))block repeats:(BOOL)inRepeats;

@end
