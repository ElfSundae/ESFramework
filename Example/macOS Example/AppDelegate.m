//
//  AppDelegate.m
//  macOS Example
//
//  Created by Elf Sundae on 2019/06/19.
//

#import "AppDelegate.h"
@import ESFramework;

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application

    NSLog(@"%@", [ESNetworkHelper getIPAddresses]);
    NSLog(@"WiFi IP: %@", [ESNetworkHelper getIPAddressForWiFi:nil]);
}


- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    // Insert code here to tear down your application
}

@end
