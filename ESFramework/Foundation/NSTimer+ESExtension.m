//
//  NSTimer+ESExtension.m
//  ESFramework
//
//  Created by Elf Sundae on 2014/04/18.
//  Copyright © 2014 https://0x123.com. All rights reserved.
//

#import "NSTimer+ESExtension.h"
#import <objc/runtime.h>

static const void *taskBlockKey = &taskBlockKey;

@implementation NSTimer (ESExtension)

- (void)es_setTaskBlock:(void (^)(NSTimer *))block
{
    objc_setAssociatedObject(self, taskBlockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

+ (void)es_runTaskBlock:(NSTimer *)timer
{
    void (^block)(NSTimer *) = objc_getAssociatedObject(timer, taskBlockKey);
    if (block) {
        block(timer);
    }
}

+ (NSTimer *)es_timerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block
{
    if (@available(iOS 10, macOS 10.12, tvOS 10, watchOS 3, *)) {
        return [self timerWithTimeInterval:interval repeats:repeats block:block];
    } else {
        NSTimer *timer = [self timerWithTimeInterval:interval target:self selector:@selector(es_runTaskBlock:) userInfo:nil repeats:repeats];
        [timer es_setTaskBlock:block];
        return timer;
    }
}

+ (NSTimer *)es_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block
{
    if (@available(iOS 10, macOS 10.12, tvOS 10, watchOS 3, *)) {
        return [self scheduledTimerWithTimeInterval:interval repeats:repeats block:block];
    } else {
        NSTimer *timer = [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(es_runTaskBlock:) userInfo:nil repeats:repeats];
        [timer es_setTaskBlock:block];
        return timer;
    }
}

@end
