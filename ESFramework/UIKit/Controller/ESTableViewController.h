//
//  ESTableViewController.h
//  ESFramework
//
//  Created by Elf Sundae on 4/29/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESRefreshControl.h"

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

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, readonly) UITableViewStyle tableViewStyle;
@property (nonatomic, strong) ESRefreshControl *refreshControl;
@property (nonatomic) BOOL clearsSelectionOnViewWillAppear;

@end
