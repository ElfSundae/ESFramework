//
//  ESFramework.h
//  ESFramework
//
//  Created by Elf Sundae on 2014/04/13.
//  Copyright (c) 2014 https://0x123.com All rights reserved.
//

#import <TargetConditionals.h>

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
