//
//  NSTimer+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-18.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "NSTimer+ESAdditions.h"
#import "NSObject+ESAssociatedObjectHelper.h"

ESDefineAssociatedObjectKey(name);

@implementation NSTimer (ESAdditions)

- (NSString *)name
{
        return [self es_getAssociatedStringWithKey:nameKey defaultValue:nil];
}
- (void)setName:(NSString *)name
{
        [self es_setAssociatedStringWithKey:nameKey value:name];
}

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)(NSTimer *timer))block repeats:(BOOL)inRepeats
{
	NSParameterAssert(block != nil);
	return [self scheduledTimerWithTimeInterval:inTimeInterval target:self selector:@selector(_es_timerHandler:) userInfo:[block copy] repeats:inRepeats];
}

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)(NSTimer *timer))block repeats:(BOOL)inRepeats
{
	NSParameterAssert(block != nil);
	return [self timerWithTimeInterval:inTimeInterval target:self selector:@selector(_es_timerHandler:) userInfo:[block copy] repeats:inRepeats];
}

+ (void)_es_timerHandler:(NSTimer *)timer
{
        void (^block)(NSTimer *) = [timer userInfo];
        if (block) {
                block(timer);
        }
}

@end
