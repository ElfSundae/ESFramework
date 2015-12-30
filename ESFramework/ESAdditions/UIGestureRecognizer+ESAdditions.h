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

@interface UIGestureRecognizer (ESAdditions)

- (instancetype)initWithHandler:(ESUIGestureRecognizerHandler)handler;
+ (instancetype)recognizerWithHandler:(ESUIGestureRecognizerHandler)handler;

@end
