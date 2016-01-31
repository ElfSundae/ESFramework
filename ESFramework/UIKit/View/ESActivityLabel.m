//
//  ESActivityLabel.m
//  ESFramework
//
//  Created by Elf Sundae on 5/20/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESActivityLabel.h"
#import <ESFramework/ESDefines.h>
#import <ESFramework/UIView+ESShortcut.h>

@implementation ESActivityLabel

- (instancetype)initWithFrame:(CGRect)frame activityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle attributedText:(NSAttributedString *)attributedText
{
        self = [super initWithFrame:frame];
        if (self) {
                _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:activityIndicatorViewStyle];
                [_activityIndicatorView startAnimating];
                [self addSubview:_activityIndicatorView];
                
                _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
                _textLabel.backgroundColor = [UIColor clearColor];
                _textLabel.attributedText = attributedText;
                [self addSubview:_textLabel];
                
                self.backgroundColor = [UIColor clearColor];
        }
        return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
        return [self initWithFrame:frame
        activityIndicatorViewStyle:UIActivityIndicatorViewStyleGray
                    attributedText:[[NSAttributedString alloc] initWithString:@"" attributes:[[self class] defaultTextAttributes]]];
}

- (CGSize)sizeThatFits:(CGSize)size
{
        CGSize textSize = self.textLabel.attributedText.size;
        CGFloat height = textSize.height + 6.f;
        return CGSizeMake(size.width, height);
}

- (void)layoutSubviews
{
        [super layoutSubviews];
        CGFloat spacing = 6.f;
        
        CGSize textSize = self.textLabel.attributedText.size;
        textSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
        CGSize indicatorSize = self.activityIndicatorView.size;
        
        CGRect contentFrame = CGRectZero;
        contentFrame.size.width = indicatorSize.width + spacing + textSize.width;
        contentFrame.size.height = textSize.height;
        contentFrame.origin.y = (textSize.height < self.height ? floorf((self.height - textSize.height)/2.f) : 0.f);
        contentFrame.origin.x = floorf((self.width - contentFrame.size.width)/2.f);
        
        self.activityIndicatorView.top = floorf((self.size.height - self.activityIndicatorView.size.height) / 2.f);
        self.activityIndicatorView.left = contentFrame.origin.x;
        
        self.textLabel.size = textSize;
        self.textLabel.left = self.activityIndicatorView.right + spacing;
        self.textLabel.top = contentFrame.origin.y;
}

+ (NSDictionary *)defaultTextAttributes
{
        NSMutableParagraphStyle *paragraphStyle = [NSParagraphStyle defaultParagraphStyle].mutableCopy;
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        
        return @{ NSForegroundColorAttributeName : UIColorWithRGB(99.f, 109.f, 125.f),
                  NSFontAttributeName: [UIFont systemFontOfSize:17.f],
                  NSParagraphStyleAttributeName: paragraphStyle};
}

@end
