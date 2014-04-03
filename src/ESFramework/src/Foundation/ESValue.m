//
//  ESValue.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-3.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import "ESValue.h"

static NSNumberFormatter *__shared_numberFormatter = nil;

@implementation ESValue

+ (void)load
{
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                __shared_numberFormatter = [[NSNumberFormatter alloc] init];
        });
}

@end


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 

BOOL esIntVal(int *var, id obj)
{
        if (obj && ([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]])) {
                *var = [obj intValue];
                return YES;
        }
        return NO;
}

BOOL esUIntVal(unsigned int *var, id obj)
{
        if (obj) {
                if ([obj isKindOfClass:[NSNumber class]]) {
                        *var = [obj unsignedIntValue];
                        return YES;
                } else if ([obj isKindOfClass:[NSString class]]) {
                        *var = [[__shared_numberFormatter numberFromString:obj] unsignedIntValue];
                        return YES;
                }
        }
        return NO;
}

BOOL esIntegerVal(NSInteger *var, id obj)
{
        if (obj && ([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]])) {
                *var = [obj integerValue];
                return YES;
        }
        return NO;
}

BOOL esUIntegerVal(NSUInteger *var, id obj)
{
        if (obj) {
                if ([obj isKindOfClass:[NSNumber class]]) {
                        *var = [obj unsignedIntegerValue];
                        return YES;
                } else if ([obj isKindOfClass:[NSString class]]) {
                        *var = [[__shared_numberFormatter numberFromString:obj] unsignedIntegerValue];
                        return YES;
                }
        }
        return NO;
}

BOOL esLongVal(long *var, id obj)
{
        if (obj) {
                if ([obj isKindOfClass:[NSNumber class]]) {
                        *var = [obj longValue];
                        return YES;
                } else if ([obj isKindOfClass:[NSString class]]) {
                        *var = [[__shared_numberFormatter numberFromString:obj] longValue];
                        return YES;
                }
        }
        return NO;
}

BOOL esULongVal(unsigned long *var, id obj)
{
        if (obj) {
                if ([obj isKindOfClass:[NSNumber class]]) {
                        *var = [obj unsignedLongValue];
                        return YES;
                } else if ([obj isKindOfClass:[NSString class]]) {
                        *var = [[__shared_numberFormatter numberFromString:obj] unsignedLongValue];
                        return YES;
                }
        }
        return NO;
}

BOOL esLongLongVal(long long *var, id obj)
{
        if (obj && ([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]])) {
                *var = [obj longLongValue];
                return YES;
        }
        return NO;
}

BOOL esULongLongVal(unsigned long long *var, id obj)
{
        if (obj) {
                if ([obj isKindOfClass:[NSNumber class]]) {
                        *var = [obj unsignedLongLongValue];
                        return YES;
                } else if ([obj isKindOfClass:[NSString class]]) {
                        *var = [[__shared_numberFormatter numberFromString:obj] unsignedLongLongValue];
                        return YES;
                }
        }
        return NO;
}

BOOL esFloatVal(float *var, id obj)
{
        if (obj && ([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]])) {
                *var = [obj floatValue];
                return YES;
        }
        return NO;
}

BOOL esDoubleVal(double *var, id obj)
{
        if (obj && ([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]])) {
                *var = [obj doubleValue];
                return YES;
        }
        return NO;
}

/**
 * If @obj is a NSString instance, returns YES on encountering one of "Y",
 * "y", "T", "t", or a digit 1-9. It ignores any trailing characters.
 */
BOOL esBoolVal(BOOL *var, id obj)
{
        if (obj && ([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]])) {
                *var = [obj boolValue];
                return YES;
        }
        return NO;
}

BOOL esStringVal(NSString **var, id obj)
{
        if (obj) {
                if ([obj isKindOfClass:[NSString class]]) {
                        *var = obj;
                        return YES;
                } else if ([obj isKindOfClass:[NSNumber class]]) {
                        *var = [obj stringValue];
                        return YES;
                }
        }
        return NO;
}
