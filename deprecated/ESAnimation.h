//
//  ESAnimation.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-7.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

/**
 * Animations.
 *
 * Example:
 *
 * @code
 * [someView.layer addAnimation:[ESAnimation popup] forKey:nil];
 * [someView setNeedsDisplay];
 * @endcode
 *
 */
@interface ESAnimation : NSObject

+ (CAKeyframeAnimation *)popup:(NSTimeInterval)duration;
+ (CATransition *)fade:(NSTimeInterval)duration;

+ (CATransition *)pushFromTop:(NSTimeInterval)duration;
+ (CATransition *)pushFromLeft:(NSTimeInterval)duration;
+ (CATransition *)pushFromBottom:(NSTimeInterval)duration;
+ (CATransition *)pushFromRight:(NSTimeInterval)duration;

@end
