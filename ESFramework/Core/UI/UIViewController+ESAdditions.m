//
//  UIViewController+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 5/7/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "UIViewController+ESAdditions.h"
#import "ESDefines.h"
#import "ESApp.h"

@implementation UIViewController (ESAdditions)

+ (void)load
{
        @autoreleasepool {
                if (ESOSVersionIsAbove7()) {
                        ESSwizzleInstanceMethod(self, @selector(viewDidLoad), @selector(_es_viewDidLoad));
                }
        }
}

- (void)_es_viewDidLoad
{
        // Fix iOS 7 push/pop issue
        // http://stackoverflow.com/q/18881427
        self.view.backgroundColor = [ESApp keyWindow].backgroundColor;
        
        [self _es_viewDidLoad];
}


- (UIViewController *)previousViewController
{
        UINavigationController *navController = self.navigationController;
        if (navController) {
                NSArray *controllers = navController.viewControllers;
                if (0 == controllers.count) {
                        return nil;
                }
                NSUInteger index = [controllers indexOfObject:self];
                if (NSNotFound == index) {
                        return nil;
                }
                if (index > 0) {
                        return controllers[index - 1];
                }
        }
        return nil;
}

- (UIViewController *)nextViewController
{
        UINavigationController *navController = self.navigationController;
        if (navController) {
                NSArray *controllers = navController.viewControllers;
                if (0 == controllers.count) {
                        return nil;
                }
                NSUInteger index = [controllers indexOfObject:self];
                if (NSNotFound == index) {
                        return nil;
                }
                if ((index + 1) < controllers.count) {
                        return controllers[index + 1];
                }
        }
	
	return nil;
}

@end
