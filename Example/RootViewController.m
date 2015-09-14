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

- (instancetype)init
{
        self = [super initWithStyle:UITableViewStyleGrouped];
        self.title = [ESApp sharedApp].appDisplayName;
        return self;
}

- (void)viewDidLoad
{
        [super viewDidLoad];
        
        UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
        [infoButton addEventHandler:^(id sender, UIControlEvents controlEvent) {
                [UIAlertView showWithTitle:@"About" message:@"ESFramework\nhttp://0x123.com" cancelButtonTitle:ESLocalizedString(@"OK")];
        } forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
}

@end
