//
//  ESWeakProxy.h
//  ESFramework
//
//  Created by Elf Sundae on 2019/04/22.
//  Copyright © 2019 https://0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * ESWeakProxy can be used to hold a weak object.
 *
 * Usage #1:
 * Access an associated object with "zeroing weak reference".
 * @code
 * // a weak property in the category
 * @property (nonatomic, weak) id<SomeProtocol> delegate;
 *
 * // setter
 * objc_setAssociatedObject(
 *     self,
 *     delegateKey,
 *     delegate ? [ESWeakProxy proxyWithTarget:delegate] : nil,
 *     OBJC_ASSOCIATION_RETAIN_NONATOMIC
 * );
 *
 * // getter
 * [(ESWeakProxy *)objc_getAssociatedObject(self, delegateKey) target];
 * @endcode
 *
 * Usage #2:
 * Avoid retain cycles, such as the target of the NSTimer or CADisplayLink instance.
 * @code
 * self.timer = [NSTimer scheduledTimerWithTimeInterval:10
 *                     target:[ESWeakProxy proxyWithTarget:self]
 *                     selector:@selector(timerAction:)
 *                     userInfo:nil
 *                     repeats:YES];
 * @endcode
 */
@interface ESWeakProxy : NSProxy

@property (nonatomic, weak, readonly) id target;

- (instancetype)initWithTarget:(id)target;
+ (instancetype)proxyWithTarget:(id)target;

@end

NS_ASSUME_NONNULL_END
