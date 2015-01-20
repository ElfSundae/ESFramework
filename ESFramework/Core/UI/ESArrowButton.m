//
//  ESArrowButton.m
//  ESFramework
//
//  Created by Elf Sundae on 4/29/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESArrowButton.h"
#import "ESDefines.h"

@implementation ESArrowButton

+ (instancetype)button
{
        ESArrowButton *button = [[self alloc] init];
        button.frame = CGRectMake(0.f, 0.f, 14.f, 22.f);
        button.edgeInsets = UIEdgeInsetsZero;
        button.lineWidth = 3.f;
        return button;
}

- (void)setFrame:(CGRect)frame
{
        [super setFrame:frame];
        [self setNeedsDisplay];
}

- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets
{
        _edgeInsets = edgeInsets;
        [self setNeedsDisplay];
}
- (void)setArrowStyle:(ESArrowButtonStyle)arrowStyle
{
        _arrowStyle = arrowStyle;
        [self setNeedsDisplay];
}
- (void)setLineWidth:(CGFloat)lineWidth
{
        _lineWidth = lineWidth;
        [self setNeedsDisplay];
}

- (void)setTintColor:(UIColor *)tintColor
{
        [super setTintColor:tintColor];
        [self setNeedsDisplay];
}
- (UIColor *)tintColor
{
        UIColor *c = [super tintColor];
        if (!c) {
                return UIColorWithRGBHex(0x007aff);
        }
        return c;
}

- (void)tintColorDidChange
{
        [super tintColorDidChange];
        [self setNeedsDisplay];
}

- (void)setHighlighted:(BOOL)highlighted
{
        [super setHighlighted:highlighted];
        [self setNeedsDisplay];
}

- (void)setEnabled:(BOOL)enabled
{
        [super setEnabled:enabled];
        [self setNeedsDisplay];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
        return CGRectContainsPoint(CGRectInset(self.bounds, -3, -3 ), point );
}

- (void)drawRect:(CGRect)rect
{
        UIBezierPath *path = [UIBezierPath bezierPath];
        path.lineWidth = self.lineWidth;
        CGSize size = rect.size;
        CGFloat halfLineWidth = floorf(self.lineWidth / 2.f);
        if (ESArrowButtonStyleLeft == _arrowStyle) {
                CGPoint start = CGPointMake(size.width - halfLineWidth - self.edgeInsets.right, halfLineWidth + self.edgeInsets.top);
                CGPoint center = CGPointMake(self.edgeInsets.left + halfLineWidth, floorf(size.height / 2.f));
                CGPoint end = CGPointMake(start.x, size.height - halfLineWidth - self.edgeInsets.bottom);
                [path moveToPoint:start];
                [path addLineToPoint:center];
                [path addLineToPoint:end];
        } else {
                CGPoint start = CGPointMake(self.edgeInsets.left + halfLineWidth, halfLineWidth + self.edgeInsets.top);
                CGPoint center = CGPointMake(size.width - halfLineWidth - self.edgeInsets.right, floorf(size.height / 2.f));
                CGPoint end = CGPointMake(start.x, size.height - halfLineWidth - self.edgeInsets.bottom);
                [path moveToPoint:start];
                [path addLineToPoint:center];
                [path addLineToPoint:end];
        }
        
        UIColor *color = self.tintColor;
        if (!self.isEnabled) {
                if (ESOSVersionIsAbove7()) {
                        color = UIColorWithRGBHex(0xc4c4c4);
                } else {
                        color = [color colorWithAlphaComponent:0.3];
                }
        } else if (self.isHighlighted) {
                color = [color colorWithAlphaComponent:0.3];
        }
        [color set];
        [path stroke];
}
@end

