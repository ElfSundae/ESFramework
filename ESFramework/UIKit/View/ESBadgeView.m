//
//  ESBadgeView.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-15.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESBadgeView.h"
#import "ESDefines.h"
#import <QuartzCore/QuartzCore.h>

@implementation ESBadgeView

- (id)initWithFrame:(CGRect)frame
{
        self = [super initWithFrame:frame];
        if (self) {
                [self configureDefaults];
        }
        return self;
}

+ (instancetype)badgeViewWithText:(NSString *)text
{
        ESBadgeView *badge = [[self alloc] initWithFrame:CGRectZero];
        badge.text = text;
        [badge sizeToFit];
        return badge;
}

+ (instancetype)redDotWithSize:(CGFloat)size
{
        ESBadgeView *badge = [[self alloc] initWithFrame:CGRectZero];
        badge.frameWidth = 0.;
        badge.showsShadow = NO;
        badge.shadowOffset = CGSizeZero;
        badge.minimumSize = CGSizeMake(size, size);
        badge.contentEdgeInsets = UIEdgeInsetsZero;
        badge.cornerRoundness = badge.minimumSize.width;
        badge.isFlatStyle = YES;
        [badge sizeToFit];
        return badge;
}

- (void)configureDefaults
{
        self.contentScaleFactor = [UIScreen mainScreen].scale;
        self.backgroundColor = [UIColor clearColor];
        self.textColor = [UIColor whiteColor];
        self.font = [UIFont boldSystemFontOfSize:14.];
        self.color = [UIColor colorWithRed:1. green:0 blue:0.09 alpha:1.0];
        self.frameWidth = 1.;
        self.frameColor = [UIColor whiteColor];
        self.isShining = YES;
        self.cornerRoundness = 9.;
        self.showsShadow = YES;
        self.shadowColor = [UIColor colorWithWhite:0 alpha:.7];
        self.shadowOffset = CGSizeMake(1., 1.);
        self.shadowBlur = 3.;
        _applyFlatStyleAutomatically = YES;
        self.contentEdgeInsets = UIEdgeInsetsMake(2, 7, 2, 7);
}

- (CGSize)_getTextSize
{
        CGSize stringSize = [self.text sizeWithAttributes:@{NSFontAttributeName: self.font}];
        stringSize.width = ceilf(stringSize.width);
        stringSize.height = ceilf(stringSize.height);
        return stringSize;
}

