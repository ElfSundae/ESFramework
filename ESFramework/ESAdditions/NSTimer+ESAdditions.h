//
//  NSTimer+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-18.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (ESAdditions)

@property (nonatomic, copy, readonly) void (^esTaskBlock)(NSTimer *timer);

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)ti userInfo:(id)userInfo repeats:(BOOL)yesOrNo block:(void (^)(NSTimer *timer))block;
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti userInfo:(id)userInfo repeats:(BOOL)yesOrNo block:(void (^)(NSTimer *timer))block;

@end
