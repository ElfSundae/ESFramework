//
//  ESRefreshControl.m
//  ESFramework
//
//  Created by Elf Sundae on 5/21/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESRefreshControl.h"
#import "ESRefreshControlDefaultContentView.h"
#import "UIView+ESShortcut.h"

static void *_esRefreshControlKVOContext = &_esRefreshControlKVOContext;
#define _esDefaultContentViewHeight 50.
#define _esAnimationDuration 0.25

@interface ESRefreshControl ()
{
        BOOL _hasObserveredSuperView;
        __weak UIScrollView *_storedScrollView;
}

@property (nonatomic) ESRefreshControlState state;
@property (nonatomic) CGFloat contentViewHeight;
@end

@implementation ESRefreshControl
@synthesize contentView = _contentView;

- (instancetype)initWithFrame:(CGRect)frame
{
        self = [super initWithFrame:CGRectZero];
        if (self) {
                self.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
                self.clipsToBounds = YES;
        }
        return self;
}

- (instancetype)init
{
        return [self initWithFrame:CGRectZero];
}

+ (instancetype)refreshControlWithDidStartRefreshingBlock:(ESRefreshControlBlock)block
{
        ESRefreshControl *control = [[ESRefreshControl alloc] init];
        control.didStartRefreshingBlock = block;
        return control;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
        if (newSuperview) {
                if ([newSuperview isKindOfClass:[UIScrollView class]]) {
                        [self _removeScrollViewObserver];
                        _storedScrollView = (UIScrollView *)newSuperview;
                        self.frame = CGRectMake(0, 0, newSuperview.bounds.size.width, 0);
                        self.contentView.frame = CGRectMake(0, 0, self.width, self.contentViewHeight);
                        [self.contentView refreshControl:self stateChanged:self.state from:self.state];
                } else {
                        [NSException raise:@"ESRefreshControlException" format:@"ESRefreshControl can only be added to UIScrollView."];
                }
        } else if (self.superview) {
                [self _removeScrollViewObserver];
        }
}

- (void)didMoveToWindow
{
        if (_storedScrollView && !_hasObserveredSuperView) {
                // It's the first shown
                [_storedScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:_esRefreshControlKVOContext];
                _hasObserveredSuperView = YES;
        }
}

