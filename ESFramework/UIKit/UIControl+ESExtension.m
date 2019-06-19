//
//  UIControl+ESExtension.m
//  ESFramework
//
//  Created by Elf Sundae on 2019/05/24.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import "UIControl+ESExtension.h"
#if TARGET_OS_IOS || TARGET_OS_TV

#import "ESActionBlockContainer.h"
#import <objc/runtime.h>
#import "ESMacros.h"

@interface ESUIControlActionBlockContainer : ESActionBlockContainer

@property (nonatomic) UIControlEvents events;

@end

@implementation ESUIControlActionBlockContainer

- (instancetype)initWithBlock:(void (^)(id sender))block events:(UIControlEvents)events
{
    self = [self initWithBlock:block];
    self.events = events;
    return self;
}

@end

ESDefineAssociatedObjectKey(allActionBlockContainers)

@implementation UIControl (ESExtension)

- (NSMutableArray<ESUIControlActionBlockContainer *> *)allActionBlockContainers
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

    ESUIControlActionBlockContainer *container = [[ESUIControlActionBlockContainer alloc] initWithBlock:actionBlock events:controlEvents];
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

    NSMutableArray<ESUIControlActionBlockContainer *> *containers = [self allActionBlockContainers];
    [containers removeObjectsAtIndexes:
     [containers indexesOfObjectsPassingTest:^BOOL (ESUIControlActionBlockContainer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIControlEvents removalEvents = obj.events & controlEvents;
        if (removalEvents) {
            [self removeTarget:obj action:obj.action forControlEvents:removalEvents];
            obj.events &= ~removalEvents;
            if (!obj.events) {
                return YES;
            }
        }
        return NO;
    }]];
}

@end

#endif
