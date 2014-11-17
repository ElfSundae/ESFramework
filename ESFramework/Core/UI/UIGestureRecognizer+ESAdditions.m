//
//  UIGestureRecognizer+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 4/19/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "UIGestureRecognizer+ESAdditions.h"

@interface UIGestureRecognizer (_ESAdditionsInternal)
@property (nonatomic, copy) ESUIGestureRecognizerHandler __es_Handler;
@end

static const void *__es_HandlerKey = &__es_HandlerKey;

@implementation UIGestureRecognizer (ESAdditions)

- (ESUIGestureRecognizerHandler)__es_Handler
{
        return [self getAssociatedObject:__es_HandlerKey];
}
- (void)set__es_Handler:(ESUIGestureRecognizerHandler)handler
{
        [self setAssociatedObject_nonatomic_copy:handler key:__es_HandlerKey];
}

- (instancetype)initWithHandler:(ESUIGestureRecognizerHandler)handler
{
        self = [self initWithTarget:self action:@selector(_es_GRHandler:)];
        self.__es_Handler = handler;
        
        // Fix tap issue on iOS5
        if (!ESOSVersionIsAtLeast(NSFoundationVersionNumber_iOS_6_0)) {
                if ([self isKindOfClass:[UITapGestureRecognizer class]]) {
                        self.delegate = (id<UIGestureRecognizerDelegate>)self;
                }
        }
        
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

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Fix

- (BOOL)es_shouldReceiveTouch:(UITouch *)touch
{
        if ([self isKindOfClass:[UITapGestureRecognizer class]] &&
            [touch.view isKindOfClass:[UIControl class]]) {
                // Fix iOS5: gesture issue
                // http://stackoverflow.com/q/3344341/521946
                return NO;
        }
        return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
        return [gestureRecognizer es_shouldReceiveTouch:touch];
}

@end
