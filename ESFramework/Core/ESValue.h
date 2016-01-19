//
//  ESValue.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-3.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESDefines.h"

/**
 * A shared NSNumberFormatter instance.
 */
ES_EXTERN NSNumberFormatter *ESSharedNumberFormatter(void);

/**
 * Convert NSString to NSNumber.
 */
ES_EXTERN NSNumber *NSNumberFromString(NSString *string);


///=============================================
/// @name ESValueWithDefault
///=============================================

/*!
 * Gets value from NSNumber or NSString safely.
 *
 * If the given object is parsed failed, these functions will return the given defaultValue.
 */

ES_EXTERN int ESIntValueWithDefault(id obj, int defaultValue);
ES_EXTERN unsigned int ESUIntValueWithDefault(id obj, unsigned int defaultValue);
ES_EXTERN NSInteger ESIntegerValueWithDefault(id obj, NSInteger defaultValue);
ES_EXTERN NSUInteger ESUIntegerValueWithDefault(id obj, NSUInteger defaultValue);
ES_EXTERN long ESLongValueWithDefault(id obj, long defaultValue);
ES_EXTERN unsigned long ESULongValueWithDefault(id obj, unsigned long defaultValue);
ES_EXTERN long long ESLongLongValueWithDefault(id obj, long long defaultValue);
ES_EXTERN unsigned long long ESULongLongValueWithDefault(id obj, unsigned long long defaultValue);
ES_EXTERN float ESFloatValueWithDefault(id obj, float defaultValue);
ES_EXTERN double ESDoubleValueWithDefault(id obj, double defaultValue);
ES_EXTERN BOOL ESBoolValueWithDefault(id obj, BOOL defaultValue);
ES_EXTERN NSString *ESStringValueWithDefault(id obj, NSString *defaultValue);
ES_EXTERN NSURL *ESURLValueWithDefault(id obj, NSURL *defaultValue);

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
ES_EXTERN int ESIntValue(id obj);
ES_EXTERN unsigned int ESUIntValue(id obj);
ES_EXTERN NSInteger ESIntegerValue(id obj);
ES_EXTERN NSUInteger ESUIntegerValue(id obj);
ES_EXTERN long ESLongValue(id obj);
ES_EXTERN unsigned long ESULongValue(id obj);
ES_EXTERN long long ESLongLongValue(id obj);
ES_EXTERN unsigned long long ESULongLongValue(id obj);
ES_EXTERN float ESFloatValue(id obj);
ES_EXTERN double ESDoubleValue(id obj);
ES_EXTERN BOOL ESBoolValue(id obj);
ES_EXTERN NSString *ESStringValue(id obj);
ES_EXTERN NSURL *ESURLValue(id obj);

///=============================================
/// @name ESVal
///=============================================

/*!
 * Gets value from NSNumber or NSString safely.
 *
 * If the given object is parsed failed, these functions will return NO, and the old value stored in
 * the parameter `var` will no changes.
 */
ES_EXTERN BOOL ESIntVal(int *var, id obj);
ES_EXTERN BOOL ESUIntVal(unsigned int *var, id obj);
ES_EXTERN BOOL ESIntegerVal(NSInteger *var, id obj);
ES_EXTERN BOOL ESUIntegerVal(NSUInteger *var, id obj);
ES_EXTERN BOOL ESLongVal(long *var, id obj);
ES_EXTERN BOOL ESULongVal(unsigned long *var, id obj);
ES_EXTERN BOOL ESLongLongVal(long long *var, id obj);
ES_EXTERN BOOL ESULongLongVal(unsigned long long *var, id obj);
ES_EXTERN BOOL ESFloatVal(float *var, id obj);
ES_EXTERN BOOL ESDoubleVal(double *var, id obj);
ES_EXTERN BOOL ESBoolVal(BOOL *var, id obj);
ES_EXTERN BOOL ESStringVal(NSString **var, id obj);
ES_EXTERN BOOL ESURLVal(NSURL **var, id obj);
