//
//  UIActionSheet+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-8.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import "UIActionSheet+ESAdditions.h"
#import <objc/runtime.h>

static char dismissBlockKey;
static char cancelBlockKey;
static char customizationBlockKey;

@implementation UIActionSheet (ESAdditions)

- (ESActionSheetCancelBlock)cancelBlock
{
        return objc_getAssociatedObject(self, &cancelBlockKey);
}

- (void)setCancelBlock:(ESActionSheetCancelBlock)cancelBlock
{
        objc_setAssociatedObject(self, &cancelBlockKey, cancelBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (ESActionSheetCustomizationBlock)customizationBlock
{
        return objc_getAssociatedObject(self, &customizationBlockKey);
}

- (void)setCustomizationBlock:(ESActionSheetCustomizationBlock)customizationBlock
{
        objc_setAssociatedObject(self, &customizationBlockKey, customizationBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (ESActionSheetDismissBlock)dismissBlock
{
        return objc_getAssociatedObject(self, &dismissBlockKey);
}

- (void)setDismissBlock:(ESActionSheetDismissBlock)dismissBlock
{
        objc_setAssociatedObject(self, &dismissBlockKey, dismissBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


-(id)initWithTitle:(NSString *)title
customizationBlock:(ESActionSheetCustomizationBlock)customizationBlock
      dismissBlock:(ESActionSheetDismissBlock)dismissBlock
       cancelBlock:(ESActionSheetCancelBlock)cancelBlock
{
        self = [self initWithTitle:title
                          delegate:self
                 cancelButtonTitle:nil
            destructiveButtonTitle:nil
                 otherButtonTitles:nil, nil];
        
        self.cancelBlock = cancelBlock;
        self.customizationBlock = customizationBlock;
        self.dismissBlock = dismissBlock;
        
        return self;
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
        if ([actionSheet cancelButtonIndex] == buttonIndex)
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

+ (void)actionSheetWithTitle:(NSString *)title
           cancelButtonTitle:(NSString *)cancelButtonTitle_
          customizationBlock:(ESActionSheetCustomizationBlock)customizationBlock_
                dismissBlock:(ESActionSheetDismissBlock)dismissBlock_
                 cancelBlock:(ESActionSheetCancelBlock)cancelBlock_
                  showInView:(UIView *)view
           otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
        UIActionSheet *sheet = [[self alloc] initWithTitle:title customizationBlock:customizationBlock_ dismissBlock:dismissBlock_ cancelBlock:cancelBlock_];
        
        if (otherButtonTitles)
        {
                [sheet addButtonWithTitle:otherButtonTitles];
                
                va_list argList;
                va_start(argList, otherButtonTitles);
                NSString *eachTitle = nil;
                while ((eachTitle = va_arg(argList, NSString*)))
                {
                        [sheet addButtonWithTitle:eachTitle];
                }
                va_end(argList);
        }
        
        if (cancelButtonTitle_)
        {
                [sheet addButtonWithTitle:cancelButtonTitle_];
                [sheet setCancelButtonIndex:[sheet numberOfButtons] - 1];
        }
        
        [sheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
        [sheet setDestructiveButtonIndex:-1];
        
        if (sheet.customizationBlock)
                sheet.customizationBlock(sheet);
        
        
        if ([view isKindOfClass:[UITabBar class]])
        {
                [sheet showFromTabBar:(UITabBar *)view];
        }
        else if ([view isKindOfClass:[UIToolbar class]])
        {
                [sheet showFromToolbar:(UIToolbar *)view];
        }
        else
        {
                [sheet showInView:view];
        }
}


@end
