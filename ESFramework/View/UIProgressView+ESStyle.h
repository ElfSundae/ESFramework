//
//  UIProgressView+ESStyle.h
//  ESFramework
//
//  Created by Elf Sundae on 4/30/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIProgressView (ESStyle)
///=============================================
/// @name Flat style
///=============================================

+ (instancetype)flatProgressView;
+ (instancetype)flatProgressViewWithTrackColor:(UIColor *)trackColor progressColor:(UIColor *)progressColor;

///=============================================
/// @name Resizable
///=============================================

- (void)resizedHeight:(CGFloat)newHeight;

@end
