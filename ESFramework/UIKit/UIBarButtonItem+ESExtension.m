//
//  UIBarButtonItem+ESExtension.m
//  ESFramework
//
//  Created by Elf Sundae on 2019/05/23.
//  Copyright © 2014-2020 https://0x123.com All rights reserved.
//

#import "UIBarButtonItem+ESExtension.h"
#if TARGET_OS_IOS || TARGET_OS_TV

#import <objc/runtime.h>
#import "ESActionBlockContainer.h"

static const void *actionBlockContainerKey = &actionBlockContainerKey;

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

- (instancetype)initWithImage:(nullable UIImage *)image style:(UIBarButtonItemStyle)style actionBlock:(void (^)(__kindof UIBarButtonItem *buttonItem))actionBlock
{
    self = [self initWithImage:image style:style target:nil action:nil];
    if (self) {
        self.actionBlock = actionBlock;
    }
    return self;
}

- (instancetype)initWithImage:(nullable UIImage *)image landscapeImagePhone:(nullable UIImage *)landscapeImagePhone style:(UIBarButtonItemStyle)style actionBlock:(void (^)(__kindof UIBarButtonItem *buttonItem))actionBlock
{
    self = [self initWithImage:image landscapeImagePhone:landscapeImagePhone style:style target:nil action:nil];
    if (self) {
        self.actionBlock = actionBlock;
    }
    return self;
}

- (instancetype)initWithTitle:(nullable NSString *)title style:(UIBarButtonItemStyle)style actionBlock:(void (^)(__kindof UIBarButtonItem *buttonItem))actionBlock
{
    self = [self initWithTitle:title style:style target:nil action:nil];
    if (self) {
        self.actionBlock = actionBlock;
    }
    return self;
}

- (instancetype)initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem actionBlock:(void (^)(__kindof UIBarButtonItem *buttonItem))actionBlock
{
    self = [self initWithBarButtonSystemItem:systemItem target:nil action:nil];
    if (self) {
        self.actionBlock = actionBlock;
    }
    return self;
}

@end

#endif
