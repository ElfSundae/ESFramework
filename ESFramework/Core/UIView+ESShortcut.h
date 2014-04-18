//
//  UIView+ESShortcut.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-6.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ESShortcut)
/// Shortcut for frame.origin.x
@property (nonatomic) CGFloat left;
/// Shortcut for frame.origin.y
@property (nonatomic) CGFloat top;
/// Shortcut for frame.origin.x + frame.size.width
@property (nonatomic) CGFloat right;
/// Shortcut for frame.origin.y + frame.size.height
@property (nonatomic) CGFloat bottom;
/// Shortcut for frame.size.width
@property (nonatomic) CGFloat width;
/// Shortcut for frame.size.height
@property (nonatomic) CGFloat height;
/// Shortcut for center.x
@property (nonatomic) CGFloat centerX;
/// Shortcut for center.y
@property (nonatomic) CGFloat centerY;

/// frame.origin
@property (nonatomic) CGPoint origin;
/// frame.size
@property (nonatomic) CGSize size;

@end
