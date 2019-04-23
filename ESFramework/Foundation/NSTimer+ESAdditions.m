//
//  NSTimer+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-18.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "NSTimer+ESAdditions.h"
#import <objc/runtime.h>

static const void *esTaskBlockKey = &esTaskBlockKey;

@implementation NSTimer (ESAdditions)

- (void)es_setTaskBlock:(void (^)(NSTimer *))block
{
    objc_setAssociatedObject(self, esTaskBlockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

+ (void)es_runTaskBlock:(NSTimer *)timer
{
    void (^block)(NSTimer *) = objc_getAssociatedObject(timer, esTaskBlockKey);
    if (block) {
        block(timer);
    }
}

+ (NSTimer *)es_timerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block
{
    if (@available(iOS 10.0, *)) {
        return [self timerWithTimeInterval:interval repeats:repeats block:block];
    } else {
        NSTimer *timer = [self timerWithTimeInterval:interval target:self selector:@selector(es_runTaskBlock:) userInfo:nil repeats:repeats];
        [timer es_setTaskBlock:block];
        return timer;
    }
}

+ (NSTimer *)es_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block
{
    if (@available(iOS 10.0, *)) {
        return [self scheduledTimerWithTimeInterval:interval repeats:repeats block:block];
    } else {
        NSTimer *timer = [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(es_runTaskBlock:) userInfo:nil repeats:repeats];
        [timer es_setTaskBlock:block];
        return timer;
    }
}

@end
