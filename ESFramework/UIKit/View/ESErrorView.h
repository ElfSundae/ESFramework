//
//  ESErrorView.h
//  ESFramework
//
//  Created by Elf Sundae on 5/16/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * `ESErrorView` could be used for a view which has no data to show.
 * For example, showing a `ESErrorView` when the tableView has no data, or when
 * the network is not reachable, just like App Store does.
 *
 * Example:
 *
 * 	ESWeak(self, weakSelf);
 * 	ESErrorView *errorView = [[ESErrorView alloc] initWithFrame:self.view.bounds
 * 	                                                      title:@"Network Error"
 * 	                                                   subtitle:@"Please check the Internet connection."
 * 	                                                      image:UIImageFrom(@"network_error")];
 * 	errorView.actionButton = [errorView buttonWithTitle:_(@"Refresh")];
 *      [errorView.actionButton sizeToFit];
 * 	[errorView.actionButton addEventHandler:^(id sender, UIControlEvents controlEvents) {
 * 	        [weakSelf reloadData];
 * 	} forControlEvents:UIControlEventTouchUpInside];
 * 	[self.view addSubview:errorView];
 *
 *
 */
@interface ESErrorView : UIView

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

/**
 * To add an `actionButton`, just set this property.
 */
@property (nonatomic, strong) UIButton *actionButton;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title subtitle:(NSString *)subtitle image:(UIImage *)image;

@end
