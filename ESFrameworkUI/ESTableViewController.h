//
//  ESTableViewController.h
//  ESFramework
//
//  Created by Elf Sundae on 2014/04/29.
//  Copyright (c) 2014 https://0x123.com All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESRefreshControl.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `ESTableViewController` is a replacement of `UITableViewController`.
 *
 * `ESTableViewController` adds the table view as a subview of self.view.
 */
@interface ESTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
}

- (instancetype)initWithStyle:(UITableViewStyle)style;

@property (null_resettable, nonatomic, strong) UITableView *tableView;
@property (nonatomic, readonly) UITableViewStyle tableViewStyle;
@property (nullable, nonatomic, strong) ESRefreshControl *refreshControl;
/// defaults to YES. If YES, any selection is cleared in viewWillAppear:
@property (nonatomic) BOOL clearsSelectionOnViewWillAppear;

@end

NS_ASSUME_NONNULL_END
