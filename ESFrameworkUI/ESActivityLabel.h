//
//  ESActivityLabel.h
//  ESFramework
//
//  Created by Elf Sundae on 2014/05/20.
//  Copyright (c) 2014 https://0x123.com All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * With a `UIActivityIndicatorView` and a `UILabel`.
 */
@interface ESActivityLabel : UIView

@property (nonatomic, strong, readonly) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong, readonly) UILabel *textLabel;

- (instancetype)initWithFrame:(CGRect)frame activityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle attributedText:(NSAttributedString *)attributedText;

+ (NSDictionary *)defaultTextAttributes;
@end
