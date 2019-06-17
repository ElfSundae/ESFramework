//
//  NSURL+ESExtension.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-13.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "NSURL+ESExtension.h"
#import "NSURLComponents+ESExtension.h"

@implementation NSURL (ESExtension)

- (NSDictionary<NSString *, id> *)queryParameters
{
    return [NSURLComponents componentsWithURL:self resolvingAgainstBaseURL:YES].queryParameters;
}

- (NSURL *)URLByAddingQueryParameters:(NSDictionary<NSString *, id> *)parameters
{
    NSURLComponents *components = [NSURLComponents componentsWithURL:self resolvingAgainstBaseURL:YES];
    [components addQueryParameters:parameters];
    return components.URL;
}

@end
