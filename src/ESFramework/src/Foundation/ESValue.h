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


#if defined(__cplusplus)
extern "C" {
#endif
        /**
         * Get value from NSNumber or NSString safely.
         */
        BOOL esIntVal(int *var, id obj);
        BOOL esUIntVal(unsigned int *var, id obj);
        BOOL esIntegerVal(NSInteger *var, id obj);
        BOOL esUIntegerVal(NSUInteger *var, id obj);
        BOOL esLongVal(long *var, id obj);
        BOOL esULongVal(unsigned long *var, id obj);
        BOOL esLongLongVal(long long *var, id obj);
        BOOL esULongLongVal(unsigned long long *var, id obj);
        BOOL esFloatVal(float *var, id obj);
        BOOL esDoubleVal(double *var, id obj);
        /**
         * If #obj is a NSString instance, returns YES on encountering one of "Y",
         * "y", "T", "t", or a digit 1-9. It ignores any trailing characters.
         */
        BOOL esBoolVal(BOOL *var, id obj);
        BOOL esStringVal(NSString **var, id obj);
#if defined(__cplusplus)
}
#endif
