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

/// Creates and returns a alert controller with style UIAlertControllerStyleActionSheet.
+ (instancetype)actionSheet;
/// Creates and returns a alert controller with style UIAlertControllerStyleActionSheet.
+ (instancetype)actionSheetWithTitle:(nullable NSString *)title;
/// Creates and returns a alert controller with style UIAlertControllerStyleActionSheet.
+ (instancetype)actionSheetWithTitle:(nullable NSString *)title message:(nullable NSString *)message;
/// Creates and returns a alert controller with style UIAlertControllerStyleActionSheet.
+ (instancetype)actionSheetWithTitle:(nullable NSString *)title cancelButtonTitle:(nullable NSString *)cancelButtonTitle;
/// Creates and returns a alert controller with style UIAlertControllerStyleActionSheet.
+ (instancetype)actionSheetWithTitle:(nullable NSString *)title message:(nullable NSString *)message cancelButtonTitle:(nullable NSString *)cancelButtonTitle;

/// Creates and returns a alert controller with style UIAlertControllerStyleAlert.
+ (instancetype)alert;
/// Creates and returns a alert controller with style UIAlertControllerStyleAlert.
+ (instancetype)alertWithTitle:(nullable NSString *)title;
/// Creates and returns a alert controller with style UIAlertControllerStyleAlert.
+ (instancetype)alertWithTitle:(nullable NSString *)title message:(nullable NSString *)message;
/// Creates and returns a alert controller with style UIAlertControllerStyleAlert.
+ (instancetype)alertWithTitle:(nullable NSString *)title cancelButtonTitle:(nullable NSString *)cancelButtonTitle;
/// Creates and returns a alert controller with style UIAlertControllerStyleAlert.
+ (instancetype)alertWithTitle:(nullable NSString *)title message:(nullable NSString *)message cancelButtonTitle:(nullable NSString *)cancelButtonTitle;

/// Attaches an action object to the alert or action sheet.
- (UIAlertAction *)addActionWithTitle:(nullable NSString *)title style:(UIAlertActionStyle)style handler:(void (^ _Nullable)(UIAlertAction *action))handler;
/// Attaches an action button with default style to the alert or action sheet.
- (UIAlertAction *)addButtonWithTitle:(nullable NSString *)title handler:(void (^ _Nullable)(UIAlertAction *action))handler;
/// Attaches an action button with cancel style to the alert or action sheet.
- (UIAlertAction *)addCancelButtonWithTitle:(nullable NSString *)title handler:(void (^ _Nullable)(UIAlertAction *action))handler;
/// Attaches an action button with destructive style to the alert or action sheet.
- (UIAlertAction *)addDestructiveButtonTitle:(nullable NSString *)title handler:(void (^ _Nullable)(UIAlertAction *action))handler;

/// Presents this alert controller.
- (void)show;
/// Presents this alert controller.
- (void)showAnimated:(BOOL)animated completion:(void (^ _Nullable)(void))completion;

/// Dismisses this alert controller.
- (void)dismiss;
/// Dismisses this alert controller.
- (void)dismissAnimated:(BOOL)animated completion:(void (^ _Nullable)(void))completion;

/// Creates and presents an alert.
+ (instancetype)showAlertWithTitle:(nullable NSString *)title message:(nullable NSString *)message cancelButtonTitle:(nullable NSString *)cancelButtonTitle;

@end

NS_ASSUME_NONNULL_END
