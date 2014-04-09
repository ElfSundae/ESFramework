//
//  UIActionSheet+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-8.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ESUIActionSheetDidDismissBlock)(UIActionSheet *actionSheet, NSInteger buttonIndex);

@interface UIActionSheet (ESAdditions) <UIActionSheetDelegate>

/**
 * Invoked after dismissed.
 */
@property (nonatomic, copy) ESUIActionSheetDidDismissBlock didDismissBlock;

+ (instancetype)actionSheetWithTitle:(NSString *)title
                   cancelButtonTitle:(NSString *)cancelButtonTitle
                     didDismissBlock:(ESUIActionSheetDidDismissBlock)didDismissBlock
                   otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end
