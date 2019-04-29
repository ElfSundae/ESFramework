//
//  ESValue.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-3.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// =============================================
/// @name ESValueWithDefault
/// =============================================

/*!
 * Gets value from NSNumber or NSString safely.
 *
 * If the given object is parsed failed, these functions will return the given default value.
 */

FOUNDATION_EXTERN int ESIntValueWithDefault(id _Nullable obj, int defaultValue);
FOUNDATION_EXTERN unsigned int ESUIntValueWithDefault(id _Nullable obj, unsigned int defaultValue);
FOUNDATION_EXTERN NSInteger ESIntegerValueWithDefault(id _Nullable obj, NSInteger defaultValue);
FOUNDATION_EXTERN NSUInteger ESUIntegerValueWithDefault(id _Nullable obj, NSUInteger defaultValue);
FOUNDATION_EXTERN long ESLongValueWithDefault(id _Nullable obj, long defaultValue);
FOUNDATION_EXTERN unsigned long ESULongValueWithDefault(id _Nullable obj, unsigned long defaultValue);
FOUNDATION_EXTERN long long ESLongLongValueWithDefault(id _Nullable obj, long long defaultValue);
FOUNDATION_EXTERN unsigned long long ESULongLongValueWithDefault(id _Nullable obj, unsigned long long defaultValue);
FOUNDATION_EXTERN float ESFloatValueWithDefault(id _Nullable obj, float defaultValue);
FOUNDATION_EXTERN double ESDoubleValueWithDefault(id _Nullable obj, double defaultValue);
FOUNDATION_EXTERN BOOL ESBoolValueWithDefault(id _Nullable obj, BOOL defaultValue);
FOUNDATION_EXTERN NSString * _Nullable ESStringValueWithDefault(id _Nullable obj, NSString * _Nullable defaultValue);
FOUNDATION_EXTERN NSURL * _Nullable ESURLValueWithDefault(id _Nullable obj, NSURL * _Nullable defaultValue);

/// =============================================
/// @name ESValue
/// =============================================

/*!
 * Gets value from NSNumber or NSString safely.
 *
 * If the given object is parsed failed, these functions will return the default value for the
 * return type. For example, the default value of `int` type is 0, the default value of `NSString`
 * or other NSObject instances is nil.
 */
FOUNDATION_EXTERN int ESIntValue(id _Nullable obj);
FOUNDATION_EXTERN unsigned int ESUIntValue(id _Nullable obj);
FOUNDATION_EXTERN NSInteger ESIntegerValue(id _Nullable obj);
FOUNDATION_EXTERN NSUInteger ESUIntegerValue(id _Nullable obj);
FOUNDATION_EXTERN long ESLongValue(id _Nullable obj);
FOUNDATION_EXTERN unsigned long ESULongValue(id _Nullable obj);
FOUNDATION_EXTERN long long ESLongLongValue(id _Nullable obj);
FOUNDATION_EXTERN unsigned long long ESULongLongValue(id _Nullable obj);
FOUNDATION_EXTERN float ESFloatValue(id _Nullable obj);
FOUNDATION_EXTERN double ESDoubleValue(id _Nullable obj);
FOUNDATION_EXTERN BOOL ESBoolValue(id _Nullable obj);
FOUNDATION_EXTERN NSString * _Nullable ESStringValue(id _Nullable obj);
FOUNDATION_EXTERN NSURL * _Nullable ESURLValue(id _Nullable obj);

/// =============================================
/// @name ESVal
/// =============================================

/*!
 * Gets value from NSNumber or NSString safely.
 *
 * Invoke these methods with NULL as var to simply detect past the type representation.
 */
FOUNDATION_EXTERN BOOL ESIntVal(int *var, id _Nullable obj);
FOUNDATION_EXTERN BOOL ESUIntVal(unsigned int *var, id _Nullable obj);
FOUNDATION_EXTERN BOOL ESIntegerVal(NSInteger *var, id _Nullable obj);
FOUNDATION_EXTERN BOOL ESUIntegerVal(NSUInteger *var, id _Nullable obj);
FOUNDATION_EXTERN BOOL ESLongVal(long *var, id _Nullable obj);
FOUNDATION_EXTERN BOOL ESULongVal(unsigned long *var, id _Nullable obj);
FOUNDATION_EXTERN BOOL ESLongLongVal(long long *var, id _Nullable obj);
FOUNDATION_EXTERN BOOL ESULongLongVal(unsigned long long *var, id _Nullable obj);
FOUNDATION_EXTERN BOOL ESFloatVal(float *var, id _Nullable obj);
FOUNDATION_EXTERN BOOL ESDoubleVal(double *var, id _Nullable obj);
FOUNDATION_EXTERN BOOL ESBoolVal(BOOL *var, id _Nullable obj);
FOUNDATION_EXTERN BOOL ESStringVal(NSString * _Nullable * _Nullable var, id _Nullable obj);
FOUNDATION_EXTERN BOOL ESURLVal(NSURL * _Nullable * _Nullable var, id _Nullable obj);

NS_ASSUME_NONNULL_END
