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

- (void)scrollToTop:(BOOL)animated
{
    [self setContentOffset:CGPointZero animated:animated];
}

- (void)scrollToBottom:(BOOL)animated
{
    if (self.contentSize.height > self.bounds.size.height) {
        CGFloat offsetY = self.contentSize.height - self.bounds.size.height;
        [self setContentOffset:CGPointMake(0, offsetY) animated:animated];
    }
}

- (void)scrollToFirstRow:(BOOL)animated
{
    NSIndexPath *indexPath = nil;
    for (NSInteger section = 0; self.numberOfSections > section; ++section) {
        if ([self numberOfRowsInSection:section] > 0) {
            indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
            break;
        }
    }

    if (indexPath) {
        [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:animated];
    }
}

- (void)scrollToLastRow:(BOOL)animated
{
    NSIndexPath *indexPath = nil;
    for (NSInteger section = self.numberOfSections - 1; section >= 0; --section) {
        NSInteger rowsCount = [self numberOfRowsInSection:section];
        if (rowsCount > 0) {
            indexPath = [NSIndexPath indexPathForRow:rowsCount - 1 inSection:section];
            break;
        }
    }
    
    if (indexPath) {
        [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:animated];
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
