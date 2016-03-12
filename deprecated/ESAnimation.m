//
//  ESAnimation.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-7.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESAnimation.h"

@implementation ESAnimation

+ (CAKeyframeAnimation *)popup:(NSTimeInterval)duration
{
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(.5f, .5f, 1.f)],
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2f, 1.2f, 1.f)],
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.f, 1.f, 1.f)]];
        animation.keyTimes = @[@(0.0), @(0.5), @(1.0)];
        animation.duration = duration;
        return animation;
}

+ (CATransition *)fade:(NSTimeInterval)duration
{
        CATransition *animation = [CATransition animation];
        animation.type = kCATransitionFade;
        animation.duration = duration;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        return animation;
}

+ (CATransition *)_pushFrom:(NSString *)from duration:(NSTimeInterval)duration
{
        CATransition *transition = [CATransition animation];
        transition.duration = duration;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = from;
        [transition setValue:(id)kCFBooleanFalse forKey:kCATransitionFade];
        return transition;
}

+ (CATransition *)pushFromTop:(NSTimeInterval)duration
{
        return [self _pushFrom:kCATransitionFromBottom duration:duration];
}

+ (CATransition *)pushFromLeft:(NSTimeInterval)duration
{
        return [self _pushFrom:kCATransitionFromRight duration:duration];
}

+ (CATransition *)pushFromBottom:(NSTimeInterval)duration
{
        return [self _pushFrom:kCATransitionFromTop duration:duration];
}

+ (CATransition *)pushFromRight:(NSTimeInterval)duration
{
        return [self _pushFrom:kCATransitionFromLeft duration:duration];
}

@end
