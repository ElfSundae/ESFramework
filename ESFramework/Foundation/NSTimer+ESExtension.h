//
//  NSTimer+ESExtension.h
//  ESFramework
//
//  Created by Elf Sundae on 2014/04/18.
//  Copyright © 2014 https://0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (ESExtension)

/**
 * Initializes a timer object with the specified time interval and block.
 */
+ (NSTimer *)es_timerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block;

/**
 * Creates a timer and schedules it on the current run loop in the default mode.
 */
+ (NSTimer *)es_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block;

@end

NS_ASSUME_NONNULL_END
