//
//  ESButton.h
//  ESFramework
//
//  Created by Elf Sundae on 4/20/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ESButtonStyle) {
        ESButtonStyleRoundedRect,
        ESButtonStyleSemiCircle,
        ESButtonStyleCircle
};

/*!
 * Inspired by [BButton](https://github.com/jessesquires/BButton).
 * You may use UIAppearance selectors to apply a series of default styles for your application.
 */
@interface ESButton : UIButton <UIAppearance>

+ (instancetype)buttonWithStyle:(ESButtonStyle)buttonStyle;

@property (nonatomic, readonly) ESButtonStyle buttonStyle;
/**
 * Default is `[UIColor es_defaultButtonColor]`
 */
@property (nonatomic, strong) UIColor *buttonColor UI_APPEARANCE_SELECTOR;
/**
 * Corner radius for ESButtonStyleRoundedRect, NSNumber with CGFloat.
 * Default is 4. if buttonFlatStyled is YES or 6. if buttonFlatStyled is NO.
 */
@property (nonatomic, strong) NSNumber *buttonRoundedCornerRadius UI_APPEARANCE_SELECTOR;

/**
 * NSNumber with BOOL.
 * Default is YES on iOS7+, or NO if iOS version < 7.0.
 */
@property (nonatomic, strong) NSNumber *buttonFlatStyled UI_APPEARANCE_SELECTOR;

/**
 * Used to calc size when -sizeToFit is called.
 * 
 * Default value for ESButtonStyleRoundedRect is {0, 10, 0, 10}
 * Default value for ESButtonStyleSemiCircle is {0, 15, 0, 15}
 * Default value for ESButtonStyleCircle is {10, 10, 10, 10}
 */
@property (nonatomic) UIEdgeInsets buttonPadding;

// TODO: support setting borderWidth and borderColor
/**
 * Default is 1.
 */
//@property (nonatomic) CGFloat borderWidth;
/**
 * Default is nil.
 * If the borderWidth is bigger than 0 and the borderColor is nil, ESButton will automatically 
 * generate a borderColor from buttonColor.
 */
//@property (nonatomic) CGFloat borderColor;

@end
