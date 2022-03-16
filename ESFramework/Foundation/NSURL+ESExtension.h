//
//  NSURL+ESExtension.h
//  ESFramework
//
//  Created by Elf Sundae on 2014/04/13.
//  Copyright © 2014-2020 https://0x123.com All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURL (ESExtension)

/**
 * Returns the URL query parameters.
 */
- (nullable NSDictionary<NSString *, id> *)es_queryParameters;

/**
 * Returns a newly created URL added the given query parameters.
 */
- (NSURL *)URLByAddingQueryParameters:(NSDictionary<NSString *, id> *)parameters;

@end

NS_ASSUME_NONNULL_END
