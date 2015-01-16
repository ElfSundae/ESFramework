//
//  ESApp+Internal.h
//  ESFramework
//
//  Created by Elf Sundae on 14-12-16.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import "ESApp.h"
#import "ESDefines.h"

@interface ESApp ()
{
        ESHandlerBlock _remoteNotificationRegisterSuccessBlock;
        ESHandlerBlock _remoteNotificationRegisterFailureBlock;
}

@end

@interface ESApp (Internal)
/**
 * Returns YES if the AppDelegate class is inherited from ESApp.
 */
+ (BOOL)_isUIApplicationDelegate;

@end

