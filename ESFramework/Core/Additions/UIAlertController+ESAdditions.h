//
//  UIAlertController+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 2016/12/29.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertController (ESAdditions)

+ (instancetype)actionSheetWithTitle:(nullable NSString *)title message:(nullable NSString *)message;
+ (instancetype)actionSheetWithTitle:(nullable NSString *)title;
+ (instancetype)alertWithTitle:(nullable NSString *)title message:(nullable NSString *)message;
+ (instancetype)alertWithTitle:(nullable NSString *)title;

- (UIAlertAction *)addActionWithTitle:(nullable NSString *)title style:(UIAlertActionStyle)style handler:(void (^ __nullable)(UIAlertAction *action))handler;

- (UIAlertAction *)addButtonWithTitle:(nullable NSString *)title handler:(void (^ __nullable)(UIAlertAction *action))handler;
- (UIAlertAction *)addCancelButtonWithTitle:(nullable NSString *)title handler:(void (^ __nullable)(UIAlertAction *action))handler;
- (UIAlertAction *)addCancelButtonWithTitle:(nullable NSString *)title;
- (UIAlertAction *)addDestructiveButtonTitle:(nullable NSString *)title handler:(void (^ __nullable)(UIAlertAction *action))handler;

- (void)show;

@end

NS_ASSUME_NONNULL_END
