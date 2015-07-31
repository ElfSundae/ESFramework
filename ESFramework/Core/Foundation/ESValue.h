//
//  ESValue.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-3.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ESDefines.h"

/*!
 * Get value from NSNumber or NSString safely.
 * 如果解析失败，返回对应类型的默认值， 0, 0.0, nil
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

/*!
 * Get value from NSNumber or NSString safely.
 * 如果解析失败，返回NO并且不改变var的原值
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
