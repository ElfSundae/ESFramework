//
//  NSObject+ESAssociatedObject.m
//  ESFramework
//
//  Created by Elf Sundae on 4/18/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "NSObject+ESAssociatedObject.h"
#import <objc/runtime.h>

@interface _ESWeakAssociatedObject : NSObject
@property (nonatomic, es_weak_property) __es_weak id weakObject;
@end
@implementation _ESWeakAssociatedObject
@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation NSObject (ESAssociatedObject)

- (id)getAssociatedObject:(const void *)key
{
        id obj = objc_getAssociatedObject(self, key);
        if ([obj isKindOfClass:[_ESWeakAssociatedObject class]]) {
                obj = [(_ESWeakAssociatedObject *)obj weakObject];
        }
        return obj;
}

- (void)setAssociatedObject_nonatomic_weak:(__es_weak id)weakObject key:(const void *)key
{
        _ESWeakAssociatedObject *object = objc_getAssociatedObject(self, key);
        if (!object) {
                object = [[_ESWeakAssociatedObject alloc] init];
                [self setAssociatedObject_nonatomic_retain:object key:key];
        }
        object.weakObject = weakObject;
}

- (void)setAssociatedObject_nonatomic_retain:(id)object key:(const void *)key
{
        objc_setAssociatedObject(self, key, object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)setAssociatedObject_nonatomic_copy:(id)object key:(const void *)key
{
        objc_setAssociatedObject(self, key, object, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)setAssociatedObject_atomic_retain:(id)object key:(const void *)key
{
        objc_setAssociatedObject(self, key, object, OBJC_ASSOCIATION_RETAIN);
}
- (void)setAssociatedObject_atomic_copy:(id)object key:(const void *)key
{
        objc_setAssociatedObject(self, key, object, OBJC_ASSOCIATION_COPY);
}

- (void)removeAllAssociatedObjects
{
        objc_removeAssociatedObjects(self);
}

@end
