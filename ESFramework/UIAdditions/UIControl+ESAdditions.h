//
//  UIControl+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 4/18/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ESUIControlHandler)(id sender, UIControlEvents controlEvent);

/**
 * Block ways to invoke `-addTarget:action:forControlEvents`.
 */
@interface UIControl (ESAdditions)

/**
 * Add event `handler` for `controlEvents`.
 */
- (void)addEventHandler:(ESUIControlHandler)handler forControlEvents:(UIControlEvents)controlEvents;

/**
 * Remove event handlers which added by block way.
 */
- (void)removeEventHandlersForControlEvents:(UIControlEvents)controlEvents;
/**
 * Remove all event handlers, including block way and `-addTarget:action:forControlEvents`
 */
- (void)removeAllEventHandlersAndTargetsActions;
/**
 * Checks whether any block handler exists for given `controlEvents`.
 */
- (BOOL)existsEventHandlersForControlEvents:(UIControlEvents)controlEvents;

@end
