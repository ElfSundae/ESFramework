//
//  ESRefreshControlDefaultContentView.h
//  ESFramework
//
//  Created by Elf Sundae on 2014/05/22.
//  Copyright (c) 2014 https://0x123.com All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESRefreshControl.h"

@interface ESRefreshControlDefaultContentView : UIView <ESRefreshControlContentViewDelegate>

// `strokeColor`, `lineWidth` can be set.
@property (nonatomic, strong, readonly) CAShapeLayer *shapeLayer;
// `activityIndicatorViewStyle` can be set.
@property (nonatomic, strong, readonly) UIActivityIndicatorView *activityIndicatorView;

@end
