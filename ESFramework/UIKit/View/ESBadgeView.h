//
//  ESBadgeView.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-15.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * @see https://github.com/dral3x/CustomBadge
 */
@interface ESBadgeView : UIView

/// Can be NSString or NSNumber
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *font;

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIColor *frameColor; // border
@property (nonatomic) CGFloat frameWidth;

@property (nonatomic) BOOL showsShadow;
@property (nonatomic, strong) UIColor *shadowColor;
@property (nonatomic) CGSize shadowOffset;
@property (nonatomic) CGFloat shadowBlur;

@property (nonatomic) BOOL isShining;
@property (nonatomic) CGFloat cornerRoundness;

@property (nonatomic) CGSize minimumSize;

@property (nonatomic) BOOL isFlatStyle;
@property (nonatomic) BOOL applyFlatStyleAutomatically; // default is YES

@property (nonatomic) UIEdgeInsets contentEdgeInsets;

- (void)configureDefaults;

+ (instancetype)badgeViewWithText:(NSString *)text;
+ (instancetype)redDotWithSize:(CGFloat)size;

@end
