//
//  UIImageView+ESExtension.h
//  ESFramework
//
//  Created by Elf Sundae on 5/22/14.
//  Copyright © 2014-2020 https://0x123.com All rights reserved.
//

#import <TargetConditionals.h>
#if TARGET_OS_IOS || TARGET_OS_TV

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (ESExtension)

- (void)setImageAnimated:(UIImage *)image;
- (void)setImageAnimated:(UIImage *)image duration:(NSTimeInterval)duration;

@end

NS_ASSUME_NONNULL_END

#endif
