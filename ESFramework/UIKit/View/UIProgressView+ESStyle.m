//
//  UIProgressView+ESStyle.m
//  ESFramework
//
//  Created by Elf Sundae on 4/30/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "UIProgressView+ESStyle.h"
#import "ESDefines.h"
#import "ESValue.h"
#import "UIImage+ESAdditions.h"

static const void *_esProgressViewResizableKey = &_esProgressViewResizableKey;

@interface UIProgressView (_ESStyleInternal)
@property (nonatomic) CGFloat _esResizableHeight;
@end

@implementation UIProgressView (_ESStyleInternal)

- (CGFloat)_esResizableHeight
{
        float ret = 0;
        ESFloatVal(&ret, ESGetAssociatedObject(self, _esProgressViewResizableKey));
        return (CGFloat)ret;
}

- (void)set_esResizableHeight:(CGFloat)_esResizableHeight
{
        ESSetAssociatedObject(self, _esProgressViewResizableKey, @(_esResizableHeight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation UIProgressView (ESStyle)

+ (void)load
{
        @autoreleasepool {
                ESSwizzleInstanceMethod([self class], @selector(sizeThatFits:), @selector(sizeThatFits_ESStyle:));
        }
}

+ (instancetype)flatProgressViewWithTrackColor:(UIColor *)trackColor progressColor:(UIColor *)progressColor
{
        UIProgressView *p = [[self alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        if (ESOSVersionIsAbove7()) {
                p.trackTintColor = trackColor;
                p.progressTintColor = progressColor;
        } else {
                p.trackImage = [UIImage imageWithColor:trackColor cornerRadius:4.];
                p.progressImage = [UIImage imageWithColor:progressColor cornerRadius:4.];
        }
        return p;
}

+ (instancetype)flatProgressView
{
        if (ESOSVersionIsAbove7()) {
                return [[self alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        } else {
                return [self flatProgressViewWithTrackColor:UIColorWithRGBHex(0xb6b6b6) progressColor:UIColorWithRGBHex(0x1374ff)];
        }
}

- (CGSize)sizeThatFits_ESStyle:(CGSize)size
{
        if (0 == self._esResizableHeight) {
                return [self sizeThatFits_ESStyle:size];
        } else {
                return CGSizeMake(size.width, self._esResizableHeight);
        }
}

- (void)resizedHeight:(CGFloat)newHeight
{
        self._esResizableHeight = newHeight;
        [self sizeToFit];
}
@end
