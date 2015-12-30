//
//  UITableViewCell+ESTableViewAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 5/21/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESTableViewController.h"
#import "ESDefines.h"
#import "ESValue.h"

ESDefineAssociatedObjectKey(cellData);
ESDefineAssociatedObjectKey(cellIndexPath);
ESDefineAssociatedObjectKey(isFirstRowInSection);
ESDefineAssociatedObjectKey(isLastRowInSection);

@implementation UITableViewCell (ESTableViewAdditions)

- (id)cellData
{
        return ESGetAssociatedObject(self, cellDataKey);
}
- (void)setCellData:(id)cellData
{
        ESSetAssociatedObject(self, cellDataKey, cellData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSIndexPath *)cellIndexPath
{
        return ESGetAssociatedObject(self, cellIndexPathKey);
}

- (void)setCellIndexPath:(NSIndexPath *)cellIndexPath
{
        ESSetAssociatedObject(self, cellIndexPathKey, cellIndexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isFirstRowInSection
{
        return ESBoolValue(ESGetAssociatedObject(self, isFirstRowInSectionKey));
}

- (void)setIsFirstRowInSection:(BOOL)isFirstRowInSection
{
        ESSetAssociatedObject(self, isFirstRowInSectionKey, @(isFirstRowInSection), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isLastRowInSection
{
        return ESBoolValue(ESGetAssociatedObject(self, isLastRowInSectionKey));
}
- (void)setIsLastRowInSection:(BOOL)isLastRowInSection
{
        ESSetAssociatedObject(self, isLastRowInSectionKey, @(isLastRowInSection), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
