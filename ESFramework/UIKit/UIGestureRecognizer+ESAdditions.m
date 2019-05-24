//
//  UIGestureRecognizer+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 2019/05/23.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import "UIGestureRecognizer+ESAdditions.h"
#import <objc/runtime.h>
#import "ESMacros.h"
#import "ESActionBlockContainer.h"

ESDefineAssociatedObjectKey(allActionBlockContainers);

@implementation UIGestureRecognizer (ESAdditions)

- (instancetype)initWithActionBlock:(void (^ _Nullable)(__kindof UIGestureRecognizer *gr))actionBlock
{
    self = [self initWithTarget:nil action:nil];
    if (actionBlock) {
        [self addActionBlock:actionBlock];
    }
    return self;
}

- (NSMutableArray<ESActionBlockContainer *> *)allActionBlockContainers
{
    NSMutableArray *containers = objc_getAssociatedObject(self, allActionBlockContainersKey);
    if (!containers) {
        containers = [NSMutableArray array];
        objc_setAssociatedObject(self, allActionBlockContainersKey, containers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return containers;
}

- (void)addActionBlock:(void (^)(__kindof UIGestureRecognizer *gr))actionBlock
{
    ESActionBlockContainer *container = [[ESActionBlockContainer alloc] initWithBlock:actionBlock];
    [self addTarget:container action:container.action];
    [[self allActionBlockContainers] addObject:container];
}

- (void)removeAllActionBlocks
{
    for (ESActionBlockContainer *container in [self allActionBlockContainers]) {
        [self removeTarget:container action:container.action];
    }
    [[self allActionBlockContainers] removeAllObjects];
}

@end
