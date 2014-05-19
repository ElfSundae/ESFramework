//
//  UITableView+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 5/19/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "UITableView+ESAdditions.h"
#import "ESDefines.h"
#import "UIView+ESAdditions.h"

@implementation UITableView (ESAdditions)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -

- (void)scrollToTop:(BOOL)animated
{
        [self setContentOffset:CGPointZero animated:animated];
}

- (void)scrollToBottom:(BOOL)animated
{
        CGFloat offsetY = 0.f;
        if (self.contentSize.height > self.bounds.size.height) {
                offsetY = self.contentSize.height - self.bounds.size.height;
        }
        [self setContentOffset:CGPointMake(0.f, offsetY) animated:animated];
}

- (void)scrollToFirstRow:(BOOL)animated
{
        if (self.numberOfSections > 0 && [self numberOfRowsInSection:0] > 0) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:animated];
        }
}

- (void)scrollToLastRow:(BOOL)animated
{
        if (self.numberOfSections > 0) {
                NSInteger section = self.numberOfSections - 1;
                NSInteger rowCount = [self numberOfRowsInSection:section];
                if (rowCount > 0) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowCount - 1 inSection:section];
                        [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:animated];
                }
        }
}

- (void)scrollToFirstResponderAnimated:(BOOL)animated atScrollPosition:(UITableViewScrollPosition)scrollPosition
{
        UIView *responder = [self.window findFirstResponder];
        UITableViewCell *cell = (UITableViewCell *)[responder findViewWithClass:[UITableViewCell class] shouldSearchInSuperview:YES];
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

@end