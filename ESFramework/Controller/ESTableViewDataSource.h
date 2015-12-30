//
//  ESTableViewDataSource.h
//  ESFramework
//
//  Created by Elf Sundae on 5/20/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ESTableViewDataSource <UITableViewDataSource>

@optional

/**
 * Returns the data for cell.
 */
- (id)tableView:(UITableView *)tableView cellDataForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 * Returns `UITableViewCell` subclass, tableView will use `UITableViewCell` class if this method is not
 * implemented or returned `nil`.
 */
- (Class)tableView:(UITableView *)tableView cellClassForRowAtIndexPath:(NSIndexPath *)indexPath cellData:(id)cellData;

/**
 * Alloc the cell instance with `cellClass` and `reuseIdentifier`.
 * Default implementation:
 * @code
 * return [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
 * @endcode
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellNewInstanceForRowAtIndexPath:(NSIndexPath *)indexPath cellClass:(Class)cellClass reuseIdentifier:(NSString *)reuseIdentifier;

/**
 * Invoked within `-tableView:cellForRowAtIndexPath:`.
 */
- (void)tableView:(UITableView *)tableView configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath cellData:(id)cellData;

@end