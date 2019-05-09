//
//  User.h
//  Example
//
//  Created by Elf Sundae on 2019/04/15.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import <ESFramework/ESFramework.h>

@interface User : NSObject <NSCopying>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int age;
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, strong) NSDictionary *dict;

// @property (nonatomic, assign) double addedDouble;
// @property (nonatomic, copy) NSURL *addedURL;

@end
