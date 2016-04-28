//
//  UIAlertView+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-8.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "UIAlertView+ESBlock.h"
#import "ESDefines.h"

static const void *_didDismissBlockKey = &_didDismissBlockKey;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
@implementation UIAlertView (ESBlock)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (ESUIAlertViewDidDismissBlock)didDismissBlock
{
        return ESGetAssociatedObject(self, _didDismissBlockKey);
}
- (void)setDidDismissBlock:(ESUIAlertViewDidDismissBlock)didDismissBlock
{
        ESSetAssociatedObject(self, _didDismissBlockKey, didDismissBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
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
#pragma clang diagnostic pop

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
        [self showWithTitle:title message:message cancelButtonTitle:ESLocalizedString(@"OK")];
}

+ (void)showWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle
{
        UIAlertView *alertView = [self alertViewWithTitle:title message:message cancelButtonTitle:cancelButtonTitle didDismissBlock:nil otherButtonTitles:nil];
        [alertView show];
}

@end
