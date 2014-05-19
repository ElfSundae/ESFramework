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

#define ESRouterURLKeyParam             @"p"
#define ESRouterURLKeyParam1            @"p1"
#define ESRouterURLKeyParam2            @"p2"
#define ESRouterURLKeyIsRoot            @"__root__"
#define ESRouterURLKeyIsModal           @"__modal__"
#define ESRouterURLKeyIsAnimated        @"__animated__"

/**
 * URL Router for UIViewControllers, Blocks.
 * Inspired by [Routable iOS](https://github.com/usepropeller/routable-ios).
 *
 * ## Supports types
 *
 * ### UIViewController
 * Push or Present an `UIViewController` instance.
 *
 *      * `@"user/?id=123456" // 'user' behavior has been registered to Router.`
 *      * `@"user?id=123456&__modal__=1&refresh=1" // force presenting instead registered behavior.`
 *      * `@"MyProfileViewController?key=foo%20bar&__root__=1" // pushing as the root view controller.`
 *      * `@"MyWebViewController?__modal__=0&url=http%3A%2F%2Fwww.google.com" // pushing with default navigation controller.`
 *
 * ### Blocks
 *
 *      * `ESRouterOpenBlock` type.
 *
 *
 * ## URL format
 *
 * `URL` formats as `path[/p][/p1][/p2][/][?param1=value1][&param2=value2][...]` .
 *
 * `path` is required, **All parts in URL must be URLEncoded.**
 *
 * The params' prefix can be `?`, `&`, `#`.
 *
 *
 * 	user/123456
 * 	somePath/pValue/p1Value/p2Value&key1=value1&key2=value2
 * 	UserProfileViewController/123456
 * 	user/123456/?key1=value1&key2=value2
 * 	user/123456?key1=value1&key2=value2
 * 	user/123456/&key1=value1&key2=value2
 * 	user/123456&key1=value1&key2=value2
 * 	user/123456/#key1=value1&key2=value2
 * 	user/123456#key1=value1&key2=value2
 * 	user/123456&key1=value1&key2=value2
 * 	user#p=123456&key1=value1&key2=value2
 *
 *
 * ## Usage
 *
 * Optionally register `path`s before `open:path`.
 *
 * 	// In AppDelegate, register path
 * 	[[ESRouter sharedRouter] registerPath:@"test_block" toBlock:^(NSDictionary *params) {
 * 	        NSLog(@"test_block called.");
 * 	}];
 *
 * 	[[[ESRouter sharedRouter] registerPath:@"block_params" toBlock:^(NSDictionary *params) {
 * 	        NSLog(@"block_params called: %@", params);
 * 	}] setDefaultParams:@{@"default key": @"default value"}];
 *
 * 	ESRouterObject *profileObject = [[ESRouter sharedRouter] registerPath:@"profile" toClass:@"UserProfileViewController"];
 * 	profileObject.openingCallback = ^(UIViewController *fromController, UIViewController *toController, NSDictionary *openParams){
 * 	        NSLog(@"Will open profile");
 * 	        [ESApp dismissAllViewControllersAnimated:NO completion:nil];
 * 	};
 *
 * Open.
 *
 * 	// Open a path
 * 	[[ESRouter sharedRouter] open:@"test_block"];
 * 	// Open with params
 * 	[[ESRouter sharedRouter] open:@"block_params/pValue/p1Value/p2Value?index=123&%@=%@",
 * 	 [@"code key" URLEncode], [@"code value" URLEncode]];
 *
 * 	[[ESRouter sharedRouter] open:@"profile/123456"];
 *
 * 	// open with params and extraInfo
 * 	[[ESRouter sharedRouter] open:@"UserProfileViewController/654321"
 * 	                       params:@{ESRouterURLKeyIsModal : @NO,
 * 	                                ESRouterURLKeyIsRoot : @YES}
 * 	                    extraInfo:[MyUserData data]];
 *
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
 * ### TODO
 *
 * + Push issue, should can be set as a shared controller, like TTNavigator.
 *      @warning until now, you should only use `ESRouter` to open a block or present a view controller,
 *      **No** pushing.
 *
 */
@interface ESRouter : NSObject

ES_SINGLETON_DEC(sharedRouter);

@property (nonatomic, copy) NSString *defaultContainerNavigationControllerForPresenting;
@property (nonatomic, strong, readonly) Class defaultContainerNavigationControllerClassForPresenting; // Cached
@property (nonatomic, strong) UINavigationController *defaultNavigationController;

///=============================================
/// @name Register
///=============================================

- (ESRouterObject *)registerPath:(NSString *)path toRouterObject:(ESRouterObject *)routerObject;
- (ESRouterObject *)registerPath:(NSString *)path toClass:(NSString *)className;
- (ESRouterObject *)registerPath:(NSString *)path toBlock:(ESRouterOpenBlock)block;

///=============================================
/// @name Route Method
///=============================================

/**
 * All parts in URL must be URLEncoded.
 * @see -[NSString URLEncode]
 */
- (BOOL)open:(NSString *)format, ...;

/**
 * All parts in URL must be URLEncoded.
 * @see -[NSString URLEncode]
 */
- (BOOL)open:(NSString *)url params:(NSDictionary *)routerParams extraInfo:(id)extraInfo;

/**
 * Dismiss or pop `controller`.
 */
+ (void)close:(UIViewController *)controller animated:(BOOL)animated;
- (void)close:(UIViewController *)controller animated:(BOOL)animated;

///=============================================
/// @name Internal
///=============================================

/**
 * path(NSString) => routerObject(ESRouterObject)
 */
@property (nonatomic, strong, readonly) NSMutableDictionary *map;
/**
 * Returns registered `routerObject` for `path`.
 */
- (ESRouterObject *)routerObjectForPath:(NSString *)path;
- (BOOL)openRouterObject:(ESRouterObject *)routerObject params:(NSMutableDictionary *)params extraInfo:(id)extraInfo;
- (BOOL)_parseURL:(NSString *)url toPath:(NSString **)path toParams:(NSMutableDictionary **)params;
@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ESRouterObject

/**
 * Data model for ESRouter
 */
@interface ESRouterObject : NSObject <NSCopying>

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
 * Invocked when dismissed or poped.
 */
//@property (nonatomic, copy) ESRouterClosedCallback closedCallback;

///=============================================
/// @name UIViewController Opening Options
///=============================================
/**
 * It will be invoked before opening.
 * i.e. you can set `UIModalPresentationStyle`, `UIModalTransitionStyle`, etc.
 */
@property (nonatomic, copy) ESRouterOpeningCallback openingCallback;
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

/**
 * `UIViewController` may implement `ESRouterDelegate` to get `routerParams` or `routerExtraInfo`.
 */
@protocol ESRouterDelegate <NSObject>
@optional
/**
 * All `NSString` params
 */
@property (nonatomic, strong) NSDictionary *routerParams;
/**
 * The first 'p' value
 */
@property (nonatomic, copy) NSString *routerParam;
/**
 * The second 'p1' value
 */
@property (nonatomic, copy) NSString *routerParam1;
/**
 * The third 'p2' value
 */
@property (nonatomic, copy) NSString *routerParam2;
/**
 * Other param with `id` type.
 */
@property (nonatomic, strong) id routerExtraInfo;
@end
