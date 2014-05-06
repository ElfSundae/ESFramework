//
//  ESRouterOptions.m
//  ESFramework
//
//  Created by Elf Sundae on 5/5/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESRouter.h"

@interface ESRouterObject ()
@property (nonatomic, strong, readwrite) Class openClass;
@end

@implementation ESRouterObject

- (instancetype)init
{
        self = [super init];
        if (self) {
                self.modal = YES;
                self.animated = YES;
        }
        return self;
}

+ (instancetype)objectWithClass:(NSString *)className
{
        return [self objectWithClass:className isModal:YES isRoot:NO];
}

+ (instancetype)objectWithClass:(NSString *)className isModal:(BOOL)isModal isRoot:(BOOL)isRoot
{
        ESRouterObject *object = [[ESRouterObject alloc] init];
        object.openClassName = className;
        object.modal = isModal;
        if (!object.isModal) {
                object.root = isRoot;
        }
        return object;
}

+ (instancetype)objectWithBlock:(ESRouterOpenBlock)openBlock
{
        ESRouterObject *object = [[ESRouterObject alloc] init];
        object.openBlock = openBlock;
        return object;
}

- (Class)openClass
{
        if (!_openClass) {
                _openClass = NSClassFromString(_openClassName);
        }
        return _openClass;
}
@end
