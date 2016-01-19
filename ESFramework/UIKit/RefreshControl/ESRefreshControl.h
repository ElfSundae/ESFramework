//
//  ESRefreshControl.h
//  ESFramework
//
//  Created by Elf Sundae on 5/21/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ESRefreshControl;
@protocol ESRefreshControlContentViewDelegate;

typedef NS_ENUM(NSUInteger, ESRefreshControlState) {
        ESRefreshControlStateNormal = 0,
        ESRefreshControlStateTriggered,
        ESRefreshControlStateRefreshing,
};

typedef void (^ESRefreshControlBlock)(ESRefreshControl *refreshControl);
typedef NSString* (^ESRefreshControlStateBlock)(ESRefreshControl *refreshControl, ESRefreshControlState state);
typedef void (^ESRefreshControlUpdatedScrollViewBlock)(ESRefreshControl *refreshControl, UIScrollView *scrollView);

/**
 * Pull-To-Refresh control.
 *
 * @warning To be safely, you may set `refreshControl` to `nil` in container's dealloc method.
 *
 * @code
 * - (void)dealloc
 * {
 *         if (_tableView.refreshControl) {
 *                 _tableView.refreshControl = nil;
 *         }
 *         _tableView.dataSource = nil;
 *         _tableView.delegate = nil;
 *         _tableView = nil;
 * }
 * @endcode
 *
 * @code
 * - (void)dealloc
 * {
 *         if (_webView.scrollView.refreshControl) {
 *                 _webView.scrollView.refreshControl = nil;
 *         }
 *         _webView.delegate = nil;
 * }
 * @endcode
 *
 */
@interface ESRefreshControl : UIView

@property (nonatomic, readonly) ESRefreshControlState state;
@property (nonatomic, readonly, weak) __weak UIScrollView *scrollView;
@property (nonatomic, copy) ESRefreshControlBlock didStartRefreshingBlock;
@property (nonatomic, copy) ESRefreshControlUpdatedScrollViewBlock didUpdateScrollViewsContentInsetBlock;
@property (nonatomic, copy) ESRefreshControlStateBlock textForStateBlock;

+ (instancetype)controlWithStartRefreshingBlock:(ESRefreshControlBlock)block;

/**
 * Call this method when you start refreshing, the `UIRefreshControl` will expand.
 */
- (void)beginRefreshing;
/**
 * Call this method when you finish refreshing.
 */
- (void)endRefreshing;
/**
 * Returns `(ESRefreshControlStateRefreshing == state)`
 */
- (BOOL)isRefreshing;


/** 
 * The content view displayed when the `scrollView` is pulling down. 
 */
@property (nonatomic, strong) UIView<ESRefreshControlContentViewDelegate> *contentView;
/**
 * Will ask `textForStateBlock` block.
 */
- (NSString *)textForState:(ESRefreshControlState)state;
@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIScrollView (ESRefreshControl)

@interface UIScrollView (ESRefreshControl)
@property (nonatomic, strong) ESRefreshControl *refreshControl;
@end


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -  ESRefreshControlContentViewDelegate

@protocol ESRefreshControlContentViewDelegate <NSObject>

@required
- (void)refreshControl:(ESRefreshControl *)refreshControl stateChanged:(ESRefreshControlState)state from:(ESRefreshControlState)fromState;

@optional
- (CGFloat)refreshControlContentViewHeight:(ESRefreshControl *)refreshControl; // 50.f as default
- (void)refreshControl:(ESRefreshControl *)refreshControl pullProgressChanged:(CGFloat)pullProgress;
@end