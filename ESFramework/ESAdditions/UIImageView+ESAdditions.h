//
//  UIImageView+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 5/22/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (ESAdditions)
- (void)setImageAnimated:(UIImage *)image;
- (void)setImageAnimated:(UIImage *)image duration:(NSTimeInterval)duration;
@end
