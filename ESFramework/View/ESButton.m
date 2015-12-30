//
//  ESButton.m
//  ESFramework
//
//  Created by Elf Sundae on 4/20/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESButton.h"
#import "ESDefines.h"
#import "UIColor+ESAdditions.h"

#define kDefaultButtonRoundedCornerRadius               @(6.f)
#define kDefaultButtonRoundedCornerRadiusForFlatStyled  @(4.f)

@interface ESButton ()
@property (nonatomic) ESButtonStyle buttonStyle;
@end

@implementation ESButton
@synthesize buttonColor = _buttonColor,
buttonRoundedCornerRadius = _buttonRoundedCornerRadius,
buttonFlatStyled = _buttonFlatStyled;

+ (instancetype)buttonWithStyle:(ESButtonStyle)buttonStyle
{
        ESButton *button = [self buttonWithType:UIButtonTypeCustom];
        [button _applyDefaultsForStyle:buttonStyle];
        return button;
}

- (void)_applyDefaultsForStyle:(ESButtonStyle)buttonStyle
{
        _buttonStyle = buttonStyle;
        // _borderWidth = 1.f;
        UIEdgeInsets padding = UIEdgeInsetsZero;
        if (ESButtonStyleRoundedRect == self.buttonStyle) {
                padding.top = padding.bottom = 0.f;
                padding.left = padding.right = 10.f;
        } else if (ESButtonStyleSemiCircle == self.buttonStyle) {
                padding.top = padding.bottom = 0.f;
                padding.left = padding.right = 15.f;
        } else if (ESButtonStyleCircle == self.buttonStyle) {
                padding.top = padding.bottom = 10.f;
                padding.left = padding.right = 10.f;
        }
        _buttonPadding = padding;
        self.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self _applyDefaultsTitleColorForButtonColor:self.buttonColor];
        [self _applyDefaultsTitleLabelAttributesForFlatStyled:self.buttonFlatStyled.boolValue];
}

- (void)_applyDefaultsTitleColorForButtonColor:(UIColor *)buttonColor
{
        if (buttonColor.es_isLightColor) {
                [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self setTitleShadowColor:[UIColor colorWithWhite:1.f alpha:0.6f] forState:UIControlStateNormal];
                [self setTitleColor:[UIColor colorWithWhite:0.4f alpha:0.7f] forState:UIControlStateDisabled];
        } else {
                [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self setTitleShadowColor:[UIColor colorWithWhite:0.f alpha:0.6f] forState:UIControlStateNormal];
                [self setTitleColor:[UIColor colorWithWhite:1.f alpha:0.7f] forState:UIControlStateDisabled];
        }
}

- (void)_applyDefaultsTitleLabelAttributesForFlatStyled:(BOOL)isFlatStyled
{
        if (isFlatStyled) {
                self.titleLabel.shadowOffset = CGSizeMake(0.f, 0.f);
                self.titleLabel.font = [UIFont systemFontOfSize:[UIFont buttonFontSize]];
        } else {
                self.titleLabel.shadowOffset = CGSizeMake(0.f, -1.f);
                self.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont buttonFontSize]];
        }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Size

- (CGSize)intrinsicContentSize
{
        return [self sizeThatFits:self.bounds.size];
}

