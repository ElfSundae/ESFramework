//
//  UIBarButtonItem+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-7.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESDefines.h"

typedef void (^ESUIBarButtonItemHandler)(UIBarButtonItem *barButtonItem);

@interface UIBarButtonItem (ESAdditions)

@property (nonatomic, copy) ESUIBarButtonItemHandler handlerBlock;

- (instancetype)initWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style handler:(ESUIBarButtonItemHandler)handler;
+ (instancetype)itemWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style handler:(ESUIBarButtonItemHandler)handler;
- (instancetype)initWithImage:(UIImage *)image landscapeImagePhone:(UIImage *)landscapeImagePhone style:(UIBarButtonItemStyle)style handler:(ESUIBarButtonItemHandler)handler;
+ (instancetype)itemWithImage:(UIImage *)image landscapeImagePhone:(UIImage *)landscapeImagePhone style:(UIBarButtonItemStyle)style handler:(ESUIBarButtonItemHandler)handler;
- (instancetype)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style handler:(ESUIBarButtonItemHandler)handler;
+ (instancetype)itemWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style handler:(ESUIBarButtonItemHandler)handler;
- (instancetype)initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem handler:(ESUIBarButtonItemHandler)handler;
+ (instancetype)itemWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem handler:(ESUIBarButtonItemHandler)handler;

/**
 * With `UIBarButtonItemStylePlain` style.
 */
+ (instancetype)itemWithTitle:(NSString *)title handler:(ESUIBarButtonItemHandler)handler;

/**
 * If `tintColor` is nil, it will use parent's tintColor.
 */
+ (instancetype)itemWithTitle:(NSString *)title tintColor:(UIColor *)tintColor style:(UIBarButtonItemStyle)style handler:(ESUIBarButtonItemHandler)handler;

+ (instancetype)itemWithTitle:(NSString *)title tintColor:(UIColor *)tintColor handler:(ESUIBarButtonItemHandler)handler;

/**
 * `tintColor` is #fa140e
 */
+ (instancetype)itemWithRedStyle:(NSString *)title handler:(ESUIBarButtonItemHandler)handler;
/**
 * With `UIBarButtonItemStyleDone` style
 */
+ (instancetype)itemWithDoneStyle:(NSString *)title handler:(ESUIBarButtonItemHandler)handler;

@end

