//
//  ESStatusOverlayView.h
//  ESFramework
//
//  Created by Elf Sundae on 5/20/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESActivityLabel.h"
#import "ESErrorView.h"
#import "ESButton.h"

/**
 * `ESStatusOverlayView` is a view which overlay on a view, such as viewController's view,
 * UITableView, UIScrollView or UIWebView, to show some information about status.
 * 
 * e.g. 
 *
 * * shows loading status while loading data.
 * * shows network error while HTTP request failed.
 * * shows "No friends" when the "Contact" have no data.
 *
 */
@interface ESStatusOverlayView : UIView
{
        ESActivityLabel *_activityLabel;
        ESErrorView *_errorView;
}

/**
 * Overlay `ESStatusOverlayView` on this `view`.
 */
@property (nonatomic, weak) __weak UIView *view;
@property (nonatomic, strong, readonly) ESActivityLabel *activityLabel;
@property (nonatomic, strong, readonly) ESErrorView *errorView;

- (instancetype)initWithView:(UIView *)view;

- (void)showActivityWithText:(NSString *)text;
- (void)showActivity;
- (void)showErrorViewWithImage:(UIImage *)image title:(NSString *)title subtitle:(NSString *)subtitle actionButton:(UIButton *)actionButton;
- (void)showErrorView;

- (void)hideAnimated:(BOOL)animated;

@end



