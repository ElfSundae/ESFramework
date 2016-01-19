//
//  ESTableViewController.h
//  ESFramework
//
//  Created by Elf Sundae on 4/29/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESTableViewDataSource.h"
#import <ESFramework/ESRefreshControl.h>

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ESTableViewController

/**
 * `UIViewController` coontains a `UITableView`
 */
@interface ESTableViewController : UIViewController <ESTableViewDataSource, UITableViewDelegate>
{
        UITableView *_tableView;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, readonly) UITableViewStyle tableViewStyle;

/**
 * Defaults to YES. If YES, any selection is cleared in `viewWillAppear:`
 */
@property (nonatomic) BOOL clearsSelectionOnViewWillAppear;

/**
 * Designed initializtion method.
 */
- (instancetype)initWithStyle:(UITableViewStyle)style;

@end


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewCell
@interface UITableViewCell (ESTableViewAdditions)

/**
 * These property will be configured in -tableView:cellForRowAtIndexPath:
 */
@property (nonatomic, strong) id cellData;
@property (nonatomic, strong, readonly) NSIndexPath *cellIndexPath;
@property (nonatomic, readonly) BOOL isFirstRowInSection;
@property (nonatomic, readonly) BOOL isLastRowInSection;

@end
