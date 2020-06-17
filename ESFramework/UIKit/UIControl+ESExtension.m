//
//  UIControl+ESExtension.m
//  ESFramework
//
//  Created by Elf Sundae on 2019/05/24.
//  Copyright © 2014-2020 https://0x123.com All rights reserved.
//

#import "UIControl+ESExtension.h"
#if TARGET_OS_IOS || TARGET_OS_TV

#import "ESControlActionBlockContainer.h"
#import <objc/runtime.h>

static const void *allActionBlockContainersKey = &allActionBlockContainersKey;

@implementation UIControl (ESExtension)

- (NSMutableArray<ESControlActionBlockContainer *> *)allActionBlockContainers
{
    NSMutableArray *containers = objc_getAssociatedObject(self, allActionBlockContainersKey);
    if (!containers) {
        containers = [NSMutableArray array];
        objc_setAssociatedObject(self, allActionBlockContainersKey, containers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return containers;
}

- (void)addActionBlock:(void (^)(__kindof UIControl *control))actionBlock forControlEvents:(UIControlEvents)controlEvents;
{
    if (!controlEvents) {
        return;
    }

    ESControlActionBlockContainer *container = [[ESControlActionBlockContainer alloc] initWithBlock:actionBlock controlEvents:controlEvents];
    [self addTarget:container action:container.action forControlEvents:controlEvents];
    [[self allActionBlockContainers] addObject:container];
}

- (void)setActionBlock:(void (^ _Nullable)(__kindof UIControl *control))actionBlock forControlEvents:(UIControlEvents)controlEvents
{
    [self removeAllActionBlocksForControlEvents:controlEvents];

    if (actionBlock) {
        [self addActionBlock:actionBlock forControlEvents:controlEvents];
    }
}

- (void)removeAllActionBlocksForControlEvents:(UIControlEvents)controlEvents
{
    if (!controlEvents) {
        return;
    }

    NSMutableArray<ESControlActionBlockContainer *> *containers = [self allActionBlockContainers];
    [containers removeObjectsAtIndexes:[containers indexesOfObjectsPassingTest:^BOOL (ESControlActionBlockContainer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIControlEvents removalEvents = obj.controlEvents & controlEvents;
        if (removalEvents) {
            [self removeTarget:obj action:obj.action forControlEvents:removalEvents];
            obj.controlEvents &= ~removalEvents;
            if (!obj.controlEvents) {
                return YES;
            }
        }
        return NO;
    }]];
}

@end

#endif
