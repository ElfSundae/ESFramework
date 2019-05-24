//
//  UIBarButtonItem+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 2019/05/23.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import "UIBarButtonItem+ESAdditions.h"
#import <objc/runtime.h>
#import "ESMacros.h"
#import "ESActionBlockContainer.h"

ESDefineAssociatedObjectKey(actionBlockContainer);

@implementation UIBarButtonItem (ESAdditions)

- (void (^)(__kindof UIBarButtonItem *))actionBlock
{
    ESActionBlockContainer *container = objc_getAssociatedObject(self, actionBlockContainerKey);
    return container.block;
}

- (void)setActionBlock:(void (^)(__kindof UIBarButtonItem *))actionBlock
{
    ESActionBlockContainer *container = actionBlock ? [[ESActionBlockContainer alloc] initWithBlock:actionBlock] : nil;
    objc_setAssociatedObject(self, actionBlockContainerKey, container, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.target = container;
    self.action = container.action;
}

@end
