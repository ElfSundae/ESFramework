//
//  UIViewController+ESStatusOverlayView.h
//  ESFramework
//
//  Created by Elf Sundae on 5/21/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESStatusOverlayView.h"

@interface UIViewController (ESStatusOverlayView)
/// Lazy created.
@property (nonatomic, strong) ESStatusOverlayView *statusOverlayView;
- (ESStatusOverlayView *)currentStatusOverlayView;
- (BOOL)isShowingStatusOverlayView;
@end
