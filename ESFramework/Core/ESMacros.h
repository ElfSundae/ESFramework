//
//  ESMacros.h
//  ESFramework
//
//  Created by Elf Sundae on 2014/04/02.
//  Copyright © 2014 https://0x123.com. All rights reserved.
//

#ifndef ESFramework_ESMacros_h
#define ESFramework_ESMacros_h

#import <Foundation/Foundation.h>

#if !defined(__FILENAME__)
#define __FILENAME__ (strrchr("/" __FILE__, '/') + 1)
#endif

#if !defined(NSLog)
#if defined(DEBUG) && DEBUG
#define NSLog(format, ...) NSLog((@"%s:%d %s " format), __FILENAME__, __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__)
#else
#define NSLog(format, ...)
#endif
#endif

#if !defined(NSLogIf)
#if defined(DEBUG) && DEBUG
#define NSLogIf(condition, format, ...) if ((condition)) { NSLog(format, ##__VA_ARGS__); }
#else
#define NSLogIf(condition, format, ...)
#endif
#endif

/**
 * Make weak references to objects to break "retain cycles".
 */
#define ESWeak(var)     __weak __typeof(&*var) weak_##var = var;
#define ESWeakSelf      ESWeak(self);

#define ESStrong(var)   __strong __typeof(&*weak_##var) _##var = weak_##var;
#define ESStrongSelf    ESStrong(self); if (!_self) return;

/**
 * Bits-mask helpers.
 */
#define ESMaskIsSet(value, flag)    (((value) & (flag)) == (flag))
#define ESMaskSet(value, flag)      ((value) |= (flag))
#define ESMaskUnset(value, flag)    ((value) &= ~(flag))

#endif /* ESFramework_ESMacros_h */
