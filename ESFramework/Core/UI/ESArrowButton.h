//
//  ESArrowButton.h
//  ESFramework
//
//  Created by Elf Sundae on 4/29/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ESArrowButtonStyle) {
        ESArrowButtonStyleLeft,
        ESArrowButtonStyleRight,
};

/**
 * UIButton with arrow, used for UIBarButtonItem's `customView`.
 *
 * TODO: rewrite ESArrowButton to fully support tintColor.
 */
@interface ESArrowButton : UIButton
@property (nonatomic) ESArrowButtonStyle arrowStyle;
@property (nonatomic) UIEdgeInsets edgeInsets;
@property (nonatomic) CGFloat lineWidth;
+ (instancetype)button;
@end

