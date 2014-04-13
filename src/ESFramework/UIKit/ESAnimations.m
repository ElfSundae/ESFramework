//
//  ESAnimations.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-7.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import "ESAnimations.h"

@implementation ESAnimations

+ (CAKeyframeAnimation *)keyframeAnimationPopUp
{
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        animation.values =
        @[
          [NSValue valueWithCATransform3D:CATransform3DMakeScale(.5f, .5f, 1.f)],
          [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2f, 1.2f, 1.f)],
          [NSValue valueWithCATransform3D:CATransform3DMakeScale(.9f, .9f, 1.f)],
          [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.f, 1.f, 1.f)],
          ];
        animation.keyTimes = @[@(0.f), @(0.5f), @(0.9f), @(1.f)];
        animation.duration = .3f;
        return animation;
}

@end
