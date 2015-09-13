//
//  UIBarButtonItem+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-7.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "UIBarButtonItem+ESAdditions.h"
#import "UIControl+ESAdditions.h"
#import "ESDefines.h"

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
+ (instancetype)_arrowItemWithButtonStyle:(ESArrowButtonStyle)style handler:(ESUIBarButtonItemHandler)handler
{
        ESArrowButton *button = [ESArrowButton button];
        ESBarButtonArrowItem *item = [[self alloc] initWithCustomView:button];
        button.arrowStyle = style;
        button.tintColor = ([[self appearance] tintColor] ?: item.tintColor);
        ESWeak_(item);
        [button addEventHandler:^(id sender, UIControlEvents controlEvents) {
                ESStrong_(item);
                if (handler) {
                        handler(_item);
                }
        } forControlEvents:UIControlEventTouchUpInside];
        return item;
}

@end


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -

static const void *_ESUIBarButtonItemHandlerKey = &_ESUIBarButtonItemHandlerKey;

@implementation UIBarButtonItem (ESAdditions)

- (ESUIBarButtonItemHandler)handlerBlock
{
        return ESGetAssociatedObject(self, _ESUIBarButtonItemHandlerKey);
}

- (void)setHandlerBlock:(ESUIBarButtonItemHandler)handlerBlock
{
        ESSetAssociatedObject(self, _ESUIBarButtonItemHandlerKey, handlerBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
        if (handlerBlock) {
                self.target = self;
                self.action = @selector(_esBarButtonItemHandler:);
        } else {
                self.target = nil;
                self.action = nil;
        }
}

- (void)_esBarButtonItemHandler:(id)sender
{
        if (self.handlerBlock) {
                self.handlerBlock(self);
        }
}

- (instancetype)initWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style handler:(ESUIBarButtonItemHandler)handler
{
        self = [self initWithImage:image style:style target:nil action:nil];
        if (handler) {
                self.handlerBlock = handler;
        }
        return self;
}
+ (instancetype)itemWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style handler:(ESUIBarButtonItemHandler)handler
{
        return [[self alloc] initWithImage:image style:style handler:handler];
}

- (instancetype)initWithImage:(UIImage *)image landscapeImagePhone:(UIImage *)landscapeImagePhone style:(UIBarButtonItemStyle)style handler:(ESUIBarButtonItemHandler)handler
{
        self = [self initWithImage:image landscapeImagePhone:landscapeImagePhone style:style target:nil action:nil];
        if (handler) {
                self.handlerBlock = handler;
        }
        return self;
}

+ (instancetype)itemWithImage:(UIImage *)image landscapeImagePhone:(UIImage *)landscapeImagePhone style:(UIBarButtonItemStyle)style handler:(ESUIBarButtonItemHandler)handler
{
        return [[self alloc] initWithImage:image landscapeImagePhone:landscapeImagePhone style:style handler:handler];
}

- (instancetype)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style handler:(ESUIBarButtonItemHandler)handler
{
        self = [self initWithTitle:title style:style target:nil action:nil];
        if (handler) {
                self.handlerBlock = handler;
        }
        return self;
}

+ (instancetype)itemWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style handler:(ESUIBarButtonItemHandler)handler
{
        return [[self alloc] initWithTitle:title style:style handler:handler];
}

- (instancetype)initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem handler:(ESUIBarButtonItemHandler)handler
{
        self = [self initWithBarButtonSystemItem:systemItem target:nil action:nil];
        if (handler) {
                self.handlerBlock = handler;
        }
        return self;
}

+ (instancetype)itemWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem handler:(ESUIBarButtonItemHandler)handler
{
        return [[self alloc] initWithBarButtonSystemItem:systemItem handler:handler];
}

+ (instancetype)itemWithTitle:(NSString *)title handler:(ESUIBarButtonItemHandler)handler
{
        return [self itemWithTitle:title style:UIBarButtonItemStyleBordered handler:handler];
}

+ (instancetype)itemWithTitle:(NSString *)title tintColor:(UIColor *)tintColor style:(UIBarButtonItemStyle)style handler:(ESUIBarButtonItemHandler)handler
{
        UIBarButtonItem *item = [self itemWithTitle:title style:style handler:handler];
        item.tintColor = tintColor;
        return item;
}

+ (instancetype)itemWithTitle:(NSString *)title tintColor:(UIColor *)tintColor handler:(ESUIBarButtonItemHandler)handler
{
        return [self itemWithTitle:title tintColor:tintColor style:UIBarButtonItemStyleBordered handler:handler];
}


+ (instancetype)itemWithRedStyle:(NSString *)title handler:(ESUIBarButtonItemHandler)handler
{
        return [self itemWithTitle:title tintColor:UIColorWithRGBHex(0xfa140e) style:UIBarButtonItemStyleBordered handler:handler];
}

+ (instancetype)itemWithDoneStyle:(NSString *)title handler:(ESUIBarButtonItemHandler)handler
{
        return [self itemWithTitle:title style:UIBarButtonItemStyleDone handler:handler];
}

+ (instancetype)itemWithLeftArrow:(ESUIBarButtonItemHandler)handler
{
        return [ESBarButtonArrowItem _arrowItemWithButtonStyle:ESArrowButtonStyleLeft handler:handler];
}

+ (instancetype)itemWithRightArrow:(ESUIBarButtonItemHandler)handler
{
        return [ESBarButtonArrowItem _arrowItemWithButtonStyle:ESArrowButtonStyleRight handler:handler];
}

@end
