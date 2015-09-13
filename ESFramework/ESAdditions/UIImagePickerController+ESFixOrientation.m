//
//  UIImagePickerController+ESFixOrientation.m
//  ESFramework
//
//  Created by Elf Sundae on 6/14/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "UIImagePickerController+ESFixOrientation.h"
#import "ESDefines.h"

@implementation UIImagePickerController (ESFixOrientation)

+ (void)load
{
        @autoreleasepool {
                ESSwizzleInstanceMethod(self, @selector(shouldAutorotate), @selector(_esfix_shouldAutorotate));
                ESSwizzleInstanceMethod(self, @selector(shouldAutorotateToInterfaceOrientation:), @selector(_esfix_shouldAutorotateToInterfaceOrientation:));
                ESSwizzleInstanceMethod(self, @selector(supportedInterfaceOrientations), @selector(_esfix_supportedInterfaceOrientations));
                ESSwizzleInstanceMethod(self, @selector(preferredInterfaceOrientationForPresentation), @selector(_esfix_preferredInterfaceOrientationForPresentation));
        }
}

- (BOOL)_esfix_shouldAutorotate
{
        return NO;
}

- (BOOL)_esfix_shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
        return NO;
}

- (NSUInteger)_esfix_supportedInterfaceOrientations
{
        return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)_esfix_preferredInterfaceOrientationForPresentation
{
        // As Apple doc: The UIImagePickerController class supports portrait mode only
        // https://developer.apple.com/library/ios/documentation/uikit/reference/UIImagePickerController_Class/UIImagePickerController/UIImagePickerController.html
        return UIInterfaceOrientationPortrait;
}

@end
