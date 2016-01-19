//
//  ESActivityLabel.h
//  ESFramework
//
//  Created by Elf Sundae on 5/20/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ESActivityLabelStyle) {
        ESActivityLabelStyleGray,
        ESActivityLabelStyleWhite,
};

/**
 * With a `UIActivityIndicatorView` and a `UILabel`.
 */
@interface ESActivityLabel : UIView

@property (nonatomic) ESActivityLabelStyle style;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *indicatorColor;
@property (nonatomic, strong) UIFont *font;

@property (nonatomic, strong, readonly) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong, readonly) UILabel *label;

- (instancetype)initWithFrame:(CGRect)frame style:(ESActivityLabelStyle)style text:(NSString *)text;
- (instancetype)initWithStyle:(ESActivityLabelStyle)style text:(NSString *)text;
- (instancetype)initWithStyle:(ESActivityLabelStyle)style;

@end
