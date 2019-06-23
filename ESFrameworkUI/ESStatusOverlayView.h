//
//  ESStatusOverlayView.h
//  ESFramework
//
//  Created by Elf Sundae on 2014/05/20.
//  Copyright © 2014 https://0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESActivityLabel.h"
#import "ESErrorView.h"

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

- (void)showActivityLabelWithText:(NSString *)text;
- (void)showActivityLabel;
- (void)showErrorViewWithImage:(UIImage *)image title:(NSString *)title subtitle:(NSString *)subtitle actionButton:(UIButton *)actionButton;
- (void)showErrorView;

- (void)hideAnimated:(BOOL)animated;

@end

@interface UIViewController (ESStatusOverlayView)

@property (nonatomic, strong) ESStatusOverlayView *statusOverlayView;

@end
