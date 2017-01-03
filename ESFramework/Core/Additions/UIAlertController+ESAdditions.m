//
//  UIAlertController+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 2016/12/29.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "UIAlertController+ESAdditions.h"
#import "ESApp.h"

@implementation UIAlertController (ESAdditions)

+ (instancetype)actionSheetWithTitle:(NSString *)title message:(NSString *)message
{
    return [self alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
}

+ (instancetype)actionSheetWithTitle:(NSString *)title
{
    return [self actionSheetWithTitle:title message:nil];
}

+ (instancetype)actionSheet
{
    return [self actionSheetWithTitle:nil];
}

+ (instancetype)actionSheetWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle
{
    UIAlertController *alert = [self actionSheetWithTitle:title message:message];

    if (cancelButtonTitle) {
        [alert addCancelButtonWithTitle:cancelButtonTitle];
    }

    return alert;
}

+ (instancetype)actionSheetWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle
{
    return [self actionSheetWithTitle:title message:nil cancelButtonTitle:cancelButtonTitle];
}

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message
{
    return [self alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
}

+ (instancetype)alertWithTitle:(NSString *)title
{
    return [self alertWithTitle:title message:nil];
}

+ (instancetype)alert
{
    return [self alertWithTitle:nil];
}

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle
{
    UIAlertController *alert = [self alertWithTitle:title message:message];

    if (cancelButtonTitle) {
        [alert addCancelButtonWithTitle:cancelButtonTitle];
    }

    return alert;
}

+ (instancetype)alertWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle
{
    return [self alertWithTitle:title message:nil cancelButtonTitle:cancelButtonTitle];
}

- (UIAlertAction *)addActionWithTitle:(NSString *)title style:(UIAlertActionStyle)style handler:(void (^)(UIAlertAction * _Nonnull))handler
{
    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:style handler:handler];

    [self addAction:action];

    return action;
}

- (UIAlertAction *)addButtonWithTitle:(NSString *)title handler:(void (^)(UIAlertAction * _Nonnull))handler
{
    return [self addActionWithTitle:title style:UIAlertActionStyleDefault handler:handler];
}

- (UIAlertAction *)addCancelButtonWithTitle:(NSString *)title handler:(void (^)(UIAlertAction * _Nonnull))handler
{
    return [self addActionWithTitle:title style:UIAlertActionStyleCancel handler:handler];
}

- (UIAlertAction *)addCancelButtonWithTitle:(NSString *)title
{
    return [self addCancelButtonWithTitle:title handler:nil];
}

- (UIAlertAction *)addDestructiveButtonTitle:(NSString *)title handler:(void (^)(UIAlertAction * _Nonnull))handler
{
    return [self addActionWithTitle:title style:UIAlertActionStyleDestructive handler:handler];
}

- (void)addTextFieldWithPlaceholder:(NSString *)placeholder configurationHandler:(void (^)(UITextField * _Nonnull))configurationHandler
{
    [self addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = placeholder;

        if (configurationHandler) {
            configurationHandler(textField);
        }
    }];
}

- (void)addSecureTextFieldWithPlaceholder:(nullable NSString *)placeholder configurationHandler:(void (^ __nullable)(UITextField *textField))configurationHandler
{
    [self addTextFieldWithPlaceholder:placeholder configurationHandler:^(UITextField * _Nonnull textField) {
        textField.secureTextEntry = YES;

        if (configurationHandler) {
            configurationHandler(textField);
        }
    }];
}

- (UIAlertAction *)defaultAction
{
    if (UIAlertControllerStyleAlert == self.preferredStyle) {
        if ([self respondsToSelector:NSSelectorFromString(@"preferredAction")]) {
            return self.preferredAction;
        } else if ([self respondsToSelector:NSSelectorFromString(@"_defaultAlertAction")]) {
            return [self valueForKeyPath:@"_defaultAlertAction"];
        }
    }

    return nil;
}

- (void)setDefaultAction:(UIAlertAction *)defaultAction
{
    if (UIAlertControllerStyleAlert == self.preferredStyle) {
        if ([self respondsToSelector:NSSelectorFromString(@"preferredAction")]) {
            self.preferredAction = defaultAction;
        } else if ([self respondsToSelector:NSSelectorFromString(@"_defaultAlertAction")]) {
            [self setValue:defaultAction forKeyPath:@"_defaultAlertAction"];
        }
    }
}

- (void)showAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    [ESApp presentViewController:self animated:animated completion:completion];
}

- (void)show
{
    [self showAnimated:YES completion:nil];
}

- (void)dismissAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    [self.presentingViewController dismissViewControllerAnimated:animated completion:completion];
}

- (void)dismiss
{
    [self dismissAnimated:YES completion:nil];
}

+ (instancetype)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle
{
    UIAlertController *alert = [self alertWithTitle:title message:message cancelButtonTitle:cancelButtonTitle];

    [alert show];

    return alert;
}

@end
