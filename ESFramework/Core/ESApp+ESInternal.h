//
//  ESApp+ESInternal.h
//  ESFramework
//
//  Created by Elf Sundae on 4/21/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESApp.h"

@interface ESApp ()
@property (nonatomic, copy) ESHandlerBlock _remoteNotificationRegisterResultHandler;
@end


@interface ESApp (ESInternal)
/**
 * Private method: Returns YES if the AppDelegate class is inherited from this class.
 */
+ (BOOL)_isUIApplicationDelegate;

@end
