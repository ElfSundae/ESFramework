//
//  UIAlertController+ESExtension.m
//  ESFramework
//
//  Created by Elf Sundae on 2016/12/29.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "UIAlertController+ESExtension.h"
#import "UIApplication+ESExtension.h"

@implementation UIAlertController (ESExtension)

+ (instancetype)actionSheetWithTitle:(nullable NSString *)title message:(nullable NSString *)message
{
    return [self alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
}

+ (instancetype)actionSheetWithTitle:(nullable NSString *)title message:(nullable NSString *)message cancelActionTitle:(nullable NSString *)cancelActionTitle
{
    UIAlertController *alert = [self actionSheetWithTitle:title message:message];
    [alert addCancelActionWithTitle:cancelActionTitle handler:nil];
    return alert;
}

+ (instancetype)actionSheetWithTitle:(nullable NSString *)title cancelActionTitle:(nullable NSString *)cancelActionTitle
{
    return [self actionSheetWithTitle:title message:nil cancelActionTitle:cancelActionTitle];
}

+ (instancetype)alertWithTitle:(nullable NSString *)title message:(nullable NSString *)message
{
    return [self alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
}

+ (instancetype)alertWithTitle:(nullable NSString *)title message:(nullable NSString *)message cancelActionTitle:(nullable NSString *)cancelActionTitle
{
    UIAlertController *alert = [self alertWithTitle:title message:message];
    [alert addCancelActionWithTitle:cancelActionTitle handler:nil];
    return alert;
}

+ (instancetype)alertWithTitle:(nullable NSString *)title cancelActionTitle:(nullable NSString *)cancelActionTitle
{
    return [self alertWithTitle:title message:nil cancelActionTitle:cancelActionTitle];
}

- (UIAlertAction *)addActionWithTitle:(nullable NSString *)title style:(UIAlertActionStyle)style handler:(void (^ _Nullable)(UIAlertAction *action))handler
{
    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:style handler:handler];
    [self addAction:action];
    return action;
}

- (UIAlertAction *)addDefaultActionWithTitle:(NSString *)title handler:(void (^ _Nullable)(UIAlertAction *action))handler
{
    return [self addActionWithTitle:title style:UIAlertActionStyleDefault handler:handler];
}

- (UIAlertAction *)addCancelActionWithTitle:(nullable NSString *)title handler:(void (^ _Nullable)(UIAlertAction *action))handler
{
    return [self addActionWithTitle:title style:UIAlertActionStyleCancel handler:handler];
}

- (UIAlertAction *)addDestructiveActionWithTitle:(NSString *)title handler:(void (^ _Nullable)(UIAlertAction *action))handler
{
    return [self addActionWithTitle:title style:UIAlertActionStyleDestructive handler:handler];
}

- (void)show
{
    [self showAnimated:YES completion:nil];
}

- (void)showAnimated:(BOOL)animated completion:(void (^ _Nullable)(void))completion
{
    [UIApplication.sharedApplication presentViewController:self animated:animated completion:completion];
}

- (void)dismiss
{
    [self dismissAnimated:YES completion:nil];
}

- (void)dismissAnimated:(BOOL)animated completion:(void (^ _Nullable)(void))completion
{
    [self dismissViewControllerAnimated:animated completion:completion];
}

+ (instancetype)showAlertWithTitle:(nullable NSString *)title message:(nullable NSString *)message cancelActionTitle:(NSString *)cancelActionTitle
{
    UIAlertController *alert = [self alertWithTitle:title message:message cancelActionTitle:cancelActionTitle];
    [alert show];
    return alert;
}

@end
