//
//  ESRefreshControl.h
//  ESFramework
//
//  Created by Elf Sundae on 2014/05/21.
//  Copyright (c) 2014 https://0x123.com All rights reserved.
//

#import <UIKit/UIKit.h>
@class ESRefreshControl;

typedef NS_ENUM(NSUInteger, ESRefreshControlState) {
    ESRefreshControlStateNormal = 0,
    ESRefreshControlStateTriggered,
    ESRefreshControlStateRefreshing,
};

typedef void (^ESRefreshControlBlock)(ESRefreshControl *refreshControl);
typedef NSString * (^ESRefreshControlStateBlock)(ESRefreshControl *refreshControl, ESRefreshControlState state);
typedef void (^ESRefreshControlUpdatedScrollViewBlock)(ESRefreshControl *refreshControl, UIScrollView *scrollView);

@protocol ESRefreshControlContentViewDelegate <NSObject>

@required
- (void)refreshControl:(ESRefreshControl *)refreshControl stateChanged:(ESRefreshControlState)state from:(ESRefreshControlState)fromState;

@optional
- (CGFloat)refreshControlContentViewHeight:(ESRefreshControl *)refreshControl; // 50. as default
- (void)refreshControl:(ESRefreshControl *)refreshControl pullProgressChanged:(CGFloat)pullProgress;

@end

/**
 * Pull-To-Refresh control.
 */
@interface ESRefreshControl : UIView

@property (nonatomic, readonly) ESRefreshControlState state;
@property (nonatomic, copy) ESRefreshControlBlock didStartRefreshingBlock;
@property (nonatomic, copy) ESRefreshControlUpdatedScrollViewBlock didUpdateScrollViewsContentInsetBlock;
@property (nonatomic, copy) ESRefreshControlStateBlock textForStateBlock;

- (UIScrollView *)scrollView;

+ (instancetype)refreshControlWithDidStartRefreshingBlock:(ESRefreshControlBlock)block;

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

@interface UIScrollView (ESRefreshControl)

@property (nonatomic, strong) ESRefreshControl *es_refreshControl;

@end
