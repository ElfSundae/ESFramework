//
//  ESErrorView.m
//  ESFramework
//
//  Created by Elf Sundae on 5/16/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESErrorView.h"
#import "ESDefines.h"
#import "UIView+ESShortcut.h"

static const CGFloat kVPadding1 = 30.0;
static const CGFloat kVPadding2 = 10.0;
static const CGFloat kVPadding3 = 15.0;
static const CGFloat kHPadding  = 10.0;


@implementation ESErrorView

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
        if (self) {
                self.imageView = [[UIImageView alloc] init];
                self.imageView.contentMode = UIViewContentModeCenter;
                self.imageView.backgroundColor = [UIColor clearColor];
                [self addSubview:self.imageView];
                
                self.titleLabel = [[UILabel alloc] init];
                self.titleLabel.backgroundColor = [UIColor clearColor];
                self.titleLabel.textColor = UIColorWithRGB(96., 103., 111.);
                self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
                self.titleLabel.textAlignment = NSTextAlignmentCenter;
                [self addSubview:self.titleLabel];
                
                self.subtitleLabel = [[UILabel alloc] init];
                self.subtitleLabel.backgroundColor = [UIColor clearColor];
                self.subtitleLabel.textColor = UIColorWithRGB(96., 103., 111.);
                self.subtitleLabel.font = [UIFont boldSystemFontOfSize:14];
                self.subtitleLabel.textAlignment = NSTextAlignmentCenter;
                self.subtitleLabel.numberOfLines = 0;
                [self addSubview:self.subtitleLabel];
                
                self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
                self.backgroundColor = UIColorWithRGBHex(0xfafafa);
        }
        
        return self;
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title subtitle:(NSString *)subtitle image:(UIImage *)image
{
        self = [self initWithFrame:frame];
        if (self) {
                self.title = title;
                self.subtitle = subtitle;
                self.image = image;
        }
        return self;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Properties
- (NSString *)title
{
        return self.titleLabel.text;
}

- (void)setTitle:(NSString *)title
{
        self.titleLabel.text = title;
        [self setNeedsLayout];
}

- (NSString *)subtitle
{
        return self.subtitleLabel.text;
}

- (void)setSubtitle:(NSString *)subtitle
{
        self.subtitleLabel.text = subtitle;
        [self setNeedsLayout];
}

- (UIImage *)image
{
        return self.imageView.image;
}

- (void)setImage:(UIImage *)image
{
        self.imageView.image = image;
        [self.imageView setNeedsLayout];
        [self setNeedsLayout];
}

- (void)setActionButton:(UIButton *)actionButton
{
        if (_actionButton) {
                [_actionButton removeFromSuperview];
        }
        _actionButton = actionButton;
        [self addSubview:_actionButton];
        
        [self setNeedsLayout];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Layout

- (void)layoutSubviews
{
        CGRect subtitleRect = self.subtitleLabel.frame;
        subtitleRect.size = [self.subtitleLabel sizeThatFits:CGSizeMake(self.frame.size.width - kHPadding*2, 0.0)];
        self.subtitleLabel.frame = subtitleRect;
        
        [self.titleLabel sizeToFit];
        [self.imageView sizeToFit];
        
        
        CGFloat maxHeight = self.imageView.frame.size.height + self.titleLabel.frame.size.height + self.subtitleLabel.frame.size.height + kVPadding1 + kVPadding2;
        BOOL canShowImage = (self.imageView.frame.size.height > 0.) && (self.frame.size.height > maxHeight);
        
        CGFloat totalHeight = 0.0;
        
        if (canShowImage) {
                totalHeight += self.imageView.frame.size.height;
        }
        if (self.titleLabel.text.length) {
                totalHeight += (totalHeight > 0. ? kVPadding1 : 0.) + self.titleLabel.frame.size.height;
        }
        if (self.subtitleLabel.text.length) {
                totalHeight += (totalHeight > 0. ? kVPadding2 : 0.) + self.subtitleLabel.frame.size.height;
        }
        
        if (self.actionButton) {
                totalHeight += (totalHeight > 0. ? kVPadding3 : 0.) + self.actionButton.frame.size.height;
        }
        
        CGFloat top = floorf((self.frame.size.height - totalHeight) / 2.);
        
        if (canShowImage) {
                self.imageView.top = top;
                self.imageView.left = floorf((self.size.width - self.imageView.size.width) / 2.);
                self.imageView.hidden = NO;
                
                top += self.imageView.height + kVPadding1;
        } else {
                self.imageView.hidden = YES;
        }
        
        if (self.titleLabel.text.length) {
                self.titleLabel.left = floorf((self.size.width - self.titleLabel.size.width) / 2.);
                self.titleLabel.top = top;
                top += self.titleLabel.height + kVPadding2;
        }
        
        if (self.subtitleLabel.text.length) {
                self.subtitleLabel.left = floorf((self.size.width - self.subtitleLabel.size.width) / 2.);
                self.subtitleLabel.top = top;
                top += self.subtitleLabel.height + kVPadding3;
        }
        
        if (self.actionButton) {
                self.actionButton.left = floorf((self.size.width - self.actionButton.size.width) / 2.);
                self.actionButton.top = top;
        }
        
}

@end
