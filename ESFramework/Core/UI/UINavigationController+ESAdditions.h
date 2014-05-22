//
//  UINavigationController+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 5/19/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * `UINavigationController`'s statusBar behavior, orientation behavior is preferred by it's lastViewController's behavior,
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
 * You can config them by re-defining `__ES_CONFIG_UINavigationControllerPreferredStatusBarBehaviorFromTheLastViewController`
 * and `__ES_CONFIG_UINavigationControllerPreferredOrientationBehaviorFromTheLastViewController`
 * 
 */
@interface UINavigationController (ESAdditions)

@end
