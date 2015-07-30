//
//  ESApp+Private.h
//  ESFramework
//
//  Created by Elf Sundae on 5/23/15.
//  Copyright (c) 2015 www.0x123.com. All rights reserved.
//

#import "ESApp.h"

@interface _ESAppInternalWebViewDelegate : NSObject  <UIWebViewDelegate>
@end

@interface ESApp ()
{
        ESHandlerBlock _esRemoteNotificationRegisterSuccessBlock;
        ESHandlerBlock _esRemoteNotificationRegisterFailureBlock;
        NSString *_esWebViewDefaultUserAgent;
}

@end

