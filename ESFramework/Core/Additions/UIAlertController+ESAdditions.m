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

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message
{
    return [self alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
}

+ (instancetype)alertWithTitle:(NSString *)title
{
    return [self alertWithTitle:title message:nil];
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

- (void)show
{
    [[ESApp rootViewControllerForPresenting] presentViewController:self animated:YES completion:nil];
}

@end
