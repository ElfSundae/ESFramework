//
//  UIBarButtonItem+ESExtension.m
//  ESFramework
//
//  Created by Elf Sundae on 2019/05/23.
//  Copyright © 2019 https://0x123.com All rights reserved.
//

#import "UIBarButtonItem+ESExtension.h"
#if TARGET_OS_IOS || TARGET_OS_TV

#import <objc/runtime.h>
#import "ESMacros.h"
#import "ESActionBlockContainer.h"

ESDefineAssociatedObjectKey(actionBlockContainer)

@implementation UIBarButtonItem (ESExtension)

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

#endif
