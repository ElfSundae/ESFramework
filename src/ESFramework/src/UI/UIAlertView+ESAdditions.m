//
//  UIAlertView+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-8.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import "UIAlertView+ESAdditions.h"
#import <objc/runtime.h>

static char dismissBlockKey;
static char cancelBlockKey;
static char customizationBlockKey;

@implementation UIAlertView (ESAdditions)

- (ESAlertViewCancelBlock)cancelBlock
{
        return objc_getAssociatedObject(self, &cancelBlockKey);
}
- (void)setCancelBlock:(ESAlertViewCancelBlock)cancelBlock
{
        objc_setAssociatedObject(self, &cancelBlockKey, cancelBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (ESAlertViewCustomizationBlock)customizationBlock
{
        return objc_getAssociatedObject(self, &customizationBlockKey);
}
- (void)setCustomizationBlock:(ESAlertViewCustomizationBlock)customizationBlock
{
        objc_setAssociatedObject(self, &customizationBlockKey, customizationBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (ESAlertViewDismissBlock)dismissBlock
{
        return objc_getAssociatedObject(self, &dismissBlockKey);
}
- (void)setDismissBlock:(ESAlertViewDismissBlock)dismissBlock
{
        objc_setAssociatedObject(self, &dismissBlockKey, dismissBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
 customizationBlock:(ESAlertViewCustomizationBlock)customizationBlock
       dismissBlock:(ESAlertViewDismissBlock)dismissBlock
        cancelBlock:(ESAlertViewCancelBlock)cancelBlock
{
        self = [self initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        self.customizationBlock = customizationBlock;
        self.dismissBlock = dismissBlock;
        self.cancelBlock = cancelBlock;
        return self;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
        if ([alertView cancelButtonIndex] == buttonIndex)
        {
                if (self.cancelBlock)
                        self.cancelBlock();
        }
        else
        {
                if (self.dismissBlock)
                        self.dismissBlock(self, buttonIndex);
        }
}

+ (void)alertViewWithTitle:(NSString *)title
                   message:(NSString *)message
         cancelButtonTitle:(NSString *)cancelButtonTitle_
        customizationBlock:(ESAlertViewCustomizationBlock)customizationBlock
              dismissBlock:(ESAlertViewDismissBlock)dismissBlock
               cancelBlock:(ESAlertViewCancelBlock)cancelBlock
         otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message customizationBlock:customizationBlock dismissBlock:dismissBlock cancelBlock:cancelBlock];
        
        if (otherButtonTitles)
        {
                [alertView addButtonWithTitle:otherButtonTitles];
                va_list argList;
                va_start(argList, otherButtonTitles);
                NSString *eachTitle = nil;
                while ((eachTitle = va_arg(argList, NSString*)))
                {
                        [alertView addButtonWithTitle:eachTitle];
                }
                va_end(argList);
        }
        
        if (cancelButtonTitle_)
        {
                [alertView addButtonWithTitle:cancelButtonTitle_];
                [alertView setCancelButtonIndex:[alertView numberOfButtons] - 1];
        }
        
        if (alertView.customizationBlock)
        {
                alertView.customizationBlock(alertView);
        }
        
        [alertView show];
}

- (void)setContentLabelTextAlignment:(NSTextAlignment)textAlignment
{
        int i = 0;
        for (UIView *v in [self subviews]) {
                if ([[v class] isSubclassOfClass:[UILabel class]]) {
                        UILabel *label = (UILabel *)v;
                        if (!self.title ||
                            (self.title && i > 0)) {
                                label.textAlignment = textAlignment;
                        }
                        i++;
                }
        }
}


@end
