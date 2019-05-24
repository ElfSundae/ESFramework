//
//  RootViewController.m
//  Example
//
//  Created by Elf Sundae on 15/9/14.
//  Copyright (c) 2015年 www.0x123.com. All rights reserved.
//

#import "RootViewController.h"
#import <ESFramework/ESFramework.h>
#import "TestViewController.h"
#import "User.h"

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"ESFramework";

    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    [infoButton addActionBlock:^(__kindof UIControl * _Nonnull control) {
        [UIAlertController showAlertWithTitle:@"About"
                                      message:@"ESFramework\n\nhttps://0x123.com"
                            cancelActionTitle:@"OK"];
    } forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];

    self.tableView.rowHeight = 60;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    ESWeakSelf;
    self.tableView.es_refreshControl = [ESRefreshControl refreshControlWithDidStartRefreshingBlock:^(ESRefreshControl *refreshControl) {
        es_dispatch_after(1, ^{
                              ESStrongSelf;
                              [_self.tableView reloadData];
                              [refreshControl endRefreshing];
                          });
    }];

    // [self testAutoCoding];
}

- (void)testAutoCoding
{
    NSString *file = ESTemporaryPath(@"foo/bar/user");

    User *user = [User objectWithContentsOfFile:file];

    if (!user) {
        user = [[User alloc] init];
        user.name = @"Elf Sundae";
        user.age = 18;
        user.frame = CGRectMake(10, 20, 30, 40);
        user.dict = @{ @"key": @"value", @"array": @[ @100, @200 ] };
    } else {
        user.name = [user.name stringByAppendingFormat:@",%d", user.age];
        user.age += 10;
        CGRect frame = user.frame;
        frame.size.width = CGRectGetMaxX(frame);
        frame.size.height = CGRectGetMaxY(frame);
        user.frame = frame;
    }

    NSLog(@"%@\n%@", user.codableProperties, user.dictionaryRepresentation);

    [NSFileManager.defaultManager createDirectoryAtPath:file.stringByDeletingLastPathComponent];
    BOOL saved = [user writeToFile:file atomically:YES];
    NSLog(@"saved: %@", @(saved));

    User *user2 = [user copy];
    NSLog(@"%@", user2.dictionaryRepresentation);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ESRandomNumber(15, 60);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    cell.textLabel.attributedText =
        [[NSAttributedString alloc] initWithString:
         [NSString stringWithFormat:@"section %@ row %@", @(indexPath.section), @(indexPath.row)]
                                        attributes:@{ NSForegroundColorAttributeName: ESRandomColor(),
                                                      NSFontAttributeName: [UIFont boldSystemFontOfSize:20] }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController pushViewController:TestViewController.new animated:YES];
}

@end
