//
//  ESValue.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-3.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A shared NSNumberFormatter instance.
 */
FOUNDATION_EXTERN NSNumberFormatter *ESSharedNumberFormatter(void);

/**
 * Convert NSString to NSNumber using `ESSharedNumberFormatter()`
 */
FOUNDATION_EXTERN NSNumber *NSNumberFromString(NSString *string);


///=============================================
/// @name ESValueWithDefault
///=============================================

/*!
 * Gets value from NSNumber or NSString safely.
 *
 * If the given object is parsed failed, these functions will return the given defaultValue.
 */

FOUNDATION_EXTERN int ESIntValueWithDefault(id obj, int defaultValue);
FOUNDATION_EXTERN unsigned int ESUIntValueWithDefault(id obj, unsigned int defaultValue);
FOUNDATION_EXTERN NSInteger ESIntegerValueWithDefault(id obj, NSInteger defaultValue);
FOUNDATION_EXTERN NSUInteger ESUIntegerValueWithDefault(id obj, NSUInteger defaultValue);
FOUNDATION_EXTERN long ESLongValueWithDefault(id obj, long defaultValue);
FOUNDATION_EXTERN unsigned long ESULongValueWithDefault(id obj, unsigned long defaultValue);
FOUNDATION_EXTERN long long ESLongLongValueWithDefault(id obj, long long defaultValue);
FOUNDATION_EXTERN unsigned long long ESULongLongValueWithDefault(id obj, unsigned long long defaultValue);
FOUNDATION_EXTERN float ESFloatValueWithDefault(id obj, float defaultValue);
FOUNDATION_EXTERN double ESDoubleValueWithDefault(id obj, double defaultValue);
FOUNDATION_EXTERN BOOL ESBoolValueWithDefault(id obj, BOOL defaultValue);
FOUNDATION_EXTERN NSString *ESStringValueWithDefault(id obj, NSString *defaultValue);
FOUNDATION_EXTERN NSURL *ESURLValueWithDefault(id obj, NSURL *defaultValue);

///=============================================
/// @name ESValue
///=============================================

/*!
 * Gets value from NSNumber or NSString safely.
 *
 * If the given object is parsed failed, these functions will return the default value for the
 * return type. For example, the default value of `int` type is 0, the default value of `NSString`
 * or other NSObject instances is nil.
 */
FOUNDATION_EXTERN int ESIntValue(id obj);
FOUNDATION_EXTERN unsigned int ESUIntValue(id obj);
FOUNDATION_EXTERN NSInteger ESIntegerValue(id obj);
FOUNDATION_EXTERN NSUInteger ESUIntegerValue(id obj);
FOUNDATION_EXTERN long ESLongValue(id obj);
FOUNDATION_EXTERN unsigned long ESULongValue(id obj);
FOUNDATION_EXTERN long long ESLongLongValue(id obj);
FOUNDATION_EXTERN unsigned long long ESULongLongValue(id obj);
FOUNDATION_EXTERN float ESFloatValue(id obj);
FOUNDATION_EXTERN double ESDoubleValue(id obj);
FOUNDATION_EXTERN BOOL ESBoolValue(id obj);
FOUNDATION_EXTERN NSString *ESStringValue(id obj);
FOUNDATION_EXTERN NSURL *ESURLValue(id obj);

///=============================================
/// @name ESVal
///=============================================

/*!
 * Gets value from NSNumber or NSString safely.
 *
 * If the given object is parsed failed, these functions will return NO, and the old value stored in
 * the parameter `var` will no changes.
 */
FOUNDATION_EXTERN BOOL ESIntVal(int *var, id obj);
FOUNDATION_EXTERN BOOL ESUIntVal(unsigned int *var, id obj);
FOUNDATION_EXTERN BOOL ESIntegerVal(NSInteger *var, id obj);
FOUNDATION_EXTERN BOOL ESUIntegerVal(NSUInteger *var, id obj);
FOUNDATION_EXTERN BOOL ESLongVal(long *var, id obj);
FOUNDATION_EXTERN BOOL ESULongVal(unsigned long *var, id obj);
FOUNDATION_EXTERN BOOL ESLongLongVal(long long *var, id obj);
FOUNDATION_EXTERN BOOL ESULongLongVal(unsigned long long *var, id obj);
FOUNDATION_EXTERN BOOL ESFloatVal(float *var, id obj);
FOUNDATION_EXTERN BOOL ESDoubleVal(double *var, id obj);
FOUNDATION_EXTERN BOOL ESBoolVal(BOOL *var, id obj);
FOUNDATION_EXTERN BOOL ESStringVal(NSString **var, id obj);
FOUNDATION_EXTERN BOOL ESURLVal(NSURL **var, id obj);
