//
//  UIScrollView+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 2019/05/16.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import "UIScrollView+ESAdditions.h"

@implementation UIScrollView (ESAdditions)

- (void)scrollToTop:(BOOL)animated
{
    CGPoint offset = self.contentOffset;
    offset.y = -self.contentInset.top;
    [self setContentOffset:offset animated:animated];
}

- (void)scrollToBottom:(BOOL)animated
{
    CGPoint offset = self.contentOffset;
    offset.y = self.contentSize.height - self.bounds.size.height + self.contentInset.bottom;
    [self setContentOffset:offset animated:animated];
}

- (void)scrollToLeft:(BOOL)animated
{
    CGPoint offset = self.contentOffset;
    offset.x = -self.contentInset.left;
    [self setContentOffset:offset animated:animated];
}

- (void)scrollToRight:(BOOL)animated
{
    CGPoint offset = self.contentOffset;
    offset.x = self.contentSize.width - self.bounds.size.width + self.contentInset.right;
    [self setContentOffset:offset animated:animated];
}

@end
