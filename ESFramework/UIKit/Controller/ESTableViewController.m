//
//  ESTableViewController.m
//  ESFramework
//
//  Created by Elf Sundae on 4/29/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESTableViewController.h"
#import "ESDefines.h"

@implementation ESTableViewController

- (instancetype)init
{
        return [self initWithStyle:UITableViewStylePlain];
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
        self = [super init];
        if (self) {
                _clearsSelectionOnViewWillAppear = YES;
                _tableViewStyle = style;
        }
        return self;
}

- (void)loadView
{
        [super loadView];
        [self tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
        [super viewWillAppear:animated];
        if (self.clearsSelectionOnViewWillAppear) {
                for (NSIndexPath *indexPath in self.tableView.indexPathsForSelectedRows) {
                        [self.tableView deselectRowAtIndexPath:indexPath animated:animated];
                }
        }
}

- (void)viewDidAppear:(BOOL)animated
{
        [super viewDidAppear:animated];
        [self.tableView flashScrollIndicators];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
        [super setEditing:editing animated:animated];
        [self.tableView setEditing:editing animated:animated];
}

- (UITableView *)tableView
{
        if (!_tableView) {
                _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:_tableViewStyle];
                _tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
                _tableView.dataSource = self;
                _tableView.delegate = self;
                [self.view addSubview:_tableView];
        }
        return _tableView;
}

- (ESRefreshControl *)refreshControl
{
        return _tableView.refreshControl;
}

- (void)setRefreshControl:(ESRefreshControl *)refreshControl
{
        _tableView.refreshControl = refreshControl;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        [self doesNotRecognizeSelector:_cmd];
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        [self doesNotRecognizeSelector:_cmd];
        return nil;
}

@end
