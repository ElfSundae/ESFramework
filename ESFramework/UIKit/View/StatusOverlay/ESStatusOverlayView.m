//
//  ESStatusOverlayView.m
//  ESFramework
//
//  Created by Elf Sundae on 5/20/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESStatusOverlayView.h"
#import <ESFramework/UIView+ESShortcut.h>

@interface ESStatusOverlayView()
@property (nonatomic, strong, readwrite) ESActivityLabel *activityLabel;
@property (nonatomic, strong, readwrite) ESErrorView *errorView;
@end

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
                _activityLabel = [[ESActivityLabel alloc] initWithStyle:ESActivityLabelStyleGray];
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
        self.hidden = NO;
        self.alpha = 1.f;
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public Methods

- (void)showActivityWithText:(NSString *)text
{
        self.activityLabel.text = text;
        [self showActivity];
}

- (void)showActivity
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
        [UIView animateWithDuration:(animated ? 0.3 : 0.0)
                         animations:^{
                                 self.alpha = 0.f;
                         } completion:^(BOOL finished) {
                                 [self removeFromSuperview];
                         }];
}

@end
