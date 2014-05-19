//
//  UIBarButtonItem+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-7.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "UIBarButtonItem+ESAdditions.h"
#import "UIControl+ESAdditions.h"
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - _ESAdditionsInternal
@interface UIBarButtonItem (_ESAdditionsInternal)
@property (nonatomic, copy) ESHandlerBlock __es_HandlerBlock;
@end

static const void *__es_HandlerBlockKey = &__es_HandlerBlockKey;

@implementation UIBarButtonItem (_ESAdditionsInternal)
- (ESHandlerBlock)__es_HandlerBlock
{
        return [self getAssociatedObject:__es_HandlerBlockKey];
}
- (void)set__es_HandlerBlock:(ESHandlerBlock)block
{
        [self setAssociatedObject_nonatomic_copy:block key:__es_HandlerBlockKey];
}
@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ESBarButtonArrowItem
@implementation ESBarButtonArrowItem

- (ESArrowButton *)arrowButton
{
        return (ESArrowButton *)self.customView;
}
- (void)setTintColor:(UIColor *)tintColor
{
        [super setTintColor:tintColor];
        self.arrowButton.tintColor = tintColor;
}
+ (instancetype)_arrowItemWithButtonStyle:(ESArrowButtonStyle)style handler:(ESHandlerBlock)handler
{
        ESArrowButton *button = [ESArrowButton button];
        ESBarButtonArrowItem *item = [[self alloc] initWithCustomView:button];
        button.arrowStyle = style;
        button.tintColor = ([[self appearance] tintColor] ?: item.tintColor);
        ES_WEAK_VAR(self, _weakSelf);
        [button addEventHandler:^(id sender, UIControlEvents controlEvents) {
                ES_STRONG_VAR_CHECK_NULL(_weakSelf, _self);
                handler(_self);
        } forControlEvents:UIControlEventTouchUpInside];
        return item;
}

@end


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark
@implementation UIBarButtonItem (ESAdditions)

- (void)__es_handler:(UIBarButtonItem *)sender
{
        if (self.__es_HandlerBlock) {
                self.__es_HandlerBlock(self);
        }
}

- (instancetype)initWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style handler:(ESHandlerBlock)handler
{
        self = [self initWithImage:image style:style target:self action:@selector(__es_handler:)];
        self.__es_HandlerBlock = handler;
        return self;
}
+ (instancetype)itemWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style handler:(ESHandlerBlock)handler
{
        return [[self alloc] initWithImage:image style:style handler:handler];
}

- (instancetype)initWithImage:(UIImage *)image landscapeImagePhone:(UIImage *)landscapeImagePhone style:(UIBarButtonItemStyle)style handler:(ESHandlerBlock)handler
{
        self = [self initWithImage:image landscapeImagePhone:landscapeImagePhone style:style target:self action:@selector(__es_handler:)];
        self.__es_HandlerBlock = handler;
        return self;
}

+ (instancetype)itemWithImage:(UIImage *)image landscapeImagePhone:(UIImage *)landscapeImagePhone style:(UIBarButtonItemStyle)style handler:(ESHandlerBlock)handler
{
        return [[self alloc] initWithImage:image landscapeImagePhone:landscapeImagePhone style:style handler:handler];
}

- (instancetype)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style handler:(ESHandlerBlock)handler
{
        self = [self initWithTitle:title style:style target:self action:@selector(__es_handler:)];
        self.__es_HandlerBlock = handler;
        return self;
}

+ (instancetype)itemWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style handler:(ESHandlerBlock)handler
{
        return [[self alloc] initWithTitle:title style:style handler:handler];
}

- (instancetype)initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem handler:(ESHandlerBlock)handler
{
        self = [self initWithBarButtonSystemItem:systemItem target:self action:@selector(__es_handler:)];
        self.__es_HandlerBlock = handler;
        return self;
}

+ (instancetype)itemWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem handler:(ESHandlerBlock)handler
{
        return [[self alloc] initWithBarButtonSystemItem:systemItem handler:handler];
}

+ (instancetype)itemWithTitle:(NSString *)title handler:(ESHandlerBlock)handler
{
        return [self itemWithTitle:title style:UIBarButtonItemStyleBordered handler:handler];
}

+ (instancetype)itemWithTitle:(NSString *)title tintColor:(UIColor *)tintColor style:(UIBarButtonItemStyle)style handler:(ESHandlerBlock)handler
{
        UIBarButtonItem *item = [self itemWithTitle:title style:style handler:handler];
        item.tintColor = tintColor;
        return item;
}

+ (instancetype)itemWithTitle:(NSString *)title tintColor:(UIColor *)tintColor handler:(ESHandlerBlock)handler
{
        return [self itemWithTitle:title tintColor:tintColor style:UIBarButtonItemStyleBordered handler:handler];
}


+ (instancetype)itemWithRedStyle:(NSString *)title handler:(ESHandlerBlock)handler
{
        return [self itemWithTitle:title tintColor:UIColorWithRGBHex(0xfa140e) style:UIBarButtonItemStyleBordered handler:handler];
}

+ (instancetype)itemWithDoneStyle:(NSString *)title handler:(ESHandlerBlock)handler
{
        return [self itemWithTitle:title style:UIBarButtonItemStyleDone handler:handler];
}

+ (instancetype)itemWithLeftArrow:(ESHandlerBlock)handler
{
        return [ESBarButtonArrowItem _arrowItemWithButtonStyle:ESArrowButtonStyleLeft handler:handler];
}

+ (instancetype)itemWithRightArrow:(ESHandlerBlock)handler
{
        return [ESBarButtonArrowItem _arrowItemWithButtonStyle:ESArrowButtonStyleRight handler:handler];
}

@end
