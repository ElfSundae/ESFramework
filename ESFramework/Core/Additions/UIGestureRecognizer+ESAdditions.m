//
//  UIGestureRecognizer+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 4/19/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "UIGestureRecognizer+ESAdditions.h"

static const void *__es_HandlerKey = &__es_HandlerKey;

@interface UIGestureRecognizer (_ESAdditionsInternal)
@property (nonatomic, copy) ESUIGestureRecognizerHandler __es_Handler;
@end

@implementation UIGestureRecognizer (ESAdditions)

- (ESUIGestureRecognizerHandler)__es_Handler
{
    return objc_getAssociatedObject(self, __es_HandlerKey);
}
- (void)set__es_Handler:(ESUIGestureRecognizerHandler)handler
{
    objc_setAssociatedObject(self, __es_HandlerKey, handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (instancetype)initWithHandler:(ESUIGestureRecognizerHandler)handler
{
    self = [self initWithTarget:self action:@selector(_es_GRHandler:)];
    self.__es_Handler = handler;
    return self;
}

+ (instancetype)recognizerWithHandler:(ESUIGestureRecognizerHandler)handler
{
    return [[self alloc] initWithHandler:handler];
}

- (void)_es_GRHandler:(UIGestureRecognizer *)gr
{
    if (self.__es_Handler) {
        CGPoint location = [self locationInView:self.view];
        self.__es_Handler(self, self.state, location);
    }
}

@end