- (CGSize)sizeThatFits:(CGSize)size
{
        CGSize result = [super sizeThatFits:size];
        result.height += self.buttonPadding.top + self.buttonPadding.bottom;
        result.width += self.buttonPadding.left + self.buttonPadding.right;
        if (ESButtonStyleCircle == self.buttonStyle) {
                result.width = result.height = fmaxf(result.width, result.height);
        }
        return result;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Getter / Setter

- (UIColor *)buttonColor
{
        if (!_buttonColor) {
                _buttonColor = [[[self class] appearance] buttonColor];
        }
        if (_buttonColor) {
                return _buttonColor;
        }
        
        return [UIColor es_defaultButtonColor];
}

- (void)setButtonColor:(UIColor *)value
{
        _buttonColor = value;
        [self _applyDefaultsTitleColorForButtonColor:_buttonColor];
        [self setNeedsDisplay];
}

- (NSNumber *)buttonRoundedCornerRadius
{
        if (!_buttonRoundedCornerRadius) {
                _buttonRoundedCornerRadius = [[[self class] appearance] buttonRoundedCornerRadius];
        }
        if (_buttonRoundedCornerRadius) {
                return _buttonRoundedCornerRadius;
        }
        return self.buttonFlatStyled.boolValue ? kDefaultButtonRoundedCornerRadiusForFlatStyled : kDefaultButtonRoundedCornerRadius;
}

- (void)setbuttonRoundedCornerRadius:(NSNumber *)value
{
        _buttonRoundedCornerRadius = value;
        [self setNeedsDisplay];
}

- (NSNumber *)buttonFlatStyled
{
        if (!_buttonFlatStyled) {
                _buttonFlatStyled = [[[self class] appearance] buttonFlatStyled];
        }
        if (_buttonFlatStyled) {
                return _buttonFlatStyled;
        }
        if (ESOSVersionIsAbove7()) {
                return @(YES);
        } else {
                return @(NO);
        }
}

- (void)setButtonFlatStyled:(NSNumber *)value
{
        _buttonFlatStyled = value;
        [self _applyDefaultsTitleLabelAttributesForFlatStyled:_buttonFlatStyled.boolValue];
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

- (void)setFrame:(CGRect)frame
{
        [super setFrame:frame];
        [self setNeedsDisplay];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
        [super setTitle:title forState:state];
        // Fixed new title is not updated on iOS7
        [self setNeedsLayout];
}

- (void)setAttributedTitle:(NSAttributedString *)title forState:(UIControlState)state
{
        [super setAttributedTitle:title forState:state];
        // Fixed new title is not updated on iOS7
        [self setNeedsLayout];
}

//- (void)setBorderWidth:(CGFloat)value
//{
//        if (_borderWidth != value) {
//                _borderWidth = value;
//                [self setNeedsDisplay];
//        }
//}
//
//- (void)setBorderColor:(CGFloat)value
//{
//        if (_borderColor != value) {
//                _borderColor = value;
//                [self setNeedsDisplay];
//        }
//}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Draw

- (void)drawRect:(CGRect)rect
{
        [super drawRect:rect];
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        if (!context) {
                return;
        }
        
        CGFloat cornerRadius = 0.f;
        if (ESButtonStyleRoundedRect == self.buttonStyle) {
                cornerRadius = self.buttonRoundedCornerRadius.floatValue;
        } else if (ESButtonStyleSemiCircle == self.buttonStyle ||
                   ESButtonStyleCircle == self.buttonStyle) {
                cornerRadius = self.bounds.size.width / 2.f;
        }
        
        
        if (self.buttonFlatStyled.boolValue) {
                [self _drawRoundedWithFlatStyledInRect:rect context:&context cornerRadius:cornerRadius];
        } else {
                [self _drawRoundedInRect:rect context:&context cornerRadius:cornerRadius];
        }

        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = self.bounds;
        maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:cornerRadius].CGPath;
        self.layer.mask = maskLayer;
//        CAShapeLayer *maskLayer = [CAShapeLayer layer];
//        maskLayer.frame = self.bounds;
//        maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:cornerRadius].CGPath;
//        self.layer.mask = maskLayer;
        
//        CAShapeLayer *maskLayer = [CAShapeLayer layer];
//        maskLayer.frame = self.imageView.bounds;
//        maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.imageView.bounds cornerRadius:cornerRadius].CGPath;
//        self.imageView.layer.mask = maskLayer;

}

- (void)_drawRoundedInRect:(CGRect)rect context:(CGContextRef *)context cornerRadius:(CGFloat)cornerRaius
{
        UIColor *border = [self.buttonColor es_darkenColorWithValue:0.06f];
        
        UIColor *shadow = [self.buttonColor es_lightenColorWithValue:0.50f];
        CGSize shadowOffset = CGSizeMake(0.0f, 1.0f);
        CGFloat shadowBlurRadius = 2.0f;
        
        UIBezierPath *roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0.5f, 0.5f, rect.size.width-1.0f, rect.size.height-1.0f)
                                                                        cornerRadius:cornerRaius];
        
        CGContextSaveGState(*context);
        
        [roundedRectanglePath addClip];
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        UIColor *topColor = (!self.enabled) ? [self.buttonColor es_darkenColorWithValue:0.12f] : [self.buttonColor es_lightenColorWithValue:0.12f];
        
        NSArray *newGradientColors = [NSArray arrayWithObjects:(id)topColor.CGColor, (id)self.buttonColor.CGColor, nil];
        CGFloat newGradientLocations[] = {0.0f, 1.0f};
        
        CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)newGradientColors, newGradientLocations);
        
        CGColorSpaceRelease(colorSpace);
        
        CGContextDrawLinearGradient(*context,
                                    gradient,
                                    CGPointMake(0.0f, self.highlighted ? rect.size.height - 0.5f : 0.5f),
                                    CGPointMake(0.0f, self.highlighted ? 0.5f : rect.size.height - 0.5f), 0.0f);
        
        CGGradientRelease(gradient);
        
        CGContextRestoreGState(*context);
        
        if (!self.highlighted) {
                // Rounded Rectangle Inner Shadow
                CGRect roundedRectangleBorderRect = CGRectInset([roundedRectanglePath bounds], -shadowBlurRadius, -shadowBlurRadius);
                roundedRectangleBorderRect = CGRectOffset(roundedRectangleBorderRect, -shadowOffset.width, -shadowOffset.height);
                roundedRectangleBorderRect = CGRectInset(CGRectUnion(roundedRectangleBorderRect, [roundedRectanglePath bounds]), -1.0f, -1.0f);
                
                UIBezierPath *roundedRectangleNegativePath = [UIBezierPath bezierPathWithRect: roundedRectangleBorderRect];
                [roundedRectangleNegativePath appendPath: roundedRectanglePath];
                roundedRectangleNegativePath.usesEvenOddFillRule = YES;
                
                CGContextSaveGState(*context);
                
                CGFloat xOffset = shadowOffset.width + round(roundedRectangleBorderRect.size.width);
                CGFloat yOffset = shadowOffset.height;
                CGContextSetShadowWithColor(*context,
                                            CGSizeMake(xOffset + copysign(0.1f, xOffset), yOffset + copysign(0.1f, yOffset)),
                                            shadowBlurRadius,
                                            shadow.CGColor);
                
                [roundedRectanglePath addClip];
                CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(roundedRectangleBorderRect.size.width), 0.0f);
                [roundedRectangleNegativePath applyTransform: transform];
                [[UIColor grayColor] setFill];
                [roundedRectangleNegativePath fill];
                
                CGContextRestoreGState(*context);
        }
        
        [border setStroke];
        roundedRectanglePath.lineWidth = 1.0f;
        [roundedRectanglePath stroke];
}

