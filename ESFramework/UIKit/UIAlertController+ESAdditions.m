//
//  UIAlertController+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 2016/12/29.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "UIAlertController+ESAdditions.h"
#import "UIApplication+ESAdditions.h"

@implementation UIAlertController (ESAdditions)

+ (instancetype)actionSheetWithTitle:(NSString *)title message:(NSString *)message
{
    return [self alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
}

+ (instancetype)actionSheetWithTitle:(NSString *)title message:(NSString *)message cancelActionTitle:(NSString *)cancelActionTitle
{
    UIAlertController *alert = [self actionSheetWithTitle:title message:message];
    [alert addCancelActionWithTitle:cancelActionTitle handler:nil];
    return alert;
}

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message
{
    return [self alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
}

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message cancelActionTitle:(NSString *)cancelActionTitle
{
    UIAlertController *alert = [self alertWithTitle:title message:message];
    [alert addCancelActionWithTitle:cancelActionTitle handler:nil];
    return alert;
}

- (UIAlertAction *)addActionWithTitle:(NSString *)title style:(UIAlertActionStyle)style handler:(void (^)(UIAlertAction *))handler
{
    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:style handler:handler];
    [self addAction:action];
    return action;
}

- (UIAlertAction *)addDefaultActionWithTitle:(NSString *)title handler:(void (^)(UIAlertAction *))handler
{
    return [self addActionWithTitle:title style:UIAlertActionStyleDefault handler:handler];
}

- (UIAlertAction *)addCancelActionWithTitle:(NSString *)title handler:(void (^)(UIAlertAction *))handler
{
    return [self addActionWithTitle:title style:UIAlertActionStyleCancel handler:handler];
}

- (UIAlertAction *)addDestructiveActionWithTitle:(NSString *)title handler:(void (^)(UIAlertAction *))handler
{
    return [self addActionWithTitle:title style:UIAlertActionStyleDestructive handler:handler];
}

- (void)show
{
    [self showAnimated:YES completion:nil];
}

- (void)showAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    [UIApplication.sharedApplication presentViewController:self animated:animated completion:completion];
}

- (void)dismiss
{
    [self dismissAnimated:YES completion:nil];
}

- (void)dismissAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    [self dismissViewControllerAnimated:animated completion:completion];
}

+ (instancetype)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelActionTitle:(NSString *)cancelActionTitle
{
    UIAlertController *alert = [self alertWithTitle:title message:message cancelActionTitle:cancelActionTitle];
    [alert show];
    return alert;
}

@end
