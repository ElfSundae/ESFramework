//
//  RootViewController.m
//  Example
//
//  Created by Elf Sundae on 15/9/14.
//  Copyright (c) 2015年 www.0x123.com. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController

- (void)viewDidLoad
{
        [super viewDidLoad];
        
        self.title = NSStringWith(@"ESFramework %@", [ESApp sharedApp].appDisplayName);
        
        UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
        [infoButton addEventHandler:^(id sender, UIControlEvents controlEvent) {
                [UIAlertView showWithTitle:@"About" message:@"ESFramework\nhttp://0x123.com" cancelButtonTitle:ESLocalizedString(@"OK")];
        } forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
        
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
        
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithDoneStyle:@"done" handler:^(UIBarButtonItem *barButtonItem) {
                if (self.statusOverlayView) {
                        [self.statusOverlayView hideAnimated:YES];
                        self.statusOverlayView = nil;
                } else {
                        self.statusOverlayView = [[ESStatusOverlayView alloc] initWithView:self.view];
                        self.statusOverlayView.activityLabel.activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
                        self.statusOverlayView.activityLabel.activityIndicatorView.color = [UIColor redColor];
                        [self.statusOverlayView showActivityLabel];
                }
        }];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return ESRandomNumber(100, 1000);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return [tableView dequeueReusableCellWithIdentifier:@"cellID"];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
        cell.contentView.backgroundColor = ESRandomColor();
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
