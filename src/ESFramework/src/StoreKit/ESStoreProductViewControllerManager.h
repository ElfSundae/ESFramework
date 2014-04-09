//
//  ESStoreProductViewControllerManager.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-10.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ESStoreProductViewControllerManagerBlock)(void);

@interface ESStoreProductViewControllerManager : NSObject

ES_SINGLETON_DEC(sharedManager);
__ES_ATTRIBUTE_UNAVAILABLE_SINGLETON_ALLOCATION;

@property (nonatomic, readonly) BOOL hasPresentedProductViewController;
@property (nonatomic, copy) ESStoreProductViewControllerManagerBlock willAppearBlock;
@property (nonatomic, copy) ESStoreProductViewControllerManagerBlock didDismissBlock;


/**
 * On iOS 6.0 or later, it will present SKStoreProductViewController, otherwise
 * uses [ESApp openURL:] to open #iTunesLink.
 * The first time to present SKStoreProductViewController will be slowly, then you can
 * handler #willAppear block to show a activityView or a HUD.
 *
 * @see [ESStoreUtilities itemIDFromITunesLink]
 *
 * @param willAppear  the SKStoreProductViewController will be presented
 * @param didDissmiss the SKStoreProductViewController has been dismissed
 */
- (void)openProductWithITunesLink:(NSURL *)iTunesLink willAppear:(ESStoreProductViewControllerManagerBlock)willAppear didDismiss:(ESStoreProductViewControllerManagerBlock)didDissmiss;

- (void)openProductWithITunesLink:(NSURL *)iTunesLink;

@end
