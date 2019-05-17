//
//  UITableView+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 5/19/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (ESAdditions)

/**
 * Animates multiple insert, delete, reload, and move operations as a group.
 */
- (void)performBatchUpdates:(void (NS_NOESCAPE ^ _Nullable)(void))updates;

- (void)scrollToFirstResponderAnimated:(BOOL)animated atScrollPosition:(UITableViewScrollPosition)scrollPosition;

- (void)touchRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition;

- (void)setVisibleCellsNeedDisplay;
- (void)setVisibleCellsNeedLayout;

@end

NS_ASSUME_NONNULL_END
