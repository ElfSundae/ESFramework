//
//  ESValue.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-3.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESValue : NSObject

@end


ES_EXTERN_C_BEGIN
/**
 * Get value from NSNumber or NSString safely.
 */
BOOL ESIntVal(int *var, id obj);
BOOL ESUIntVal(unsigned int *var, id obj);
BOOL ESIntegerVal(NSInteger *var, id obj);
BOOL ESUIntegerVal(NSUInteger *var, id obj);
BOOL ESLongVal(long *var, id obj);
BOOL ESULongVal(unsigned long *var, id obj);
BOOL ESLongLongVal(long long *var, id obj);
BOOL ESULongLongVal(unsigned long long *var, id obj);
BOOL ESFloatVal(float *var, id obj);
BOOL ESDoubleVal(double *var, id obj);
/**
 * If #obj is a NSString instance, returns YES on encountering one of "Y",
 * "y", "T", "t", or a digit 1-9. It ignores any trailing characters.
 */
BOOL ESBoolVal(BOOL *var, id obj);
BOOL ESStringVal(NSString **var, id obj);
ES_EXTERN_C_END