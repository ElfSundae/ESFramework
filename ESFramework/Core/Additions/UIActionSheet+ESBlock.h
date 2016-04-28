//
//  UIActionSheet+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-8.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
typedef void (^ESUIActionSheetDidDismissBlock)(UIActionSheet *actionSheet, NSInteger buttonIndex);
#pragma clang diagnostic pop

/**
 * `UIActionSheet` with blocks.
 */
@interface UIActionSheet (ESBlock) <UIActionSheetDelegate>

@property (nonatomic, copy) ESUIActionSheetDidDismissBlock didDismissBlock;

///=============================================
/// @name Initialization
///=============================================

+ (instancetype)actionSheetWithTitle:(NSString *)title
                   cancelButtonTitle:(NSString *)cancelButtonTitle
                     didDismissBlock:(ESUIActionSheetDidDismissBlock)didDismissBlock
                   otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end
