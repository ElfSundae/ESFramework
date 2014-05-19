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
+ (instancetype)recognizerWithHandler:(ESUIGestureRecognizerHandler)handler;
/**
 * To fix [iOS5 UIControl issue](http://stackoverflow.com/a/13662967/521946) for UITapGestureRecognizer.
 * `[UIGestureRecognizer recognizerWithHandler:] already fix this, If you implement UIGestureRecognizerDelegate
 * for an UIGestureRecognizer, call this method first.
 *
 *	- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
 *	{
 *	        if (![gestureRecognizer esShouldReceiveTouch:touch]) {
 *	                return NO;
 *	        }
 *	        // other stuff
 *	        return YES;
 *	}
 *
 */
- (BOOL)esShouldReceiveTouch:(UITouch *)touch;
@end
