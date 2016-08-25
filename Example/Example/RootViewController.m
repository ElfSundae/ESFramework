//
//  RootViewController.m
//  Example
//
//  Created by Elf Sundae on 15/9/14.
//  Copyright (c) 2015年 www.0x123.com. All rights reserved.
//

#import "RootViewController.h"
#import <ESFramework/ESFramework.h>

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"ESFramework Example";
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    [infoButton addEventHandler:^(id sender, UIControlEvents controlEvent) {
        [UIAlertView showWithTitle:@"About" message:@"ESFramework\nhttp://0x123.com" cancelButtonTitle:ESLocalizedString(@"OK")];
    } forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];

    self.tableView.rowHeight = 60;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    ESWeakSelf;
    self.tableView.refreshControl = [ESRefreshControl refreshControlWithDidStartRefreshingBlock:^(ESRefreshControl *refreshControl) {
        ESDispatchAfter(1, ^{
            ESStrongSelf;
            [_self.tableView reloadData];
            [refreshControl endRefreshing];
        });
    }];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ESRandomNumber(5, 60);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    cell.textLabel.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"section %@ row %@", @(indexPath.section), @(indexPath.row)]
                                                                    attributes:@{NSForegroundColorAttributeName: ESRandomColor(),
                                                                                 NSFontAttributeName: [UIFont boldSystemFontOfSize:20]}];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
