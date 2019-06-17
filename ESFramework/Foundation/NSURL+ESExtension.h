//
//  NSURL+ESExtension.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-13.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURL (ESExtension)

/**
 * Returns the URL query parameters.
 */
- (nullable NSDictionary<NSString *, id> *)queryParameters;

/**
 * Returns a newly created URL added the given query parameters.
 */
- (NSURL *)URLByAddingQueryParameters:(NSDictionary<NSString *, id> *)parameters;

@end

NS_ASSUME_NONNULL_END
