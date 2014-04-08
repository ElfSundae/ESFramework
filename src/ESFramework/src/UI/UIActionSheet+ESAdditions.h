//
//  UIActionSheet+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-8.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ESActionSheetCancelBlock)();
typedef void (^ESActionSheetDismissBlock)(UIActionSheet *actionSheet, NSInteger buttonIndex);
typedef void (^ESActionSheetCustomizationBlock)(UIActionSheet *actionSheet);


@interface UIActionSheet (ESAdditions)

@property (nonatomic, copy) ESActionSheetCancelBlock cancelBlock;
@property (nonatomic, copy) ESActionSheetCustomizationBlock customizationBlock;
@property (nonatomic, copy) ESActionSheetDismissBlock dismissBlock;

+ (void)actionSheetWithTitle:(NSString *)title
           cancelButtonTitle:(NSString *)cancelButtonTitle_
          customizationBlock:(ESActionSheetCustomizationBlock)customizationBlock_
                dismissBlock:(ESActionSheetDismissBlock)dismissBlock_
                 cancelBlock:(ESActionSheetCancelBlock)cancelBlock_
                  showInView:(UIView *)view
           otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end
