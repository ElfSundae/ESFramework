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
/**
 * If #obj is a NSString instance, returns YES on encountering one of "Y",
 * "y", "T", "t", or a digit 1-9. It ignores any trailing characters.
 */
ES_EXTERN BOOL ESBoolVal(BOOL *var, id obj);
ES_EXTERN BOOL ESStringVal(NSString **var, id obj);
ES_EXTERN BOOL ESURLVal(NSURL **var, id obj);
