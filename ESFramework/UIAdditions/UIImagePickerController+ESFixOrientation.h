//
//  UIImagePickerController+ESFixOrientation.h
//  ESFramework
//
//  Created by Elf Sundae on 6/14/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Fix Crash while presenting `UIImagePickerController` below iOS7.0
 *
 * @code
 * preferredInterfaceOrientationForPresentation must return a supported interface orientation!
 *
 * 0   CoreFoundation                      0x01d8b02e __exceptionPreprocess + 206
 * 1   libobjc.A.dylib                     0x031a3e7e objc_exception_throw + 44
 * 2   CoreFoundation                      0x01d8adeb +[NSException raise:format:] + 139
 * 3   UIKit                               0x027dceca -[UIViewController _preferredInterfaceOrientationForPresentation] + 229
 * 4   UIKit                               0x029dc423 -[UIWindowController transition:fromViewController:toViewController:target:didEndSelector:] + 2078
 * 5   UIKit                               0x027d9ee3 -[UIViewController presentViewController:withTransition:completion:] + 4521
 * 6   UIKit                               0x027da167 -[UIViewController presentViewController:animated:completion:] + 112
 * @endcode
 *
 * ### Fix:
 *
 * Rewrite `-shouldAutorotate`, `-shouldAutorotateToInterfaceOrientation:`,
 * `-supportedInterfaceOrientations`, `-preferredInterfaceOrientationForPresentation` 
 * via Category.
 * The UIImagePickerController class only supports portrait mode:
 * https://developer.apple.com/library/ios/documentation/uikit/reference/UIImagePickerController_Class/UIImagePickerController/UIImagePickerController.html
 *
 * ref: http://stackoverflow.com/a/12570501/521946
 *
 */
@interface UIImagePickerController (ESFixOrientation)
@end