- (void)_drawRoundedWithFlatStyledInRect:(CGRect)rect context:(CGContextRef *)context cornerRadius:(CGFloat)cornerRaius
{
        CGContextSaveGState(*context);
        
        UIColor *fill = (!self.highlighted) ? self.buttonColor : [self.buttonColor es_darkenColorWithValue:0.06f];
        if (!self.enabled) {
                fill = [fill es_desaturatedColorToPercentSaturation:0.60f];
        }
        
        CGContextSetFillColorWithColor(*context, fill.CGColor);
        
        UIColor *border = (!self.highlighted) ? [self.buttonColor es_darkenColorWithValue:0.06f] : [self.buttonColor es_darkenColorWithValue:0.12f];
        if (!self.enabled) {
                border = [border es_desaturatedColorToPercentSaturation:0.60f];
        }
        
        CGContextSetStrokeColorWithColor(*context, border.CGColor);
        
        CGContextSetLineWidth(*context, 1.0f);
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0.5f, 0.5f, rect.size.width-1.0f, rect.size.height-1.0f)
                                                        cornerRadius:cornerRaius];
        
        CGContextAddPath(*context, path.CGPath);
        CGContextDrawPath(*context, kCGPathFillStroke);
        
        CGContextRestoreGState(*context);
}

@end
