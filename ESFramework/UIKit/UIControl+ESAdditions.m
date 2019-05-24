//
//  UIControl+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 2019/05/24.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import "ESActionBlockContainer.h"

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

#import "UIControl+ESAdditions.h"
#import <objc/runtime.h>
#import "ESMacros.h"
#import "ESHelpers.h"

ESDefineAssociatedObjectKey(allActionBlockContainers);

@implementation UIControl (ESAdditions)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ESSwizzleInstanceMethod(self, @selector(removeTarget:action:forControlEvents:), @selector(_es_removeTarget:action:forControlEvents:));
    });
}

- (void)_es_removeTarget:(nullable id)target action:(nullable SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [self _es_removeTarget:target action:action forControlEvents:controlEvents];

    NSMutableArray<ESUIControlActionBlockContainer *> *containers = [self allActionBlockContainers];
    if (target && [containers containsObject:target]) {
        ESUIControlActionBlockContainer *container = (ESUIControlActionBlockContainer *)target;
        container.events &= ~controlEvents;
        if (!container.events) {
            [containers removeObject:container];
        }
    } else if (!target) {
        [containers removeObjectsAtIndexes:
         [containers indexesOfObjectsPassingTest:^BOOL (ESUIControlActionBlockContainer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.events &= ~controlEvents;
            return !obj.events;
        }]];
    }
}

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

    for (ESUIControlActionBlockContainer *container in [self allActionBlockContainers]) {
        UIControlEvents removalEvents = container.events & controlEvents;
        if (removalEvents) {
            [self removeTarget:container action:container.action forControlEvents:removalEvents];
        }
    }
}

@end
