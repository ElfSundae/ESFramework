//
//  NSURL+ESExtension.m
//  ESFramework
//
//  Created by Elf Sundae on 2014/04/13.
//  Copyright © 2014 https://0x123.com. All rights reserved.
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
