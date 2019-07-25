//
//  UIAlertController+ESExtension.h
//  ESFramework
//
//  Created by Elf Sundae on 2016/12/29.
//  Copyright © 2016 https://0x123.com. All rights reserved.
//

#import <TargetConditionals.h>
#if TARGET_OS_IOS || TARGET_OS_TV

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * @note The title for button actions must not be nil, except in a tvOS app
 * where a nil title may be used with UIAlertActionStyleCancel.
 */
@interface UIAlertController (ESExtension)

+ (instancetype)actionSheetWithTitle:(nullable NSString *)title;
+ (instancetype)actionSheetWithTitle:(nullable NSString *)title message:(nullable NSString *)message;
+ (instancetype)actionSheetWithTitle:(nullable NSString *)title message:(nullable NSString *)message cancelActionTitle:(nullable NSString *)cancelActionTitle;
+ (instancetype)actionSheetWithTitle:(nullable NSString *)title cancelActionTitle:(nullable NSString *)cancelActionTitle;

+ (instancetype)alertWithTitle:(nullable NSString *)title;
+ (instancetype)alertWithTitle:(nullable NSString *)title message:(nullable NSString *)message;
+ (instancetype)alertWithTitle:(nullable NSString *)title message:(nullable NSString *)message cancelActionTitle:(nullable NSString *)cancelActionTitle;
+ (instancetype)alertWithTitle:(nullable NSString *)title cancelActionTitle:(nullable NSString *)cancelActionTitle;

- (UIAlertAction *)addActionWithTitle:(nullable NSString *)title style:(UIAlertActionStyle)style handler:(void (^ _Nullable)(UIAlertAction *action))handler;
- (UIAlertAction *)addDefaultActionWithTitle:(NSString *)title handler:(void (^ _Nullable)(UIAlertAction *action))handler;
- (UIAlertAction *)addCancelActionWithTitle:(nullable NSString *)title handler:(void (^ _Nullable)(UIAlertAction *action))handler;
- (UIAlertAction *)addDestructiveActionWithTitle:(NSString *)title handler:(void (^ _Nullable)(UIAlertAction *action))handler;

// *INDENT-OFF*
- (void)show NS_EXTENSION_UNAVAILABLE_IOS("Use view controller based solutions where appropriate instead.");
- (void)showAnimated:(BOOL)animated completion:(void (^ _Nullable)(void))completion NS_EXTENSION_UNAVAILABLE_IOS("Use view controller based solutions where appropriate instead.");

- (void)dismiss NS_EXTENSION_UNAVAILABLE_IOS("Use view controller based solutions where appropriate instead.");
- (void)dismissAnimated:(BOOL)animated completion:(void (^ _Nullable)(void))completion NS_EXTENSION_UNAVAILABLE_IOS("Use view controller based solutions where appropriate instead.");

/**
 * Creates and presents an alert controller with UIAlertControllerStyleAlert style.
 */
+ (instancetype)showAlertWithTitle:(nullable NSString *)title message:(nullable NSString *)message cancelActionTitle:(NSString *)cancelActionTitle NS_EXTENSION_UNAVAILABLE_IOS("Use view controller based solutions where appropriate instead.");

/**
 * Creates and presents an alert controller with UIAlertControllerStyleAlert style.
 */
+ (instancetype)showAlertWithTitle:(nullable NSString *)title cancelActionTitle:(NSString *)cancelActionTitle NS_EXTENSION_UNAVAILABLE_IOS("Use view controller based solutions where appropriate instead.");
// *INDENT-ON*

@end

NS_ASSUME_NONNULL_END

#endif
