//
//  ESAnimations.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-7.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@import QuartzCore;

@interface ESAnimations : NSObject
/**
 * The pop-up animation like UIAlertView shows.
 *
 * example:
 @code
 [someView.layer addAnimation:[ESAnimations keyframeAnimationPopUp] forKey:@"popup"];
 @endcode
 */
+ (CAKeyframeAnimation *)keyframeAnimationPopUp;
@end
