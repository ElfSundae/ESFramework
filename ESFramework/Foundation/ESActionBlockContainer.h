//
//  ESActionBlockContainer.h
//  ESFramework
//
//  Created by Elf Sundae on 2019/05/23.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ESActionBlockContainer : NSObject

@property (nullable, nonatomic, copy) void (^block)(id sender);

- (instancetype)initWithBlock:(void (^ _Nullable)(id sender))block;
- (void)invoke:(id)sender;

@property (nonatomic, readonly) SEL action;
@property (class, nonatomic, readonly) SEL action;

@end

NS_ASSUME_NONNULL_END
