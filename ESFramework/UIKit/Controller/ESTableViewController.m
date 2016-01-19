//
//  ESTableViewController.m
//  ESFramework
//
//  Created by Elf Sundae on 4/29/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESTableViewController.h"
#import <ESFramework/ESDefines.h>

@implementation ESTableViewController

- (void)dealloc
{
        _tableView.refreshControl = nil;
        _tableView.dataSource = nil;
        _tableView.delegate = nil;
        _tableView = nil;
}

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

- (void)viewDidLoad
{
        [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
        [super viewWillAppear:animated];
        if (self.clearsSelectionOnViewWillAppear) {
                [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:animated];
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

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        id<ESTableViewDataSource> dataSource = nil;
        if (tableView.dataSource && [tableView.dataSource conformsToProtocol:@protocol(ESTableViewDataSource)]) {
                dataSource = (id<ESTableViewDataSource>)(tableView.dataSource);
        }
 
        id cellData = nil;
        if (dataSource && [dataSource respondsToSelector:@selector(tableView:cellDataForRowAtIndexPath:)]) {
                cellData = [dataSource tableView:tableView cellDataForRowAtIndexPath:indexPath];
        }
        
        Class cellClass = NULL;
        if (dataSource && [dataSource respondsToSelector:@selector(tableView:cellClassForRowAtIndexPath:cellData:)]) {
                cellClass = [dataSource tableView:tableView cellClassForRowAtIndexPath:indexPath cellData:cellData];
        }
        if (!cellClass) {
                cellClass = [UITableViewCell class];
        }
        
        NSString *cellIdentifier = NSStringFromClass(cellClass);
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (!cell) {
                if (dataSource && [dataSource respondsToSelector:@selector(tableView:cellNewInstanceForRowAtIndexPath:cellClass:reuseIdentifier:)]) {
                        cell = [dataSource tableView:tableView cellNewInstanceForRowAtIndexPath:indexPath cellClass:cellClass reuseIdentifier:cellIdentifier];
                }
                if (!cell) {
                        cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                }
        }
        
        
        BOOL isLastRowInSection = NO;
        if (dataSource && [dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
                isLastRowInSection = ([dataSource tableView:tableView numberOfRowsInSection:indexPath.section] == (indexPath.row + 1));
        }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        ESInvokeSelector(cell, @selector(setCellIndexPath:), NULL, indexPath);
        ESInvokeSelector(cell, @selector(setIsFirstRowInSection:), NULL, (0 == indexPath.row));
        ESInvokeSelector(cell, @selector(setIsLastRowInSection:), NULL, isLastRowInSection);
#pragma clang diagnostic pop
        
        cell.cellData = cellData;
        
        if (dataSource && [dataSource respondsToSelector:@selector(tableView:configureCell:forRowAtIndexPath:cellData:)]) {
                [dataSource tableView:tableView configureCell:cell forRowAtIndexPath:indexPath cellData:cellData];
        }
        
        return cell;
}


@end
