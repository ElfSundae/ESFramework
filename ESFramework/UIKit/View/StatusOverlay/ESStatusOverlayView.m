//
//  ESStatusOverlayView.m
//  ESFramework
//
//  Created by Elf Sundae on 5/20/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESStatusOverlayView.h"
#import <ESFramework/UIView+ESShortcut.h>

@implementation ESStatusOverlayView

- (void)dealloc
{
        self.view = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
        return [self initWithView:nil];
}

- (instancetype)initWithView:(UIView *)view
{
        self = [super initWithFrame:CGRectZero];
        if (self) {
                self.autoresizesSubviews = YES;
                self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
                if (view) {
                        _view = view;
                        self.frame = CGRectMake(0, 0, _view.width, _view.height);
                        self.backgroundColor = _view.backgroundColor;
                }
                self.alpha = 0.f;
        }
        return self;
}

- (ESActivityLabel *)activityLabel
{
        if (nil == _activityLabel) {
                _activityLabel = [[ESActivityLabel alloc] initWithFrame:self.bounds];
                [self addSubview:_activityLabel];
        }
        return _activityLabel;
}

- (ESErrorView *)errorView
{
        if (nil == _errorView) {
                _errorView = [[ESErrorView alloc] initWithFrame:self.bounds];
                [self addSubview:_errorView];
        }
        return _errorView;
}

- (void)show
{
        if (!self.view) {
                [self removeFromSuperview];
                return;
        }
        
        if (self.superview) {
                [self.superview bringSubviewToFront:self];
        } else {
                [self.view addSubview:self];
        }
        self.alpha = 1.f;
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public Methods

- (void)showActivityLabelWithText:(NSString *)text
{
        NSAttributedString *string = nil;
        if (text) {
                if (self.activityLabel.textLabel.attributedText) {
                        NSMutableAttributedString *mutableString = self.activityLabel.textLabel.attributedText.mutableCopy;
                        [mutableString replaceCharactersInRange:NSMakeRange(0, mutableString.length) withString:text];
                        string = (NSAttributedString *)mutableString;
                } else {
                        string = [[NSAttributedString alloc] initWithString:text attributes:[[self.activityLabel class] defaultTextAttributes]];
                }
        }
        self.activityLabel.textLabel.attributedText = string;
        [self showActivityLabel];
}

- (void)showActivityLabel
{
        self.activityLabel.frame = self.bounds;
        if (_errorView) {
                _errorView.hidden = YES;
        }
        self.activityLabel.hidden = NO;
        [self show];
}

- (void)showErrorViewWithImage:(UIImage *)image title:(NSString *)title subtitle:(NSString *)subtitle actionButton:(UIButton *)actionButton
{
        self.errorView.image = image;
        self.errorView.title = title;
        self.errorView.subtitle = subtitle;
        self.errorView.actionButton = actionButton;
        [self showErrorView];
}

- (void)showErrorView
{
        self.errorView.frame = self.bounds;
        if (_activityLabel) {
                _activityLabel.hidden = YES;
        }
        self.errorView.hidden = NO;
        [self show];
}

- (void)hideAnimated:(BOOL)animated;
{
        if (!self.isHidden) {
                [UIView animateWithDuration:(animated ? 0.25 : 0.0)
                                 animations:^{
                                         self.alpha = 0.f;
                                 } completion:^(BOOL finished) {
                                         [self removeFromSuperview];
                                 }];
        }
}

@end
