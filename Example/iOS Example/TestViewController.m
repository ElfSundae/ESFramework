//
//  TestViewController.m
//  Example
//
//  Created by Elf Sundae on 2019/04/22.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import "TestViewController.h"
#import <ESFramework/ESFramework.h>

@interface TestViewController ()
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation TestViewController

- (void)dealloc
{
    if (self.timer) {
        [self.timer invalidate];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];

//    ESWeakSelf;
//    self.timer = [NSTimer es_scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer *timer) {
//        [weak_self timerAction:timer];
//    }];

     self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:[ESWeakProxy proxyWithTarget:self] selector:@selector(timerAction:) userInfo:nil repeats:YES];
}

- (void)timerAction:(NSTimer *)timer
{
    NSLog(@"timer tick: %@", NSDate.date);
}

@end
