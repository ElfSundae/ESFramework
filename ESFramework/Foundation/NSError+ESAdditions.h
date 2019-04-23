//
//  NSError+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 5/21/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (ESAdditions)

/**
 * The `description` is stored in userInfo.NSLocalizedDescriptionKey.
 */
+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code description:(NSString *)description;

/**
 * Set the NSLocalizedDescriptionKey and the NSLocalizedFailureReasonErrorKey for userInfo.
 */
+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code description:(NSString *)description failureReason:(NSString *)failureReason;

/**
 * Determined if it is a local network error.
 *
 * NSURLErrorDomain with following code:
 *      NSURLErrorTimedOut
 *      NSURLErrorCannotFindHost
 *      NSURLErrorCannotConnectToHost
 *      NSURLErrorNetworkConnectionLost
 *      NSURLErrorDNSLookupFailed
 *      NSURLErrorNotConnectedToInternet
 *
 */
- (BOOL)isLocalNetworkError;

@end
