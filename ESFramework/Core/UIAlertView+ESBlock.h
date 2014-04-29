//
//  UIAlertView+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-8.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ESFrameworkCore/ESDefines.h>

typedef void (^ESUIAlertViewDidDismissBlock)(UIAlertView *alertView, NSInteger buttonIndex);

@interface UIAlertView (ESBlock) <UIAlertViewDelegate>

/**
 * Dismiss without callback.
 */
- (void)dismissWithAnimated:(BOOL)animated;
/**
 * Set message alignment.
 * @warning It's not work on iOS 7.0+
 */
@property (nonatomic) NSTextAlignment messageAlignment __ES_ATTRIBUTE_DEPRECATED;
/**
 * Invoked after dismissed.
 */
@property (nonatomic, copy) ESUIAlertViewDidDismissBlock didDismissBlock;

+ (instancetype)alertViewWithTitle:(NSString *)title
                           message:(NSString *)message
                 cancelButtonTitle:(NSString *)cancelButtonTitle
                      didDismissBlock:(ESUIAlertViewDidDismissBlock)didDismissBlock
                 otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
/**
 * Show a alertView with a cancel button, the cacel button title is localized "OK" string.
 */
+ (void)showWithTitle:(NSString *)title message:(NSString *)message;

+ (void)showWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle;

@end