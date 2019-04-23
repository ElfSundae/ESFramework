//
//  ESWeakProxy.h
//  ESFramework
//
//  Created by Elf Sundae on 2019/04/22.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 * ESWeakProxy can be used to hold a weak object. It also can be used to avoid
 * retain cycles, for example, setting a ESWeakProxy instance to the target of
 * the NSTimer or CADisplayLink instance.
 */
@interface ESWeakProxy : NSProxy

@property (nonatomic, weak, readonly) __weak id target;

- (instancetype)initWithTarget:(id)target;
+ (instancetype)proxyWithTarget:(id)target;

@end
