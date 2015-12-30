//
//  ESActivityLabel.m
//  ESFramework
//
//  Created by Elf Sundae on 5/20/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESActivityLabel.h"
#import "ESDefines.h"
#import "UIView+ESShortcut.h"

@interface ESActivityLabel()
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UILabel *label;
@end

@implementation ESActivityLabel

- (instancetype)initWithFrame:(CGRect)frame style:(ESActivityLabelStyle)style text:(NSString *)text
{
        self = [super initWithFrame:frame];
        if (self) {
                _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
                [_activityIndicatorView startAnimating];
                [self addSubview:_activityIndicatorView];
                
                _label = [[UILabel alloc] initWithFrame:CGRectZero];
                _label.backgroundColor = [UIColor clearColor];
                _label.lineBreakMode = NSLineBreakByTruncatingTail;
                _label.text = text;
                _label.numberOfLines = 1;
                _label.font = [UIFont systemFontOfSize:17.0];
                [self addSubview:_label];
                
                _style = style;
                [self applyStyle];
                self.backgroundColor = [UIColor clearColor];
        }
        return self;
}

- (instancetype)initWithStyle:(ESActivityLabelStyle)style text:(NSString *)text
{
        return [self initWithFrame:CGRectMake(0, 0, 200.f, 21.f) style:style text:text];
}

- (instancetype)initWithStyle:(ESActivityLabelStyle)style
{
        return [self initWithStyle:style text:nil];
}

- (instancetype)initWithFrame:(CGRect)frame
{
        return [self initWithStyle:0];
}

- (void)setStyle:(ESActivityLabelStyle)style
{
        if (_style != style) {
                _style = style;
                [self applyStyle];
        }
}

- (NSString *)text
{
        return self.label.text;
}
- (void)setText:(NSString *)text
{
        self.label.text = text;
        [self setNeedsLayout];
}
- (UIFont *)font
{
        return self.label.font;
}
- (void)setFont:(UIFont *)font
{
        self.label.font = font;
        [self setNeedsLayout];
}
- (UIColor *)textColor
{
        return self.label.textColor;
}
- (void)setTextColor:(UIColor *)textColor
{
        self.label.textColor = textColor;
}

- (UIColor *)indicatorColor
{
        return self.activityIndicatorView.color;
}
- (void)setIndicatorColor:(UIColor *)indicatorColor
{
        self.activityIndicatorView.color = indicatorColor;
}

- (void)applyStyle
{
        if (ESActivityLabelStyleWhite == _style) {
                self.activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
                self.textColor = [UIColor whiteColor];
        } else if (ESActivityLabelStyleGray == _style) {
                self.activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
                self.textColor = UIColorWithRGB(99.f, 109.f, 125.f);
        }
        [self setNeedsLayout];
}

- (CGSize)sizeThatFits:(CGSize)size
{
        CGFloat height = _label.font.lineHeight + 6.f;
        return CGSizeMake(size.width, height);
}

- (void)layoutSubviews
{
        [super layoutSubviews];
        CGFloat spacing = 6.f;
        
        CGSize textSize = [_label.text sizeWithAttributes:@{NSFontAttributeName: _label.font}];
        textSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
        [_activityIndicatorView sizeToFit];
        CGFloat indicatorSize = MIN(_activityIndicatorView.height, textSize.height);
        
        CGRect contentFrame = CGRectZero;
        contentFrame.size.width = indicatorSize + spacing + textSize.width;
        contentFrame.size.height = textSize.height;
        contentFrame.origin.y = (textSize.height < self.height ? floorf((self.height - textSize.height)/2.f) : 0.f);
        contentFrame.origin.x = floorf((self.width - contentFrame.size.width)/2.f);
        
        // TODO: 设置indicatorSize没效果 http://stackoverflow.com/questions/2638120/can-i-change-the-size-of-uiactivityindicator
        _activityIndicatorView.size = CGSizeMake(indicatorSize, indicatorSize);
        //_activityIndicatorView.top = ESSizeCenterY(self.size, _activityIndicatorView.size);
        _activityIndicatorView.top = floorf((self.size.height - _activityIndicatorView.size.height) / 2.f);
        _activityIndicatorView.left = contentFrame.origin.x;
        
        _label.size = textSize;
        _label.left = _activityIndicatorView.right + spacing;
        _label.top = contentFrame.origin.y;
}

@end
