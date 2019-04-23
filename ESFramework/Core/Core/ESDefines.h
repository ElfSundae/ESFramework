//
//  ESDefines.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-2.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#ifndef ESFramework_ESDefines_h
#define ESFramework_ESDefines_h

#import <mach/mach_time.h>
#import "ESHelpers.h"
#import "NSInvocation+ESHelper.h"

#pragma mark - Log

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
 * Log the execution time.
 */

#if DEBUG
#define ES_STOPWATCH_BEGIN(stopwatch_begin_var) uint64_t stopwatch_begin_var = mach_absolute_time();
#define ES_STOPWATCH_END(stopwatch_begin_var) { \
        uint64_t end = mach_absolute_time(); \
        mach_timebase_info_data_t timebaseInfo; \
        (void)mach_timebase_info(&timebaseInfo); \
        uint64_t elapsedNano = (end - stopwatch_begin_var) * timebaseInfo.numer / timebaseInfo.denom; \
        double_t elapsedMillisecond = (double_t)elapsedNano / 1000000.0; \
        printf("‼️STOPWATCH‼️ [%s:%d] %s %fms\n", [NSString stringWithUTF8String:__FILE__].lastPathComponent.UTF8String, __LINE__, __PRETTY_FUNCTION__, elapsedMillisecond); \
}
#else
#define ES_STOPWATCH_BEGIN(stopwatch_begin_var)
#define ES_STOPWATCH_END(stopwatch_begin_var)
#endif

/// =============================================
/// @name Constants
/// =============================================
#pragma mark - Constants

#define ES_MINUTE   (60)
#define ES_HOUR     (3600)
#define ES_DAY      (86400)
#define ES_5_DAYS   (432000)
#define ES_WEEK     (604800)
#define ES_MONTH    (2635200) /* 30.5 days */
#define ES_YEAR     (31536000) /* 365 days */

/// =============================================
/// @name Helper Macros
/// =============================================
#pragma mark - Helper Macros

/**
 * Make weak references to break "retain cycles".
 */
#define ESWeak_(var, weakVar)                   __weak __typeof(&*var) weakVar = var;
#define ESWeak(var)                             ESWeak_(var, weak_##var);
#define ESWeakSelf                              ESWeak(self);

#define ESStrong_DoNotCheckNil(weakVar, var)    __typeof(&*weakVar) var = weakVar;
#define ESStrong_(weakVar, var)                 ESStrong_DoNotCheckNil(weakVar, var); if (!var) return;
#define ESStrong(var)                           ESStrong_(weak_##var, _##var);
#define ESStrongSelf                            ESStrong(self);

/**
 * Bits-mask helper.
 */
#define ESMaskIsSet(value, flag)        (((value) & (flag)) == (flag))
#define ESMaskSet(value, flag)          ((value) |= (flag));
#define ESMaskUnset(value, flag)        ((value) &= ~(flag));

/**
 * Defines a key for the associcated object.
 */
#define ESDefineAssociatedObjectKey(name) static const void * name##Key = &name##Key;

#endif /* ESFramework_ESDefines_h */
