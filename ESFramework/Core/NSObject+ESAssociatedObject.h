//
//  NSObject+ESAssociatedObject.h
//  ESFramework
//
//  Created by Elf Sundae on 4/18/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ESDefines.h"

/**
 *
 *
 @code
 
 @interface SomeClass (additions)
 @property (nonatomic, es_weak_property) __es_weak id<SomeDelegate> delegate;
 @property (nonatomic, strong) UIView *view;
 @end
 
 // SomeClass+additions.m
 
 static char _delegateKey;
 static char _viewKey;
 
 @implementation SomeClass (additions)
 - (id<SomeDelegate>)delegate
 {
        return [self getAssociatedObject:&_delegateKey];
 }
 - (void)setDelegate:(id<SomeDelegate>)delegate
 {
        [self setAssociatedObject_nonatomic_weak:delegate key:&_delegateKey];
 }
 - (UIView *)view
 {
        return [self getAssociatedObject:&_viewKey];
 }
 - (void)setView:(UIView *)view
 {
        [self setAssociatedObject_nonatomic_retain:view key:&_viewKey];
 }
 @end
 
 @endcode
 */

@interface NSObject (ESAssociatedObject)

- (id)getAssociatedObject:(const void *)key;
- (void)setAssociatedObject_nonatomic_weak:(__es_weak id)weakObject key:(const void *)key;
- (void)setAssociatedObject_nonatomic_retain:(id)object key:(const void *)key;
- (void)setAssociatedObject_nonatomic_copy:(id)object key:(const void *)key;
- (void)setAssociatedObject_atomic_retain:(id)object key:(const void *)key;
- (void)setAssociatedObject_atomic_copy:(id)object key:(const void *)key;

@end
