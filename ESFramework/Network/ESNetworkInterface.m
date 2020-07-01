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

@end

@implementation ESNetworkInterface

- (instancetype)initWithName:(NSString *)name
                 IPv4Address:(nullable NSString *)IPv4Address
                 IPv6Address:(nullable NSString *)IPv6Address
{
    self = [super init];
    if (self) {
        self.name = name;
        self.IPv4Address = IPv4Address;
        self.IPv6Address = IPv6Address;
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name
{
    return [self initWithName:name IPv4Address:nil IPv6Address:nil];
}

- (NSString *)description
{
    NSMutableString *desc = [NSMutableString stringWithFormat:@"%@:", self.name];
    if (self.IPv4Address) {
        [desc appendFormat:@" %@", self.IPv4Address];
    }
    if (self.IPv6Address) {
        [desc appendFormat:@" %@", self.IPv6Address];
    }
    return desc;
}

@end
