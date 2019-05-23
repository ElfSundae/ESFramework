//
//  UIBarButtonItem+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 2019/05/23.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBarButtonItem (ESAdditions)

@property (nullable, nonatomic, copy) void (^actionBlock)(UIBarButtonItem *barButtonItem);

@end

NS_ASSUME_NONNULL_END