- (void)_removeScrollViewObserver
{
        if (_hasObserveredSuperView) {
                [self.scrollView removeObserver:self forKeyPath:@"contentOffset" context:_esRefreshControlKVOContext];
                _hasObserveredSuperView = NO;
                _storedScrollView = nil;
                if (self.scrollView && self.isRefreshing) {
                        [self endRefreshing];
                }
        }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Properties

- (UIScrollView *)scrollView
{
        return (UIScrollView *)self.superview;
}

- (UIView<ESRefreshControlContentViewDelegate> *)contentView
{
        if (!_contentView) {
                self.contentView = [[ESRefreshControlDefaultContentView alloc] init];
        }
        return _contentView;
}

- (void)setContentView:(UIView<ESRefreshControlContentViewDelegate> *)contentView
{
        [_contentView removeFromSuperview];
        _contentView = contentView;
        
        if (_contentView) {
                _contentView.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
                [self addSubview:_contentView];
        }
}

- (CGFloat)contentViewHeight
{
        if (0. == _contentViewHeight) {
                if ([self.contentView respondsToSelector:@selector(refreshControlContentViewHeight:)]) {
                        _contentViewHeight = [self.contentView refreshControlContentViewHeight:self];
                }
                if (0. >= _contentViewHeight) {
                        _contentViewHeight = _esDefaultContentViewHeight;
                }
        }
        
        return _contentViewHeight;
}

/**
 * Set state and notify delegate
 */
- (void)setState:(ESRefreshControlState)state
{
        if (_state == state) {
                return;
        }
        
        ESRefreshControlState oldState = _state;
        _state = state;
        
        [self.contentView refreshControl:self stateChanged:_state from:oldState];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private Methods

- (void)_setPullProgress:(CGFloat)progress
{
        if ([self.contentView respondsToSelector:@selector(refreshControl:pullProgressChanged:)]) {
                // Ensure the value is between 0 and 1
                progress = fmax(0., (fmin(progress, 1.)));
                [self.contentView refreshControl:self pullProgressChanged:progress];
        }
}

- (void)_setRefreshing:(BOOL)refreshing
{
        if (refreshing) {
                if (ESRefreshControlStateRefreshing == self.state) {
                        return;
                }
                self.state = ESRefreshControlStateRefreshing;
                
                // Cancel dragging
                if (self.scrollView.isDragging) {
                        self.scrollView.scrollEnabled = NO;
                        self.scrollView.scrollEnabled = YES;
                }
                
                [UIView animateWithDuration:0.15 animations:^{
                        // Set the final frame.
                        // If user drag scrollView very quickly, frame set in `contentOffset` KVO will not
                        // always be correct.
                        CGRect frame = CGRectMake(0., -self.contentViewHeight, self.frame.size.width, self.contentViewHeight);
                        self.frame = frame;
                        
                        UIEdgeInsets contentInset = self.scrollView.contentInset;
                        contentInset.top += self.height;
                        self.scrollView.contentInset = contentInset;

                } completion:^(BOOL finished) {
                        if (self.didUpdateScrollViewsContentInsetBlock) {
                                self.didUpdateScrollViewsContentInsetBlock(self, self.scrollView);
                        }
                        
                        if (self.didStartRefreshingBlock) {
                                self.didStartRefreshingBlock(self);
                        }
                }];
                
        } else {
                if (ESRefreshControlStateRefreshing != self.state) {
                        return;
                }
                self.state = ESRefreshControlStateNormal;
                
                // Cancel dragging
                if (self.scrollView.isDragging) {
                        self.scrollView.scrollEnabled = NO;
                        self.scrollView.scrollEnabled = YES;
                }
                
                self.frame = CGRectMake(0., 0., self.frame.size.width, 0.);
                UIEdgeInsets contentInset = self.scrollView.contentInset;
                contentInset.top -= self.contentViewHeight;
                self.scrollView.contentInset = contentInset;
                
                if (self.didUpdateScrollViewsContentInsetBlock) {
                        self.didUpdateScrollViewsContentInsetBlock(self, self.scrollView);
                }
        }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
        if (object != self.scrollView || context != _esRefreshControlKVOContext) {
                return;
        }
        
        if (![keyPath isEqualToString:@"contentOffset"]) {
                return;
        }
        
        CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue];
        CGFloat pullDownHeight = -offset.y - self.scrollView.contentInset.top;
        //NSLog(@"offset.y(%f) contentInset.top(%f) pullHeight(%f) isDragging(%d) self.frame(%@)", offset.y, self.scrollView.contentInset.top, pullDownHeight, self.scrollView.isDragging, NSStringFromCGRect(self.frame));
        
        // Set correct frame
        if (pullDownHeight >= 0) {
                CGRect frame = self.frame;
                frame.origin.y = -pullDownHeight;
                if (ESRefreshControlStateRefreshing == self.state) {
                        frame.origin.y -= self.contentViewHeight;
                } else {
                        if (pullDownHeight <= self.contentViewHeight) {
                                frame.size.height = pullDownHeight;
                        }
                }
                self.frame = frame;
        } else {
                return;
        }
        
        if (self.scrollView.isDragging) {
                if (ESRefreshControlStateNormal == self.state) {
                        // Update the content view's pulling progress
                        [self _setPullProgress:(pullDownHeight / self.contentViewHeight)];
                        
                        // Dragged enough to be ready
                        if (pullDownHeight > self.contentViewHeight) {
                                self.state = ESRefreshControlStateTriggered;
                        }
                } else if (ESRefreshControlStateTriggered == self.state) {
                        [self _setPullProgress:(pullDownHeight / self.contentViewHeight)];
                        
                        if (pullDownHeight <= self.contentViewHeight) {
                                self.state = ESRefreshControlStateNormal;
                        }
                } else if (ESRefreshControlStateRefreshing == self.state) {
                        
                }
                
                return;
        } else if (self.scrollView.isDecelerating) {
                if (ESRefreshControlStateNormal == self.state) {
                        // Update the content view's pulling progress
                        [self _setPullProgress:(pullDownHeight / self.contentViewHeight)];
                        
                } else if (ESRefreshControlStateTriggered == self.state) {
                        [self _setRefreshing:YES];
                } else if (ESRefreshControlStateRefreshing == self.state) {
                        
                }
        }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public Methods

- (void)beginRefreshing
{
        [self _setRefreshing:YES];
}

- (void)endRefreshing
{
        [self _setRefreshing:NO];
}

- (BOOL)isRefreshing
{
        return (ESRefreshControlStateRefreshing == self.state);
}

- (NSString *)textForState:(ESRefreshControlState)state
{
        if (self.textForStateBlock) {
                return self.textForStateBlock(self, state);
        }
        return nil;
}

@end
