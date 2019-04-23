//
//  ESDefines.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-2.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#ifndef ESFramework_ESMacros_h
#define ESFramework_ESMacros_h

#import "ESHelpers.h"
#import "NSInvocation+ESHelper.h"

#if (!defined(NSLog))
#if DEBUG
#define NSLog(fmt, ...) NSLog((@"%@:%d %s " fmt), [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__)
#else
#define NSLog(fmt, ...)
#endif
#endif

#if (!defined(NSLogIf))
#if DEBUG
#define NSLogIf(condition, fmt, ...) if ((condition)) { NSLog(fmt, ##__VA_ARGS__); }
#else
#define NSLogIf(condition, fmt, ...)
#endif
#endif

/**
 * Make weak references to break "retain cycles".
 */
#define ESWeak(var)     __weak __typeof(&*var) weak_##var = var;
#define ESWeakSelf      ESWeak(self);

#define ESStrong(var)   __strong __typeof(&*weak_##var) _##var = weak_##var;
#define ESStrongSelf    ESStrong(self); if (!_self) return;

/**
 * Bits-mask helper.
 */
#define ESMaskIsSet(value, flag)    (((value) & (flag)) == (flag))
#define ESMaskSet(value, flag)      ((value) |= (flag));
#define ESMaskUnset(value, flag)    ((value) &= ~(flag));

/**
 * Defines a key for the associcated object.
 */
#define ESDefineAssociatedObjectKey(name) static const void * name##Key = &name##Key;

#pragma mark - Constants

#define ES_MINUTE   (60)
#define ES_HOUR     (3600)
#define ES_DAY      (86400)
#define ES_5_DAYS   (432000)
#define ES_WEEK     (604800)
#define ES_MONTH    (2635200)  /* 30.5 days */
#define ES_YEAR     (31536000) /* 365 days */

#endif /* ESFramework_ESMacros_h */
