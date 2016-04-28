//
//  UIActionSheet+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-8.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "UIActionSheet+ESBlock.h"
#import "ESDefines.h"

static const void *_didDismissBlockKey = &_didDismissBlockKey;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
@implementation UIActionSheet (ESBlock)

- (ESUIActionSheetDidDismissBlock)didDismissBlock
{
        return ESGetAssociatedObject(self, _didDismissBlockKey);
}

- (void)setDidDismissBlock:(ESUIActionSheetDidDismissBlock)didDismissBlock
{
        ESSetAssociatedObject(self, _didDismissBlockKey, didDismissBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (instancetype)initWithTitle:(NSString *)title didDismissBlock:(ESUIActionSheetDidDismissBlock)didDismissBlock
{
        self = [self initWithTitle:title delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        self.didDismissBlock = didDismissBlock;
        return self;
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
        if (self.didDismissBlock) {
                self.didDismissBlock(self, buttonIndex);
        }
}
#pragma clang diagnostic pop

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

+ (instancetype)actionSheetWithTitle:(NSString *)title
           cancelButtonTitle:(NSString *)cancelButtonTitle
             didDismissBlock:(ESUIActionSheetDidDismissBlock)didDismissBlock
           otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
        UIActionSheet *actionSheet = [[self alloc] initWithTitle:title didDismissBlock:didDismissBlock];
        if (otherButtonTitles) {
                va_list argsList;
                va_start(argsList, otherButtonTitles);
                NSString *eachTitle = otherButtonTitles;
                do {
                        [actionSheet addButtonWithTitle:eachTitle];
                } while ((eachTitle = va_arg(argsList, NSString *)));
                va_end(argsList);
        }
        
        if (cancelButtonTitle) {
                [actionSheet addButtonWithTitle:cancelButtonTitle];
                [actionSheet setCancelButtonIndex:actionSheet.numberOfButtons - 1];
        }
        
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        actionSheet.destructiveButtonIndex = -1;
        
        return actionSheet;
}

@end
