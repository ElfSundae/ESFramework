//
//  UITableView+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 5/19/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "UITableView+ESAdditions.h"
#import "UIView+ESAdditions.h"

@implementation UITableView (ESAdditions)

- (void)performBatchUpdates:(void (NS_NOESCAPE ^ _Nullable)(void))updates
{
    if (@available(iOS 11.0, *)) {
        [self performBatchUpdates:updates completion:nil];
    } else {
        [self beginUpdates];
        if (updates) {
            updates();
        }
        [self endUpdates];
    }
}

- (void)scrollToFirstResponderAnimated:(BOOL)animated atScrollPosition:(UITableViewScrollPosition)scrollPosition
{
    UIView *responder = [self.window findFirstResponder];
    UITableViewCell *cell = (UITableViewCell *)[responder findSuperviewOf:[UITableViewCell class]];
    if (cell) {
        NSIndexPath *indexPath = [self indexPathForCell:cell];
        if (indexPath) {
            [self scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
        }
    }
}

- (void)touchRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition
{
    if (![self cellForRowAtIndexPath:indexPath]) {
        return;
    }

    if ([self.delegate respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)]) {
        [self.delegate tableView:self willSelectRowAtIndexPath:indexPath];
    }

    [self selectRowAtIndexPath:indexPath animated:animated scrollPosition:scrollPosition];

    if ([self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.delegate tableView:self didSelectRowAtIndexPath:indexPath];
    }
}

- (void)setVisibleCellsNeedDisplay
{
    [self.visibleCells makeObjectsPerformSelector:@selector(setNeedsDisplay)];
}

- (void)setVisibleCellsNeedLayout
{
    [self.visibleCells makeObjectsPerformSelector:@selector(setNeedsLayout)];
}

@end
