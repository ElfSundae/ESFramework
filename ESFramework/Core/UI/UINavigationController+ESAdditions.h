//
//  UINavigationController+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 5/19/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * `UINavigationController`'s statusBar behave, orientation behave is preferred by it's lastViewController's behave,
 * including:
 *
 * 	- (UIStatusBarStyle)preferredStatusBarStyle;
 * 	- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation;
 * 	- (BOOL)prefersStatusBarHidden;
 *
 * 	- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
 * 	- (BOOL)shouldAutorotate;
 * 	- (NSUInteger)supportedInterfaceOrientations;
 * 	- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation;
 *
 */
@interface UINavigationController (ESAdditions)

@end
