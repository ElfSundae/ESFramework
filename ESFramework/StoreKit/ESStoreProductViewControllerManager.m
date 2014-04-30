//
//  ESStoreProductViewControllerManager.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-10.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

@import StoreKit.SKStoreProductViewController;
#import "ESStoreProductViewControllerManager.h"
#import <ESFrameworkCore/ESApp.h>

@interface ESStoreProductViewControllerManager ()
{
        BOOL _storeKitExists;
}
@property (nonatomic, readwrite) BOOL hasPresentedProductViewController;
@end

@implementation ESStoreProductViewControllerManager

ES_SINGLETON_IMP(sharedManager);

- (id)init
{
        self = [super init];
        if (self) {
              _storeKitExists = !!NSClassFromString(@"SKStoreProductViewController");
        }
        return self;
}

- (void)openProductWithITunesLink:(NSURL *)iTunesLink willAppear:(ESStoreProductViewControllerManagerBlock)willAppear didDismiss:(ESStoreProductViewControllerManagerBlock)didDissmiss
{
#if TARGET_IPHONE_SIMULATOR
        [ESApp openURL:iTunesLink];
        return;
#endif
        if (!_storeKitExists) {
                [ESApp openURL:iTunesLink];
                return;
        }
        
        NSString *itemID = [ESStoreUtilities itemIDFromITunesLink:iTunesLink];
        if (!itemID) {
                [ESApp openURL:iTunesLink];
                return;
        }
        
        if (self.hasPresentedProductViewController) {
                return;
        }
        self.didDismissBlock = didDissmiss;
        self.hasPresentedProductViewController = YES;
        ES_WEAK_VAR(self, _self);
        SKStoreProductViewController *storeController = [[SKStoreProductViewController alloc] init];
        [storeController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier: itemID}
                                   completionBlock:^(BOOL result, NSError *error) {
                                           ES_STRONG_VAR_CHECK_NULL(_self, _strongSelf);
                                           if (!result) {
                                                   _strongSelf.didDismissBlock = nil;
                                                   _strongSelf.hasPresentedProductViewController = NO;
                                                   [ESApp openURL:iTunesLink];
                                                   return;
                                           }
                                           if (willAppear) {
                                                   willAppear();
                                           }
                                           storeController.delegate = (id)_strongSelf;
                                           [[ESApp rootViewControllerForPresenting] presentViewController:storeController animated:YES completion:nil];
                                   }];
        
}

- (void)openProductWithITunesLink:(NSURL *)iTunesLink
{
        [self openProductWithITunesLink:iTunesLink willAppear:nil didDismiss:nil];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - SKStoreProductViewControllerDelegate
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
        [viewController dismissModalViewControllerAnimated:YES];
        self.hasPresentedProductViewController = NO;
        if (self.didDismissBlock) {
                self.didDismissBlock();
        }
        self.didDismissBlock = nil;
}

@end
