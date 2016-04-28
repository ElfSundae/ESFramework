//
//  ESStoreProductViewControllerManager.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-10.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESStoreProductViewControllerManager.h"
#import "ESStoreHelper.h"
#import "ESApp.h"

@interface ESStoreProductViewControllerManager ()
@property (nonatomic, getter=isPresentingStoreProductViewController) BOOL presentingStoreProductViewController;
@property (nonatomic) UIColor *applicationNavigationBarTintColor;
@end

@implementation ESStoreProductViewControllerManager

ES_SINGLETON_IMP(sharedManager);

+ (BOOL)storeProductViewControllerExists
{
#if TARGET_IPHONE_SIMULATOR
        return NO;
#else
        return !!NSClassFromString(@"SKStoreProductViewController");
#endif
}

- (BOOL)presentStoreWithProductURL:(NSURL *)iTunesURL shouldOpenURLWhenFailure:(BOOL)shouldOpenURLWhenFailure willAppear:(dispatch_block_t)willAppear parameters:(NSDictionary *)parameters
{
        NSString *itemID = [ESStoreHelper itemIDFromURL:iTunesURL];
        if (!itemID || ![[self class] storeProductViewControllerExists]) {
                if (willAppear) willAppear();
                if (shouldOpenURLWhenFailure) {
                        [[UIApplication sharedApplication] openURL:iTunesURL];
                }
                return NO;
        }
        
        if (self.isPresentingStoreProductViewController) {
                // Currently maybe preparing, presenting, presented(shown) the `ProductViewController`.
                if (willAppear) willAppear();
                return NO;
        }
        
        self.presentingStoreProductViewController = YES;
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[SKStoreProductParameterITunesItemIdentifier] = itemID;
        if (ESIsDictionaryWithItems(parameters)) {
                [params addEntriesFromDictionary:parameters];
        }        
        
        ESWeakSelf;
        SKStoreProductViewController *productController = [[SKStoreProductViewController alloc] init];
        [productController loadProductWithParameters:params completionBlock:^(BOOL result, NSError *error) {
                if (willAppear) {
                        willAppear();
                }
                ESStrongSelf;
                if (result) {
                        productController.delegate = _self;
                        _self.applicationNavigationBarTintColor = [UINavigationBar appearance].tintColor;
                        [UINavigationBar appearance].tintColor = nil;
                        [ESApp presentViewController:productController animated:YES completion:nil];
                } else {
                        _self.presentingStoreProductViewController = NO;
                        if (shouldOpenURLWhenFailure) {
                                [[UIApplication sharedApplication] openURL:iTunesURL];
                        }
                }
        }];
        
        return YES;
}

- (BOOL)presentStoreWithAppID:(NSString *)appID shouldOpenURLWhenFailure:(BOOL)shouldOpenURLWhenFailure willAppear:(dispatch_block_t)willAppear parameters:(NSDictionary *)parameters
{
        NSURL *url = [ESStoreHelper appLinkForAppID:appID storeCountryCode:nil];
        return [self presentStoreWithProductURL:url shouldOpenURLWhenFailure:shouldOpenURLWhenFailure willAppear:willAppear parameters:parameters];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - SKStoreProductViewControllerDelegate

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
        [UINavigationBar appearance].tintColor = self.applicationNavigationBarTintColor;
        ESWeakSelf;
        [viewController.presentingViewController dismissViewControllerAnimated:YES completion:^{
                ESStrongSelf;
                _self.presentingStoreProductViewController = NO;
        }];
}

@end
