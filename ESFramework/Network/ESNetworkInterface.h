//
//  ESNetworkInterface.h
//  ESFramework
//
//  Created by Elf Sundae on 2020/06/30.
//  Copyright © 2020 https://0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ESNetworkInterface : NSObject

@property (nonatomic, copy, readonly) NSString *name;
@property (nullable, nonatomic, copy) NSString *IPv4Address;
@property (nullable, nonatomic, copy) NSString *IPv6Address;

- (instancetype)initWithName:(NSString *)name
                 IPv4Address:(nullable NSString *)IPv4Address
                 IPv6Address:(nullable NSString *)IPv6Address NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithName:(NSString *)name;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
