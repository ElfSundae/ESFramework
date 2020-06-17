//
//  NSObject+ESExtension.h
//  ESFramework
//
//  Created by Elf Sundae on 2019/11/9.
//  Copyright © 2014-2020 https://0x123.com All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ESExtension)

/**
 * Adds the receiver as an observer to the notification center's dispatch table.
 * @discussion If your app targets iOS 9.0 and later or macOS 10.11 and later,
 * you don't need to unregister an observer in its dealloc method. Otherwise,
 * you should call \c removeObserver:name:object: before observer or any object
 * received to this method is deallocated.
 */
- (void)observeNotification:(NSNotificationName)name selector:(SEL)selector;

/**
 * Adds the receiver as an observer to the notification center's dispatch table.
 * @discussion If your app targets iOS 9.0 and later or macOS 10.11 and later,
 * you don't need to unregister an observer in its dealloc method. Otherwise,
 * you should call \c removeObserver:name:object: before observer or any object
 * received to this method is deallocated.
 */
- (void)observeNotification:(nullable NSNotificationName)name object:(nullable id)object selector:(SEL)selector;

@end

NS_ASSUME_NONNULL_END
