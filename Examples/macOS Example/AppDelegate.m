//
//  AppDelegate.m
//  macOS Example
//
//  Created by Elf Sundae on 2019/06/19.
//

#import "AppDelegate.h"
#import <ESFramework/ESFramework.h>

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application

    NSLog(@"Interfaces: %@", [ESNetworkInfo networkInterfaces]);
    NSLog(@"Local IP: %@", [ESNetworkInfo localIPAddresses:NULL]);
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    // Insert code here to tear down your application
}

@end
