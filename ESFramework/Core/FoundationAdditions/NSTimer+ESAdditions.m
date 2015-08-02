//
//  NSTimer+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-18.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "NSTimer+ESAdditions.h"
#import "ESDefines.h"

ES_CATEGORY_FIX(NSTimer_ESAdditions)

static const void *_timerNameKey = &_timerNameKey;

@implementation NSTimer (ESAdditions)

- (NSString *)name
{
        return ESGetAssociatedObject(self, _timerNameKey);
}
- (void)setName:(NSString *)name
{
        ESSetAssociatedObject(self, _timerNameKey, name, OBJC_ASSOCIATION_COPY_NONATOMIC);
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
