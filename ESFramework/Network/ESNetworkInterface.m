//
//  ESNetworkInterface.m
//  ESFramework
//
//  Created by Elf Sundae on 2020/06/30.
//  Copyright © 2020 https://0x123.com. All rights reserved.
//

#import "ESNetworkInterface.h"

@interface ESNetworkInterface ()

@property (nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *IPv4Address;
@property (nullable, nonatomic, copy) NSString *IPv6Address;

@end

@implementation ESNetworkInterface

- (instancetype)initWithName:(NSString *)name IPv4Address:(NSString *)IPv4Address IPv6Address:(NSString *)IPv6Address
{
    self = [super init];
    if (self) {
        self.name = name;
        self.IPv4Address = IPv4Address;
        self.IPv6Address = IPv6Address;
    }
    return self;
}

@end
