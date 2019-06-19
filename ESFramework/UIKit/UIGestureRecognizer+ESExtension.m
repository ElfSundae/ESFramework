//
//  UIGestureRecognizer+ESExtension.m
//  ESFramework
//
//  Created by Elf Sundae on 2019/05/23.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import "UIGestureRecognizer+ESExtension.h"
#if TARGET_OS_IOS || TARGET_OS_TV

#import <objc/runtime.h>
#import "ESMacros.h"
#import "ESActionBlockContainer.h"

ESDefineAssociatedObjectKey(allActionBlockContainers)

@implementation UIGestureRecognizer (ESExtension)

- (NSMutableArray<ESActionBlockContainer *> *)allActionBlockContainers
{
    NSMutableArray *containers = objc_getAssociatedObject(self, allActionBlockContainersKey);
    if (!containers) {
        containers = [NSMutableArray array];
        objc_setAssociatedObject(self, allActionBlockContainersKey, containers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return containers;
}

- (instancetype)initWithActionBlock:(void (^ _Nullable)(__kindof UIGestureRecognizer *gestureRecognizer))actionBlock
{
    self = [self initWithTarget:nil action:nil];
    if (actionBlock) {
        [self addActionBlock:actionBlock];
    }
    return self;
}

- (void)addActionBlock:(void (^)(__kindof UIGestureRecognizer *gestureRecognizer))actionBlock
{
    ESActionBlockContainer *container = [[ESActionBlockContainer alloc] initWithBlock:actionBlock];
    [self addTarget:container action:container.action];
    [[self allActionBlockContainers] addObject:container];
}

- (void)removeAllActionBlocks
{
    NSMutableArray *allContainers = [self allActionBlockContainers];
    for (ESActionBlockContainer *container in allContainers) {
        [self removeTarget:container action:container.action];
    }
    [allContainers removeAllObjects];
}

@end

#endif
