//
//  ESRouter.h
//  ESFramework
//
//  Created by Elf Sundae on 5/5/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ESDefines.h"

@class ESRouterObject;
@protocol ESRouterDelegate;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ESRouter

///=============================================
/// @name Constants
///=============================================

typedef void (^ESRouterOpenBlock)(NSDictionary *params);
typedef void (^ESRouterOpeningCallback)(UIViewController *fromController, UIViewController *toController, NSDictionary *openParams);
typedef void (^ESRouterClosedCallback)(UIViewController *fromController, NSDictionary *openParams, NSDictionary *result);

/// e.g. @"vc://profile/?uid=123456"
#define ESRouterURLSchemeController     @"vc"
/// e.g. @"fun://logout"
#define ESRouterURLSchemeBlock          @"func"

#define ESRouterURLKeyParam             @"p"
#define ESRouterURLKeyParam1            @"p1"
#define ESRouterURLKeyParam2            @"p2"
#define ESRouterURLKeyIsRoot            @"__root__"
#define ESRouterURLKeyIsModal           @"__modal__"
#define ESRouterURLKeyIsAnimated        @"__animated__"

/**
 * URL Router for UIViewControllers, Blocks, External URLs, In App Service.
 * Inspired by [Routable iOS](https://github.com/usepropeller/routable-ios).
 *
 * ## Supports types
 *
 * ### UIViewController
 * Push or Present an `UIViewController` instance.
 *
 *      * `@"user/?id=123456" // 'user' behave has been registered to Router.`
 *      * `@"user?id=123456&__modal__=1&refresh=1" // force presenting instead registered behave.`
 *      * `@"MyProfileViewController?key=foo%20bar&__root__=1" // pushing as the root view controller.`
 *      * `@"MyWebViewController?__modal__=0&url=http%3A%2F%2Fwww.google.com" // pushing with default navigation controller.`
 *
 * ### Blocks
 *
 *      * `ESRouterOpenBlock` type.
 *
 * ### External URLs
 * Open link in in-app controller if possible, or use -[ESApp openURL:].
 *
 *      * Safari: `http://`, `https://`, etc.
 *      * Mail: `mailto:`, use in-app `MFMailComposeViewController` if possible.
 *      * Message: `sms:`, use in-app `MFMessageComposeViewController` if possible.
 *      * App Store: `app-store://appID`, `itms-apps://`.
 *
 *              + `@"app-store://12345678" (SKStoreProductViewController if possible)`
 *              + `@"app-store://12345678&__inapp__=0&__app_review__=1" (App Store)`
 *
 *
 * ### In App Service
 *      * MFMailComposeViewController
 *      * MFMessageComposeViewController
 *      * SKStoreProductViewController (`ESFrameworkUIKit required`)
 *      * ESWebViewController (***TODO***)
 *              
 *
 * ## URL format
 *
 * `URL` formats as `scheme:[/][/]path[/p][/][?param1=value1][&param2=value2][...]` .
 *
 * The params prefix can be `?`, `&`, `#`. e.g.
 *
 * 	vc://user/123456/?key1=value1&key2=value2
 * 	vc://user/123456?key1=value1&key2=value2
 * 	vc://user/123456/&key1=value1&key2=value2
 * 	vc://user/123456&key1=value1&key2=value2
 * 	vc://user/123456/#key1=value1&key2=value2
 * 	vc://user/123456#key1=value1&key2=value2
 * 	vc:user/123456&key1=value1&key2=value2
 * 	vc:user#p=123456&key1=value1&key2=value2
 *
 * ## Usage
 *
 * ### Discussion
 *
 * Every presenting view controller have an navigation controller that you can set
 * `containerNavigationControllerForPresenting` in `ESRouterObject`, if it's not set,
 * ESRouter will use `defaultContainerNavigationControllerForPresenting`.
 *
 * `ESRouter` have a navigationController used to push view controllers, you can subclass
 * `ESRouter` to give different `defaultNavigationController`, or specify `navigationController`
 * in `ESRouterObject`.
 *
 *
 */
@interface ESRouter : NSObject

ES_SINGLETON_DEC(sharedRouter);

