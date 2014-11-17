//
//  UIGestureRecognizer+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 4/19/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESDefines.h"

typedef void (^ESUIGestureRecognizerHandler)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint locationInView);

/**
 * UIGestureRecognizer with block.
 */
@interface UIGestureRecognizer (ESAdditions)

- (instancetype)initWithHandler:(ESUIGestureRecognizerHandler)handler;
+ (instancetype)recognizerWithHandler:(ESUIGestureRecognizerHandler)handler;

/**
 * !!!Note: This method is used to fix UITapGestureRecognizer issue on iOS5.
 * See http://stackoverflow.com/q/3344341/521946
 * On iOS6+, Apple has fixed this, see http://stackoverflow.com/a/20093084/521946
 *
 * `[UIGestureRecognizer recognizerWithHandler:]` method already apply this fix,
 * If you implement UIGestureRecognizerDelegate yourself, for an UIGestureRecognizer, 
 * call this method first in the delegate method like this:
 *
 * @code
 * - (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
 * {
 *         if (![gestureRecognizer es_shouldReceiveTouch:touch]) {
 *                 return NO;
 *         }
 *         // other stuff
 *         return YES;
 * }
 * @endcode
 *
 * @code
 * // Source code of -es_shouldReceiveTouch:
 * - (BOOL)es_shouldReceiveTouch:(UITouch *)touch
 * {
 *         if ([self isKindOfClass:[UITapGestureRecognizer class]] &&
 *             [touch.view isKindOfClass:[UIControl class]]) {
 *                 return NO;
 *         }
 *         return YES;
 * }
 * @endcode
 *
 */
- (BOOL)es_shouldReceiveTouch:(UITouch *)touch;

@end
