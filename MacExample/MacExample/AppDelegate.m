//
//  AppDelegate.m
//  MacExample
//
//  Created by Elf Sundae on 2016/12/27.
//  Copyright © 2016年 Elf Sundae. All rights reserved.
//

#import "AppDelegate.h"
#import <ESFramework/ESNetworkReachability.h>

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application

    NSLog(@"%@", [ESNetworkReachability defaultReachability].statusString);
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