@property (nonatomic, copy) NSString *defaultContainerNavigationControllerForPresenting;
@property (nonatomic, strong) UINavigationController *defaultNavigationController;

///=============================================
/// @name Register
///
/// @discussion
/// Optionally register a path as alias to an `UIViewController` or a block.
///=============================================

- (ESRouterObject *)registerPath:(NSString *)path toRouterObject:(ESRouterObject *)routerObject;
- (ESRouterObject *)registerPath:(NSString *)path toClass:(NSString *)className;
- (ESRouterObject *)registerPath:(NSString *)path toBlock:(ESRouterOpenBlock)block;

///=============================================
/// @name Router
///=============================================

//- (void)open:(NSString *)path params:(NSDictionary *)routerParams extraInfo:(id)extraInfo;
//- (void)open:(NSString *)path params:(NSDictionary *)routerParams;

/**
 * `URL` must be URLEncoded.
 *
 * e.g. `@"vc://"`
 *
 * @see -[NSString URLEncode]
 */
//- (void)openURL:(NSString *)format, ...;

- (void)openURL:(NSString *)url params:(NSDictionary *)routerParams extraInfo:(id)extraInfo;

///=============================================
/// @name Internal
///=============================================

/**
 * path(NSString) => routerObject(ESRouterObject)
 */
@property (nonatomic, strong, readonly) NSMutableDictionary *map;
/**
 * `params` will always out of a `NSMutableDictionary` instance if passed **point** is not nil.
 */
- (BOOL)_parseURL:(NSString *)url toScheme:(NSString **)scheme toPath:(NSString **)path toParams:(NSMutableDictionary **)params;
@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ESRouterObject

/**
 * Data model for ESRouter
 */
@interface ESRouterObject : NSObject

///=============================================
/// @name Objects To Map
///=============================================

/**
 * Register a class name of an `UIViewController` instance to Router.
 */
@property (nonatomic, copy) NSString *openClassName;
/**
 * Cached Class
 */
@property (nonatomic, strong, readonly) Class openClass;
/**
 * Register an `openBlock` to Router.
 * Instead opening a instance of UIViewController, ESRouter can also be mapped to invoke a block.
 */
@property (nonatomic, copy) ESRouterOpenBlock openBlock;

///=============================================
/// @name Common Opening Options
///=============================================

/**
 * Initialization params, this will be added to the final route params.
 */
@property (nonatomic, strong) NSDictionary *defaultParams;
/**
 * Set **Open Options**, it will be invoked before **open**.
 * i.e. you can set `UIModalPresentationStyle`, `UIModalTransitionStyle`, etc.
 */
@property (nonatomic, copy) ESRouterOpeningCallback openingCallback;
/**
 * Invocked when dismissed or poped.
 */
@property (nonatomic, copy) ESRouterClosedCallback closedCallback;

///=============================================
/// @name UIViewController Opening Options
///=============================================

/**
 * The `UINavigationController` instance which will be used to push `UIViewController`.
 */
@property (nonatomic, strong) UINavigationController *navigationController;
/**
 * Router will set viewController as `RootViewController` to the navigation stack before pushing.
 */
@property (nonatomic, getter = isRoot) BOOL root;

@property (nonatomic, copy) NSString *containerNavigationControllerForPresenting;
/**
 * Router will present the modalViewController instead to push to the navigation stack.
 */
@property (nonatomic, getter = isModal) BOOL modal;
/**
 * Opening (presenting or pushing) with animation, default is `YES`.
 */
@property (nonatomic, getter = isAnimated) BOOL animated;

///=============================================
/// @name Initialization
///=============================================

/**
 * The UIViewController instance will be presented.
 */
+ (instancetype)objectWithClass:(NSString *)className;
/**
 * If the `isModal` is `YES`, the `isRoot` will be ignored.
 */
+ (instancetype)objectWithClass:(NSString *)className isModal:(BOOL)isModal isRoot:(BOOL)isRoot;

+ (instancetype)objectWithBlock:(ESRouterOpenBlock)openBlock;

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ESRouterDelegate

@protocol ESRouterDelegate <NSObject>
@optional
@property (nonatomic, strong) NSDictionary *routerParams;
@property (nonatomic, strong) id routerExtraInfo;
@end
