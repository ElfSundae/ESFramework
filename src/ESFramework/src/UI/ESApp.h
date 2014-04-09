//
//  ESApp.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-8.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

@import Foundation;

@interface ESApp : NSObject

+ (NSBundle *)mainBundle;
+ (NSDictionary *)infoDictionary;
+ (NSString *)displayName;
+ (NSString *)appVersion;
+ (NSString *)bundleIdentifier;

/**
 * Returns all URL Schemes that specified in the Info.plist.
 *
 * @param identifier URL identifier
 */
+ (NSArray *)URLSchemesForIdentifier:(NSString *)identifier;
/**
 * Returns all URL Schemes for the blank or NULL identifier.
 */
+ (NSArray *)URLSchemes;
/**
 * The first scheme for the identifier.
 *
 * @param identifier URL identifier specified in the Info.plist.
 */
+ (NSString *)URLSchemeForIdentifier:(NSString *)identifier;
/**
 * The first scheme for the blank or NULL identifier.
 * In general, this may be the App Scheme that used to open this app
 * from another app (like Safari, [[UIApplication sharedApplication] openURL:...])
 */
+ (NSString *)URLScheme;

+ (BOOL)canOpenURL:(NSURL *)url;
+ (BOOL)openURL:(NSURL *)url;
+ (BOOL)openURLWithString:(NSString *)urlString;
/**
 * Checks whether current device can make a phone call.
 */
+ (BOOL)canOpenPhoneCall;
/**
 * Make a phone call to the given phone number.
 * If #returnToAppAfterCall is YES, it will return back to this app after phone call.
 */
+ (BOOL)openPhoneCall:(NSString *)phoneNumber returnToAppAfterCall:(BOOL)shouldReturn;

@end


@interface ESApp (UI)
/**
 * The real rootViewController for presenting modalViewController.
 */
+ (UIViewController *)rootViewControllerForPresenting;
@end
