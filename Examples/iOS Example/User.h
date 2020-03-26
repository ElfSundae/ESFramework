//
//  User.h
//  Example
//
//  Created by Elf Sundae on 2019/04/15.
//  Copyright © 2014-2020 https://0x123.com All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject <NSCopying>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int age;
@property (nonatomic, strong) NSDictionary *dict;

// @property (nonatomic, assign) double addedDouble;
// @property (nonatomic, copy) NSURL *addedURL;

@end
