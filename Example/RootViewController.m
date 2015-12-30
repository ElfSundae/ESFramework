//
//  RootViewController.m
//  Example
//
//  Created by Elf Sundae on 15/9/14.
//  Copyright (c) 2015年 www.0x123.com. All rights reserved.
//

#import "RootViewController.h"
#import "ESFramework.h"

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
        
        ESActivityLabel *label = [[ESActivityLabel alloc] initWithStyle:ESActivityLabelStyleGray text:@"test"];
        label.center = self.view.center;
        [self.view addSubview:label];
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

@end
