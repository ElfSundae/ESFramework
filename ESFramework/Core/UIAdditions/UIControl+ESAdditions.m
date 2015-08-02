//
//  UIControl+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 4/18/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "UIControl+ESAdditions.h"
#import "ESDefines.h"

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - _ESUIControlHandlerWrapper
@interface _ESUIControlHandlerWrapper : NSObject
- (instancetype)initWithHandler:(ESUIControlHandler)handler forControlEvents:(UIControlEvents)controlEvents;
@property (nonatomic, copy) ESUIControlHandler handler;
@property (nonatomic, assign) UIControlEvents controlEvents;
- (void)invoke:(id)sender;
@end

@implementation _ESUIControlHandlerWrapper
- (instancetype)initWithHandler:(ESUIControlHandler)handler forControlEvents:(UIControlEvents)controlEvents
{
        self = [super init];
        if (self) {
                self.handler = handler;
                self.controlEvents = controlEvents;
        }
        return self;
}
- (void)invoke:(id)sender
{
        self.handler(sender, self.controlEvents);
}
@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIControl+__ESAdditionsInternal

@interface UIControl (__ESAdditionsInternal)
@property (nonatomic, strong) NSMutableDictionary *__es_Events;
@end

static const void *__es_EventsKey = &__es_EventsKey;

@implementation UIControl (__ESAdditionsInternal)
- (NSMutableDictionary *)__es_Events
{
        NSMutableDictionary *dict = (NSMutableDictionary *)ESGetAssociatedObject(self, __es_EventsKey);
        if (!dict) {
                dict = [NSMutableDictionary dictionary];
                [self set__es_Events:dict];
        }
        return dict;
}

- (void)set__es_Events:(NSMutableDictionary *)events
{
        ESSetAssociatedObject(self, __es_EventsKey, events, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIControl+ESAdditions

@implementation UIControl (ESAdditions)

/**
 * Just support a single controlEvent.
 */
- (void)_es_addEventHandler:(ESUIControlHandler)handler forControlEvents:(UIControlEvents)controlEvents
{
        NSNumber *key = @(controlEvents);
        NSMutableSet *wrappers = self.__es_Events[key];
        if (!wrappers) {
                wrappers = [NSMutableSet set];
                self.__es_Events[key] = wrappers;
        }
        _ESUIControlHandlerWrapper *target = [[_ESUIControlHandlerWrapper alloc] initWithHandler:handler forControlEvents:controlEvents];
        [wrappers addObject:target];
        [self addTarget:target action:@selector(invoke:) forControlEvents:controlEvents];
}

- (void)addEventHandler:(ESUIControlHandler)handler forControlEvents:(UIControlEvents)controlEvents
{
        NSParameterAssert(handler);
        for (NSUInteger i = 0, event = (1 << i);
             event <= UIControlEventEditingDidEndOnExit;
             event = 1 << ++i)
        {
                if (9 == i || 10 == i || 11 == i ||
                    13 == i || 14 == i || 15 == i) {
                        continue;
                }
                
                if (ESMaskIsSet(controlEvents, event)) {
                        [self _es_addEventHandler:handler forControlEvents:event];
                }
        }
}

- (void)_es_removeEventHandlersForControlEvents:(UIControlEvents)controlEvents
{
        NSNumber *key = @(controlEvents);
        NSMutableSet *wrappers = self.__es_Events[key];
        if (!wrappers) {
                return;
        }
        for (id target in wrappers) {
                [self removeTarget:target action:NULL forControlEvents:controlEvents];
        }
        [self.__es_Events removeObjectForKey:key];
}

- (void)removeEventHandlersForControlEvents:(UIControlEvents)controlEvents
{
        for (NSUInteger i = 0, event = (1 << i); event <= UIControlEventEditingDidEndOnExit; event = 1 << ++i) {
                if (9 == i || 10 == i || 11 == i ||
                    13 == i || 14 == i || 15 == i) {
                        continue;
                }
                
                if (ESMaskIsSet(controlEvents, event)) {
                        [self _es_removeEventHandlersForControlEvents:event];
                }
        }
}

- (void)removeAllEventHandlersAndTargetsActions
{
        [self removeEventHandlersForControlEvents:UIControlEventAllEvents];
        [self removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
}

- (BOOL)existsEventHandlersForControlEvents:(UIControlEvents)controlEvents
{
        NSMutableSet *wrappers = self.__es_Events[@(controlEvents)];
        return !![wrappers count];
}


@end
