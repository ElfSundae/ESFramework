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
ESDefineAssociatedObjectKey(taskBlock);

@interface NSTimer (ESAdditions_Private)
@property (nonatomic, copy) void (^esTaskBlock)(NSTimer *timer);
@end

@implementation NSTimer (ESAdditions_Private)

- (void (^)(NSTimer *))esTaskBlock
{
        return ESGetAssociatedObject(self, taskBlockKey);
}
- (void)setEsTaskBlock:(void (^)(NSTimer *))block
{
        ESSetAssociatedObject(self, taskBlockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

@implementation NSTimer (ESAdditions)

- (NSString *)name
{
        return [self es_getAssociatedStringWithKey:nameKey defaultValue:nil];
}
- (void)setName:(NSString *)name
{
        [self es_setAssociatedStringWithKey:nameKey value:name];
}

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo block:(void (^)(NSTimer *timer))block
{
        NSTimer *timer = [self timerWithTimeInterval:ti target:self selector:@selector(_esTimerTask:) userInfo:userInfo repeats:yesOrNo];
        timer.esTaskBlock = block;
        return timer;
}

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo block:(void (^)(NSTimer *timer))block
{
        NSTimer *timer = [self scheduledTimerWithTimeInterval:ti target:self selector:@selector(_esTimerTask:) userInfo:userInfo repeats:yesOrNo];
        timer.esTaskBlock = block;
        return timer;
}

+ (void)_esTimerTask:(NSTimer *)timer
{
        void (^block)(NSTimer *) = timer.esTaskBlock;
        if (block) {
                block(timer);
        }
}

@end
