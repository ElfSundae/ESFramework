//
//  UIAlertView+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-8.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import "UIAlertView+ESBlock.h"
#import <objc/runtime.h>
#import <ESFrameworkCore/ESDefines.h>

static char _didDismissBlockKey;

@implementation UIAlertView (ESBlock)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (ESUIAlertViewDidDismissBlock)didDismissBlock
{
        return objc_getAssociatedObject(self, &_didDismissBlockKey);
}
- (void)setDidDismissBlock:(ESUIAlertViewDidDismissBlock)didDismissBlock
{
        objc_setAssociatedObject(self, &_didDismissBlockKey, didDismissBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UILabel *)_esMessageLabel
{
        int i = 0;
        for (UIView *v in self.subviews) {
                if ([v isKindOfClass:[UILabel class]]) {
                        UILabel *label = (UILabel *)v;
                        if (!self.title || (self.title && i > 0)) {
                                return label;
                        }
                        i++;
                }
        }
        return nil;
}

- (NSTextAlignment)messageAlignment
{
        return [self _esMessageLabel].textAlignment;
}

- (void)setMessageAlignment:(NSTextAlignment)messageAlignment
{
        [self _esMessageLabel].textAlignment = messageAlignment;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message dismissBlock:(ESUIAlertViewDidDismissBlock)dismissBlock
{
        self = [self initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        self.didDismissBlock = dismissBlock;
        return self;
}

// Delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
        if (self.didDismissBlock) {
                self.didDismissBlock(self, buttonIndex);
        }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

- (void)dismissWithAnimated:(BOOL)animated
{
        self.delegate = nil;
        [self dismissWithClickedButtonIndex:0 animated:animated];
}

+ (instancetype)alertViewWithTitle:(NSString *)title
                           message:(NSString *)message
                 cancelButtonTitle:(NSString *)cancelButtonTitle
                   didDismissBlock:(ESUIAlertViewDidDismissBlock)didDismissBlock
                 otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
        UIAlertView *alertView = [[self alloc] initWithTitle:title message:message dismissBlock:didDismissBlock];
        if (otherButtonTitles) {
                va_list argsList;
                va_start(argsList, otherButtonTitles);
                NSString *eachTitle = otherButtonTitles;
                do {
                        [alertView addButtonWithTitle:eachTitle];
                } while ((eachTitle = va_arg(argsList, NSString *)));
                va_end(argsList);
        }
        
        if (cancelButtonTitle) {
                [alertView addButtonWithTitle:cancelButtonTitle];
                [alertView setCancelButtonIndex:[alertView numberOfButtons] - 1];
        }
        return alertView;
}

+ (void)showWithTitle:(NSString *)title message:(NSString *)message
{
        [self showWithTitle:title message:message cancelButtonTitle:_(@"OK")];
}

+ (void)showWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle
{
        UIAlertView *alertView = [self alertViewWithTitle:title message:message cancelButtonTitle:cancelButtonTitle didDismissBlock:nil otherButtonTitles:nil, nil];
        [alertView show];
}

@end