- (void)setText:(NSString *)text
{
        if ([text isKindOfClass:[NSNumber class]]) {
                _text = [(NSNumber *)text stringValue];
        } else {
                _text = text;
        }
        if ([self respondsToSelector:@selector(invalidateIntrinsicContentSize)]) {
                [self invalidateIntrinsicContentSize];
        }
        [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font
{
        _font = font;
        self.minimumSize = CGSizeMake(font.lineHeight, font.lineHeight);
        if ([self respondsToSelector:@selector(invalidateIntrinsicContentSize)]) {
                [self invalidateIntrinsicContentSize];
        }
        [self setNeedsDisplay];
}

- (void)setTextColor:(UIColor *)textColor
{
        _textColor = textColor;
        [self setNeedsDisplay];
}

- (void)setColor:(UIColor *)color
{
        _color = color;
        [self setNeedsDisplay];
}

- (void)setIsFlatStyle:(BOOL)isFlatStyle
{
        if (_isFlatStyle != isFlatStyle) {
                _isFlatStyle = isFlatStyle;
                [self setNeedsDisplay];
        }
}

- (void)setApplyFlatStyleAutomatically:(BOOL)automatic
{
        if (_applyFlatStyleAutomatically != automatic) {
                _applyFlatStyleAutomatically = automatic;
                [self setNeedsDisplay];
        }
}

- (CGSize)sizeThatFits:(CGSize)size
{
//        if (self.text.length < 2) {
//                return self.minimumSize;
//        }
        
        CGSize result;
        CGSize stringSize = [self _getTextSize];
        
        result.width = (stringSize.width + self.frameWidth + self.contentEdgeInsets.left + self.contentEdgeInsets.right);
        result.height = (stringSize.height + self.frameWidth + self.contentEdgeInsets.top + self.contentEdgeInsets.bottom);
        
        result.width = fmax(result.width, self.minimumSize.width);
        result.height = fmax(result.height, self.minimumSize.height);
        
        return result;
}

- (CGSize)intrinsicContentSize
{
        return [self sizeThatFits:self.bounds.size];
}

// Draws the Badge with Quartz
- (void)drawRoundedRectWithContext:(CGContextRef)context withRect:(CGRect)rect
{
	CGContextSaveGState(context);
	
	CGFloat radius = CGRectGetMaxY(rect)*self.cornerRoundness;
	CGFloat puffer = CGRectGetMaxY(rect)*0.10;
	CGFloat maxX = CGRectGetMaxX(rect) - puffer;
	CGFloat maxY = CGRectGetMaxY(rect) - puffer;
	CGFloat minX = CGRectGetMinX(rect) + puffer;
	CGFloat minY = CGRectGetMinY(rect) + puffer;
        
        CGContextBeginPath(context);
	CGContextSetFillColorWithColor(context, [self.color CGColor]);
	CGContextAddArc(context, maxX-radius, minY+radius, radius, M_PI+(M_PI/2), 0, 0);
	CGContextAddArc(context, maxX-radius, maxY-radius, radius, 0, M_PI/2, 0);
	CGContextAddArc(context, minX+radius, maxY-radius, radius, M_PI/2, M_PI, 0);
	CGContextAddArc(context, minX+radius, minY+radius, radius, M_PI, M_PI+M_PI/2, 0);
        if (self.showsShadow) {
         	CGContextSetShadowWithColor(context, self.shadowOffset, self.shadowBlur, self.shadowColor.CGColor);
        }
        CGContextFillPath(context);
        
	CGContextRestoreGState(context);
        
}

// Draws the Badge Shine with Quartz
- (void)drawShineWithContext:(CGContextRef)context withRect:(CGRect)rect
{
	CGContextSaveGState(context);
        
	CGFloat radius = CGRectGetMaxY(rect)*self.cornerRoundness;
	CGFloat puffer = CGRectGetMaxY(rect)*0.10;
	CGFloat maxX = CGRectGetMaxX(rect) - puffer;
	CGFloat maxY = CGRectGetMaxY(rect) - puffer;
	CGFloat minX = CGRectGetMinX(rect) + puffer;
	CGFloat minY = CGRectGetMinY(rect) + puffer;
	CGContextBeginPath(context);
	CGContextAddArc(context, maxX-radius, minY+radius, radius, M_PI+(M_PI/2), 0, 0);
	CGContextAddArc(context, maxX-radius, maxY-radius, radius, 0, M_PI/2, 0);
	CGContextAddArc(context, minX+radius, maxY-radius, radius, M_PI/2, M_PI, 0);
	CGContextAddArc(context, minX+radius, minY+radius, radius, M_PI, M_PI+M_PI/2, 0);
	CGContextClip(context);
	
	
	size_t num_locations = 2;
	CGFloat locations[2] = { 0.0, 0.4 };
	CGFloat components[8] = {  0.92, 0.92, 0.92, 1.0, 0.82, 0.82, 0.82, 0.2 };
        
	CGColorSpaceRef cspace;
	CGGradientRef gradient;
	cspace = CGColorSpaceCreateDeviceRGB();
	gradient = CGGradientCreateWithColorComponents (cspace, components, locations, num_locations);
	
	CGPoint sPoint, ePoint;
	sPoint.x = 0;
	sPoint.y = 0;
	ePoint.x = 0;
	ePoint.y = maxY;
	CGContextDrawLinearGradient (context, gradient, sPoint, ePoint, 0);
	
	CGColorSpaceRelease(cspace);
	CGGradientRelease(gradient);
	
	CGContextRestoreGState(context);
}


// Draws the Badge Frame with Quartz
- (void)drawFrameWithContext:(CGContextRef)context withRect:(CGRect)rect
{
	CGFloat radius = CGRectGetMaxY(rect)*self.cornerRoundness;
	CGFloat puffer = CGRectGetMaxY(rect)*0.10;
	
	CGFloat maxX = CGRectGetMaxX(rect) - puffer;
	CGFloat maxY = CGRectGetMaxY(rect) - puffer;
	CGFloat minX = CGRectGetMinX(rect) + puffer;
	CGFloat minY = CGRectGetMinY(rect) + puffer;
	
	
        CGContextBeginPath(context);
	CGFloat lineSize = self.frameWidth;
//	if(self.scale>1) {
//		lineSize += self.scale*0.25;
//	}
	CGContextSetLineWidth(context, lineSize);
	CGContextSetStrokeColorWithColor(context, [self.frameColor CGColor]);
	CGContextAddArc(context, maxX-radius, minY+radius, radius, M_PI+(M_PI/2), 0, 0);
	CGContextAddArc(context, maxX-radius, maxY-radius, radius, 0, M_PI/2, 0);
	CGContextAddArc(context, minX+radius, maxY-radius, radius, M_PI/2, M_PI, 0);
	CGContextAddArc(context, minX+radius, minY+radius, radius, M_PI, M_PI+M_PI/2, 0);
	CGContextClosePath(context);
	CGContextStrokePath(context);
}

- (void)drawFlatStyleWithContext:(CGContextRef)context withRect:(CGRect)rect
{
#if 0
        CGContextSaveGState(context);
	
	CGFloat radius = CGRectGetMaxY(rect)*self.cornerRoundness;
	CGFloat puffer = CGRectGetMaxY(rect)*0.10;
	CGFloat maxX = CGRectGetMaxX(rect) - puffer;
	CGFloat maxY = CGRectGetMaxY(rect) - puffer;
	CGFloat minX = CGRectGetMinX(rect) + puffer;
	CGFloat minY = CGRectGetMinY(rect) + puffer;
        
        CGContextBeginPath(context);
	CGContextSetFillColorWithColor(context, [self.color CGColor]);
	CGContextAddArc(context, maxX-radius, minY+radius, radius, M_PI+(M_PI/2), 0, 0);
	CGContextAddArc(context, maxX-radius, maxY-radius, radius, 0, M_PI/2, 0);
	CGContextAddArc(context, minX+radius, maxY-radius, radius, M_PI/2, M_PI, 0);
	CGContextAddArc(context, minX+radius, minY+radius, radius, M_PI, M_PI+M_PI/2, 0);
//        if (self.showsShadow) {
//         	CGContextSetShadowWithColor(context, self.shadowOffset, self.shadowBlur, self.shadowColor.CGColor);
//        }
        CGContextFillPath(context);
        
	CGContextRestoreGState(context);
#else
        CGContextSaveGState(context);
        CGContextSetFillColorWithColor(context, self.color.CGColor);
        CGContextFillRect(context, rect);
        CGContextRestoreGState(context);
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = self.bounds;
        maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.cornerRoundness].CGPath;
        self.layer.mask = maskLayer;
#endif
}


- (void)drawRect:(CGRect)rect
{
        CGContextRef context = UIGraphicsGetCurrentContext();
        if (self.isFlatStyle || (self.applyFlatStyleAutomatically && ESOSVersionIsAbove7())) {
                [self drawFlatStyleWithContext:context withRect:rect];
        } else {
                self.cornerRoundness = 0.4;
                [self drawRoundedRectWithContext:context withRect:rect];
                if (self.isShining) {
                        [self drawShineWithContext:context withRect:rect];
                }
                if (self.frameWidth > 0.) {
                        [self drawFrameWithContext:context withRect:rect];
                }
        }
        
        if (self.text.length > 0) {
                CGSize textSize = [self _getTextSize];
                CGPoint textPoint;
                textPoint.x = (rect.size.width - textSize.width) / 2.;
                textPoint.y = (rect.size.height - textSize.height) / 2.;
                [self.text drawAtPoint:textPoint withAttributes:@{NSFontAttributeName: self.font,
                                                                  NSForegroundColorAttributeName: self.textColor}];
        }
}

@end
