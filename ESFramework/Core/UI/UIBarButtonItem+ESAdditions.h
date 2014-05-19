//
//  UIBarButtonItem+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-7.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESDefines.h"

@interface UIBarButtonItem (ESAdditions)

- (instancetype)initWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style handler:(ESHandlerBlock)handler;
+ (instancetype)itemWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style handler:(ESHandlerBlock)handler;
- (instancetype)initWithImage:(UIImage *)image landscapeImagePhone:(UIImage *)landscapeImagePhone style:(UIBarButtonItemStyle)style handler:(ESHandlerBlock)handler;
+ (instancetype)itemWithImage:(UIImage *)image landscapeImagePhone:(UIImage *)landscapeImagePhone style:(UIBarButtonItemStyle)style handler:(ESHandlerBlock)handler;
- (instancetype)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style handler:(ESHandlerBlock)handler;
+ (instancetype)itemWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style handler:(ESHandlerBlock)handler;
- (instancetype)initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem handler:(ESHandlerBlock)handler;
+ (instancetype)itemWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem handler:(ESHandlerBlock)handler;

/**
 * With `UIBarButtonItemStyleBordered` style.
 */
+ (instancetype)itemWithTitle:(NSString *)title handler:(ESHandlerBlock)handler;

/**
 * If `tintColor` is nil, it will use parent's tintColor.
 */
+ (instancetype)itemWithTitle:(NSString *)title tintColor:(UIColor *)tintColor style:(UIBarButtonItemStyle)style handler:(ESHandlerBlock)handler;

+ (instancetype)itemWithTitle:(NSString *)title tintColor:(UIColor *)tintColor handler:(ESHandlerBlock)handler;

/**
 * `tintColor` is #fa140e
 */
+ (instancetype)itemWithRedStyle:(NSString *)title handler:(ESHandlerBlock)handler;
/**
 * With `UIBarButtonItemStyleDone` style
 */
+ (instancetype)itemWithDoneStyle:(NSString *)title handler:(ESHandlerBlock)handler;

/**
 * ESArrowButton as `customView`.
 */
+ (instancetype)itemWithLeftArrow:(ESHandlerBlock)handler;
+ (instancetype)itemWithRightArrow:(ESHandlerBlock)handler;

@end


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#import "ESArrowButton.h"
@interface ESBarButtonArrowItem : UIBarButtonItem
/// #customView
- (ESArrowButton *)arrowButton;
@end

