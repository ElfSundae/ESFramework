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
#import "ESHelpers.h"
#import "ESActionBlockContainer.h"

ESDefineAssociatedObjectKey(allActionBlockContainers);

@implementation UIGestureRecognizer (ESAdditions)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ESSwizzleInstanceMethod(self, @selector(removeTarget:action:), @selector(_es_removeTarget:action:));
    });
}

- (void)_es_removeTarget:(nullable id)target action:(nullable SEL)action
{
    [self _es_removeTarget:target action:action];

    NSMutableArray *containers = [self allActionBlockContainers];
    if (!target) {
        [containers removeAllObjects];
    } else if ([target isKindOfClass:[ESActionBlockContainer class]]) {
        [containers removeObjectIdenticalTo:target];
    }
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

- (instancetype)initWithActionBlock:(void (^ _Nullable)(__kindof UIGestureRecognizer *gr))actionBlock
{
    self = [self initWithTarget:nil action:nil];
    if (actionBlock) {
        [self addActionBlock:actionBlock];
    }
    return self;
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
}

@end
