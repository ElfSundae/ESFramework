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

@property (nonatomic, strong) UIImageView *imageView;
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

    self.view.backgroundColor = UIColor.groupTableViewBackgroundColor;

    UIImage *image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1556519087064&di=a1ac3f083b0d6fb9cd9d65f0c86d925c&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201706%2F22%2F20170622131955_h4eZS.thumb.700_0.jpeg"]]];
    UIImage *image2 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1556519130874&di=955380e59701f6d0958cd12b5868c82b&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201610%2F07%2F20161007135521_VrPkv.thumb.700_0.jpeg"]]];

    self.imageView = [[UIImageView alloc] initWithImage:image1];
    self.imageView.size = CGSizeMake(300, 300);
    [self.view addSubview:self.imageView];
    [self.imageView moveToCenter];
    [self.imageView setMaskLayerWithCornerRadius:self.imageView.height / 2];

    ESWeakSelf;
    self.timer = [NSTimer es_scheduledTimerWithTimeInterval:3 repeats:YES block:^(NSTimer *timer) {
        ESStrongSelf;
        [_self timerAction:timer];

        UIImage *image = _self.imageView.image != image1 ? image1 : image2;
        [_self.imageView setImageAnimated:image duration:0.25];
    }];
}

- (void)timerAction:(NSTimer *)timer
{
    NSLog(@"timer tick: %@", NSDate.date);
}

@end
