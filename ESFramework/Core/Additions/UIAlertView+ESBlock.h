//
//  UIAlertView+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-8.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
typedef void (^ESUIAlertViewDidDismissBlock)(UIAlertView *alertView, NSInteger buttonIndex);
#pragma clang diagnostic pop

/**
 * `UIAlertView` with blocks.
 */
@interface UIAlertView (ESBlock) <UIAlertViewDelegate>

///=============================================
/// @name Initialization
///=============================================

+ (instancetype)alertViewWithTitle:(NSString *)title
                           message:(NSString *)message
                 cancelButtonTitle:(NSString *)cancelButtonTitle
                      didDismissBlock:(ESUIAlertViewDidDismissBlock)didDismissBlock
                 otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

///=============================================
/// @name Customization
///=============================================

/**
 * Set message alignment.
 *
 * @warning It's not work on iOS 7.0+
 */
//@property (nonatomic) NSTextAlignment messageAlignment __attribute__((deprecated("It is not work on iOS 7+")));

///=============================================
/// @name Helper Methods
///=============================================

/**
 * Shows a alertView with a cancel button, the cancel button title is localized "OK" string.
 */
+ (void)showWithTitle:(NSString *)title message:(NSString *)message;

+ (void)showWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle;

///=============================================
/// @name Dismiss
///=============================================

/**
 * Invoked after dismissed.
 */
@property (nonatomic, copy) ESUIAlertViewDidDismissBlock didDismissBlock;

/**
 * Dismiss alert view without callback.
 */
- (void)dismissWithAnimated:(BOOL)animated;

@end
