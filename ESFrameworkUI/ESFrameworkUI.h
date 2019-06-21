//
//  ESFrameworkUI.h
//  ESFramework
//
//  Created by Elf Sundae on 2019/04/15.
//  Copyright © 2019 https://0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for ESFrameworkUI.
FOUNDATION_EXPORT double ESFrameworkUIVersionNumber;

//! Project version string for ESFrameworkUI.
FOUNDATION_EXPORT const unsigned char ESFrameworkUIVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <ESFrameworkUI/PublicHeader.h>

#if __has_include(<ESFrameworkUI/ESActivityLabel.h>)

#import <ESFrameworkUI/ESActivityLabel.h>
#import <ESFrameworkUI/ESBadgeView.h>
#import <ESFrameworkUI/ESErrorView.h>
#import <ESFrameworkUI/ESRefreshControl.h>
#import <ESFrameworkUI/ESRefreshControlDefaultContentView.h>
#import <ESFrameworkUI/ESStatusOverlayView.h>
#import <ESFrameworkUI/ESTableViewController.h>

#else

#import "ESActivityLabel.h"
#import "ESBadgeView.h"
#import "ESErrorView.h"
#import "ESRefreshControl.h"
#import "ESRefreshControlDefaultContentView.h"
#import "ESStatusOverlayView.h"
#import "ESTableViewController.h"

#endif
