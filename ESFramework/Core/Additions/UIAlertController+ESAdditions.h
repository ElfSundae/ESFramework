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
+ (instancetype)actionSheetWithTitle:(nullable NSString *)title message:(nullable NSString *)message cancelButtonTitle:(nullable NSString *)cancelButtonTitle;
+ (instancetype)actionSheetWithTitle:(nullable NSString *)title;
+ (instancetype)actionSheet;

+ (instancetype)alertWithTitle:(nullable NSString *)title message:(nullable NSString *)message;
+ (instancetype)alertWithTitle:(nullable NSString *)title message:(nullable NSString *)message cancelButtonTitle:(nullable NSString *)cancelButtonTitle;
+ (instancetype)alertWithTitle:(nullable NSString *)title;
+ (instancetype)alert;

- (UIAlertAction *)addActionWithTitle:(nullable NSString *)title style:(UIAlertActionStyle)style handler:(void (^ __nullable)(UIAlertAction *action))handler;

- (UIAlertAction *)addButtonWithTitle:(nullable NSString *)title handler:(void (^ __nullable)(UIAlertAction *action))handler;
- (UIAlertAction *)addCancelButtonWithTitle:(nullable NSString *)title handler:(void (^ __nullable)(UIAlertAction *action))handler;
- (UIAlertAction *)addCancelButtonWithTitle:(nullable NSString *)title;
- (UIAlertAction *)addDestructiveButtonTitle:(nullable NSString *)title handler:(void (^ __nullable)(UIAlertAction *action))handler;

- (void)addTextFieldWithPlaceholder:(nullable NSString *)placeholder configurationHandler:(void (^ __nullable)(UITextField *textField))configurationHandler;
- (void)addSecureTextFieldWithPlaceholder:(nullable NSString *)placeholder configurationHandler:(void (^ __nullable)(UITextField *textField))configurationHandler;

/**
 * The preferred action for the user to take from an alert.
 *
 * @see -[UIAlertController preferredAction]
 */
@property (nonatomic, strong, nullable) UIAlertAction *defaultAction;

- (void)showAnimated:(BOOL)animated completion:(void (^ __nullable)(void))completion;
- (void)show;

- (void)dismissAnimated:(BOOL)animated completion:(void (^ __nullable)(void))completion;
- (void)dismiss;

+ (instancetype)showAlertWithTitle:(nullable NSString *)title message:(nullable NSString *)message cancelButtonTitle:(nullable NSString *)cancelButtonTitle;

@end

NS_ASSUME_NONNULL_END
