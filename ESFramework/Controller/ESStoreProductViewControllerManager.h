//
//  ESStoreProductViewControllerManager.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-10.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "ESDefines.h"

// TODO: 可以提前dismiss StoreProductViewController

/**
 * Singleton that presenting `SKStoreProductViewController` if it's exists.
 *
 * On iOS 6.0 or later, it will present `SKStoreProductViewController` if the
 * iTunes Store is reachable, or else it will uses [ESApp openURL:] to open App Store.
 *
 */
@interface ESStoreProductViewControllerManager : NSObject <SKStoreProductViewControllerDelegate>

ES_SINGLETON_DEC(sharedManager);

+ (BOOL)storeProductViewControllerExists;

@property (nonatomic, getter=isPresentingStoreProductViewController, readonly) BOOL presentingStoreProductViewController;

/**
 * Prensents the SKStoreProductViewController via iTunes URL.
 *
 * @param iTunesURL                iTunes URL, includes Apps, Books, Music, etc.
 * @param shouldOpenURLWhenFailure should use -[UIApplication openURL:] to open `iTunesURL` when the `SKStoreProductViewController` loading failed or some error occurred.
 * @param willAppear               The first time presenting `SKStoreProductViewController` will be slowly in most case, so you can display an `UIActivityIndicatorView` before presenting and then hide it in this `willAppear` block.
 * @param parameters               parameters(SKStoreProductParameter*) passed to SKStoreProductViewController.
 *
 * @return YES if successfully presented `SKStoreProductViewController`.
 */
- (BOOL)presentStoreWithProductURL:(NSURL *)iTunesURL shouldOpenURLWhenFailure:(BOOL)shouldOpenURLWhenFailure willAppear:(dispatch_block_t)willAppear parameters:(NSDictionary *)parameters;

/**
 * Prensents the SKStoreProductViewController via iTunes ID for an app.
 *
 * @return YES if successfully presented `SKStoreProductViewController`.
 */
- (BOOL)presentStoreWithAppID:(NSString *)appID shouldOpenURLWhenFailure:(BOOL)shouldOpenURLWhenFailure willAppear:(dispatch_block_t)willAppear parameters:(NSDictionary *)parameters;

@end
