//
//  NSTimer+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-18.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "NSTimer+ESAdditions.h"
#import "NSObject+ESAssociatedObjectHelper.h"

ESDefineAssociatedObjectKey(taskBlock);

@implementation NSTimer (ESAdditions)

- (void (^)(NSTimer *))esTaskBlock
{
        return ESGetAssociatedObject(self, taskBlockKey);
}
- (void)setEsTaskBlock:(void (^)(NSTimer *))block
{
        ESSetAssociatedObject(self, taskBlockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

+ (void)_esTimerTask:(NSTimer *)timer
{
        void (^block)(NSTimer *) = timer.esTaskBlock;
        if (block) {
                block(timer);
        }
}

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)ti userInfo:(id)userInfo repeats:(BOOL)yesOrNo block:(void (^)(NSTimer *timer))block
{
        NSTimer *timer = [self timerWithTimeInterval:ti target:self selector:@selector(_esTimerTask:) userInfo:userInfo repeats:yesOrNo];
        timer.esTaskBlock = block;
        return timer;
}

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti userInfo:(id)userInfo repeats:(BOOL)yesOrNo block:(void (^)(NSTimer *timer))block
{
        NSTimer *timer = [self scheduledTimerWithTimeInterval:ti target:self selector:@selector(_esTimerTask:) userInfo:userInfo repeats:yesOrNo];
        timer.esTaskBlock = block;
        return timer;
}


@end
