//
//  ESFramework.h
//  ESFramework
//
//  Created by Elf Sundae on 2014/04/02.
//  Copyright © 2014-2019 https://0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for ESFramework.
FOUNDATION_EXPORT double ESFrameworkVersionNumber;

//! Project version string for ESFramework.
FOUNDATION_EXPORT const unsigned char ESFrameworkVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <ESFramework/PublicHeader.h>

#import <TargetConditionals.h>

#if __has_include(<ESFramework/ESMacros.h>)

#import <ESFramework/ESMacros.h>
#import <ESFramework/ESHelpers.h>
#import <ESFramework/ESWeakProxy.h>
#import <ESFramework/NSInvocation+ESExtension.h>
#import <ESFramework/NSNumber+ESExtension.h>

#import <ESFramework/ESActionBlockContainer.h>
#import <ESFramework/NSArray+ESExtension.h>
#import <ESFramework/NSCharacterSet+ESExtension.h>
#import <ESFramework/NSData+ESExtension.h>
#import <ESFramework/NSDate+ESExtension.h>
#import <ESFramework/NSDateFormatter+ESExtension.h>
#import <ESFramework/NSDictionary+ESExtension.h>
#import <ESFramework/NSError+ESExtension.h>
#import <ESFramework/NSFileManager+ESExtension.h>
#import <ESFramework/NSHTTPCookieStorage+ESExtension.h>
#import <ESFramework/NSMapTable+ESExtension.h>
#import <ESFramework/NSObject+ESAutoCoding.h>
#import <ESFramework/NSOrderedSet+ESExtension.h>
#import <ESFramework/NSString+ESExtension.h>
#import <ESFramework/NSString+ESGTMHTML.h>
#import <ESFramework/NSTimer+ESExtension.h>
#import <ESFramework/NSURL+ESExtension.h>
#import <ESFramework/NSURLComponents+ESExtension.h>
#import <ESFramework/NSUserDefaults+ESExtension.h>

#if !TARGET_OS_WATCH
#import <ESFramework/ESNetworkHelper.h>
#endif

#if TARGET_OS_IOS || TARGET_OS_TV
#import <ESFramework/UIAlertController+ESExtension.h>
#import <ESFramework/UIApplication+ESExtension.h>
#import <ESFramework/UIBarButtonItem+ESExtension.h>
#import <ESFramework/UIColor+ESExtension.h>
#import <ESFramework/UIControl+ESExtension.h>
#import <ESFramework/UIDevice+ESExtension.h>
#import <ESFramework/UIGestureRecognizer+ESExtension.h>
#import <ESFramework/UIImage+ESExtension.h>
#import <ESFramework/UIImageView+ESExtension.h>
#import <ESFramework/UIScrollView+ESExtension.h>
#import <ESFramework/UITableView+ESExtension.h>
#import <ESFramework/UIToolbar+ESExtension.h>
#import <ESFramework/UIView+ESExtension.h>
#import <ESFramework/UIViewController+ESExtension.h>
#import <ESFramework/UIWindow+ESExtension.h>
#endif

#else

#import "ESMacros.h"
#import "ESHelpers.h"
#import "ESWeakProxy.h"
#import "NSInvocation+ESExtension.h"
#import "NSNumber+ESExtension.h"

#import "ESActionBlockContainer.h"
#import "NSArray+ESExtension.h"
#import "NSCharacterSet+ESExtension.h"
#import "NSData+ESExtension.h"
#import "NSDate+ESExtension.h"
#import "NSDateFormatter+ESExtension.h"
#import "NSDictionary+ESExtension.h"
#import "NSError+ESExtension.h"
#import "NSFileManager+ESExtension.h"
#import "NSHTTPCookieStorage+ESExtension.h"
#import "NSHTTPURLResponse+ESExtension.h"
#import "NSMapTable+ESExtension.h"
#import "NSObject+ESAutoCoding.h"
#import "NSOrderedSet+ESExtension.h"
#import "NSString+ESExtension.h"
#import "NSString+ESGTMHTML.h"
#import "NSTimer+ESExtension.h"
#import "NSURL+ESExtension.h"
#import "NSURLComponents+ESExtension.h"
#import "NSUserDefaults+ESExtension.h"

#if !TARGET_OS_WATCH
#import "ESNetworkHelper.h"
#endif

#if TARGET_OS_IOS || TARGET_OS_TV
#import "UIAlertController+ESExtension.h"
#import "UIApplication+ESExtension.h"
#import "UIBarButtonItem+ESExtension.h"
#import "UIColor+ESExtension.h"
#import "UIControl+ESExtension.h"
#import "UIDevice+ESExtension.h"
#import "UIGestureRecognizer+ESExtension.h"
#import "UIImage+ESExtension.h"
#import "UIImageView+ESExtension.h"
#import "UIScrollView+ESExtension.h"
#import "UITableView+ESExtension.h"
#import "UIToolbar+ESExtension.h"
#import "UIView+ESExtension.h"
#import "UIViewController+ESExtension.h"
#import "UIWindow+ESExtension.h"
#endif

#endif
