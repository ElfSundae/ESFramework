//
//  UIAlertView+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-8.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ESAlertViewCancelBlock)();
typedef void (^ESAlertViewDismissBlock)(UIAlertView *alertView, NSInteger buttonIndex);
typedef void (^ESAlertViewCustomizationBlock)(UIAlertView *alertView);


@interface UIAlertView (ESAdditions)

@property (nonatomic, copy) ESAlertViewCancelBlock cancelBlock;
@property (nonatomic, copy) ESAlertViewCustomizationBlock customizationBlock;
@property (nonatomic, copy) ESAlertViewDismissBlock dismissBlock;

+ (void)alertViewWithTitle:(NSString *)title
                   message:(NSString *)message
         cancelButtonTitle:(NSString *)cancelButtonTitle_
        customizationBlock:(ESAlertViewCustomizationBlock)customizationBlock
              dismissBlock:(ESAlertViewDismissBlock)dismissBlock
               cancelBlock:(ESAlertViewCancelBlock)cancelBlock
         otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

- (void)setContentLabelTextAlignment:(NSTextAlignment)textAlignment;

@end
