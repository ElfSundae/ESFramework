//
//  ESRefreshControlDefaultContentView.h
//  ESFramework
//
//  Created by Elf Sundae on 5/22/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESRefreshControl.h"
#import "ESActivityLabel.h"

@class ESRefreshControlDefaultContentView;

@interface ESRefreshControlDefaultContentView : UIView
<ESRefreshControlContentViewDelegate>

// `strokeColor`, `lineWidth` can be set.
@property (nonatomic, strong, readonly) CAShapeLayer *shapeLayer;
// `activityIndicatorViewStyle` can be set.
@property (nonatomic, strong, readonly) UIActivityIndicatorView *activityIndicatorView;

@end